import os
import requests
import subprocess
from pathlib import Path
import json
import enum
from dataclasses import dataclass, field
from collections import namedtuple

# Load secrets from environment variables
client_id = os.getenv("DPC_CLIENT_ID")
client_secret = os.getenv("DPC_CLIENT_SECRET")
token_url = os.getenv("DPC_TOKEN_URL")
project_id = os.getenv("DPC_PROJECT_ID")
account_region = os.getenv("DPC_ACCOUNT_REGION")
version_name = os.getenv("VERSION_NAME")
branch_name = os.getenv("BRANCH_NAME")

# Read environment name from environment variable (passed from workflow)
# Falls back to 'demo' if not provided
tst_environment_name = os.getenv("DPC_ENVIRONMENT_NAME", "demo")
print(f"Using environment name: {tst_environment_name}")

# NEW: Read checkpoint_description from environment variable (passed from workflow)
# If empty or not provided, the pipeline will use its default value
checkpoint_description = os.getenv("DPC_CHECKPOINT_DESCRIPTION", "")
if checkpoint_description:
    print(f"Using checkpoint description: {checkpoint_description}")
else:
    print("No checkpoint description provided, pipeline will use default")

# REVISED: Use the DPC_API_DOMAIN variable directly as requested
api_domain_env = os.getenv("DPC_API_DOMAIN", "api.matillion.com")
api_domain = f"{account_region}.{api_domain_env}"

# Derive DPC API URLs
api_base_url = f"https://{api_domain}/dpc/v1/projects/{project_id}"
artifacts_url = f"{api_base_url}/artifacts"
executions_url = f"{api_base_url}/pipeline-executions"

# Custom and flex connectors are account-level (not project-scoped)
cc_url = f"https://{api_domain}/dpc/v1/custom-connectors"
flex_url = f"https://{api_domain}/dpc/v1/flex-connectors"

print(f"Using API domain: {api_domain}")

print("artifacts_url = " + artifacts_url)
print("version_name = " + version_name)
print("token_url = " + token_url)

### Classes for dealing with custom/flex connectors ####
@dataclass
class PublicationFormEntry:
    key: str
    value: tuple

class PublicationResource:
    def id(self) -> str:
        raise NotImplementedError("id() must be implemented by subclasses.")

    def content(self) -> bytes | str:
        raise NotImplementedError("content() must be implemented by subclasses.")

    def content_type(self) -> str:
        return "text/plain"

    def headers(self) -> dict:
        return {}

    def form_data(self) -> PublicationFormEntry:
        return PublicationFormEntry(
            key=self.id(),
            value=(None, self.content(), self.content_type(), self.headers()),
        )

@dataclass
class FileResource(PublicationResource):
    name: str
    path: str
    type: str = field(default="text/plain")

    def id(self) -> str:
        return self.name

    def content(self) -> bytes:
        with open(self.path, "rb") as f:
            return f.read()

    def content_type(self) -> str:
        return self.type

ConnectorTypeData = namedtuple("ConnectorTypeData", ["id_key", "prefix"])

class ConnectorType(enum.Enum):
    FLEX = ConnectorTypeData("alternateId", "flex")
    CUSTOM = ConnectorTypeData("id", "custom")

    @property
    def id(self):
        return self.value.id_key

    @property
    def prefix(self):
        return self.value.prefix

@dataclass
class ConnectorResource(PublicationResource):
    type: ConnectorType
    connector: dict

    def id(self) -> str:
        if self.type.id not in self.connector:
            raise AttributeError(
                f"{self.type.prefix.title()} Connector does not have an {self.type.id} field."
            )

        return (
            f"connector-profile:{self.type.prefix}-{self.connector[self.type.id]}.json"
        )

    def content(self) -> bytes | str:
        return json.dumps(self.connector)

    def content_type(self) -> str:
        return "application/vnd.matillion.connector-profile+json"

# Step 0: Get Commit Hash
try:
    commit_hash = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode("utf-8").strip()
except subprocess.CalledProcessError:
    print("Error: Unable to retrieve Git commit hash.")
    exit(1)
print("commit_hash = " + commit_hash)

# Step 1: Get OAuth Token
auth_payload = {
    "grant_type": "client_credentials",
    "client_id": client_id,
    "client_secret": client_secret
}

token_response = requests.post(token_url, data=auth_payload)
if token_response.status_code != 200:
    print(f"Failed to obtain token: {token_response.text}")
    exit(1)

access_token = token_response.json().get("access_token")
print("access_token = " + access_token)

# Step 2: Find .yml, .py, .sql files
repo_path = Path(".")
allowed_extensions = {
    ".yaml": "application/vnd.matillion.dpl+yaml",
    ".yml": "application/vnd.matillion.dpl+yaml",
    ".py": "text/plain",
    ".sql": "text/plain"
}
files_to_upload = [FileResource(name=f.relative_to(repo_path).as_posix(), path=str(f), type=allowed_extensions[f.suffix]) 
                   for f in repo_path.rglob("*") if f.suffix in allowed_extensions]

# Step 3: Get Custom and Flex Connectors
print("Fetching custom and flex connectors...")
headers = {
    "Authorization": f"Bearer {access_token}"
}

# Fetch Custom Connectors safely
cc_response = requests.get(cc_url, headers=headers)
if cc_response.status_code == 200 and cc_response.text:
    try:
        for v in cc_response.json():
            files_to_upload.append(ConnectorResource(type=ConnectorType.CUSTOM, connector=v))
        print("Found custom connectors.")
    except json.JSONDecodeError:
        print(f"Warning: Could not decode JSON from CC response: {cc_response.text}")

# Fetch Flex Connectors safely
flex_response = requests.get(flex_url, headers=headers)
if flex_response.status_code == 200 and flex_response.text:
    try:
        for v in flex_response.json():
            files_to_upload.append(ConnectorResource(type=ConnectorType.FLEX, connector=v))
        print("Found flex connectors.")
    except json.JSONDecodeError:
        print(f"Warning: Could not decode JSON from Flex response: {flex_response.text}")

# Step 4: Prepare files for multipart/form-data
files = {f.id(): (f.id(), f.content(), f.content_type()) for f in files_to_upload}

try:
    if not files:
        print("No files or connectors to publish. Exiting.")
        exit(0)

    # Step 5: Make the API call to publish the artifact
    publish_headers = {
        "Authorization": f"Bearer {access_token}",
        "versionName": f"{version_name}",
        "commitHash": f"{commit_hash}",
        "environmentName": f"{tst_environment_name}",
        "branch": f"{branch_name}"
    }
    print("Publishing artifact with headers: " + str(publish_headers))
    response = requests.post(artifacts_url, headers=publish_headers, files=files)

    if response.status_code not in [200, 201]:
        print(f"Failed to upload files: {response.status_code} - {response.text}")
        exit(1)

    print(f"Successfully published artifact version: {version_name}")

    # Step 7: Execute Published Pipeline
    print("\nExecuting the checkpoint-enabled pipeline...")
    execution_headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    execution_payload = {
        "pipelineName": ".maia-experience/sql-init/Maia Init - With Checkpoints",
        "environmentName": tst_environment_name,
        "versionName": version_name
    }
    
    if checkpoint_description:
        execution_payload["scalarVariables"] = {
            "checkpoint_description": checkpoint_description
        }

    print("Executing pipeline with payload: " + json.dumps(execution_payload, indent=2))
    execution_response = requests.post(executions_url, headers=execution_headers, data=json.dumps(execution_payload))

    print(f"Execution Trigger Status: {execution_response.status_code}")
    if execution_response.status_code in [200, 201, 202]:
        print(f"Successfully triggered pipeline execution for version {version_name}.")
    else:
        # FAIL the step on 404 or other errors
        print(f"Failed to execute pipeline: {execution_response.status_code} - {execution_response.text}")
        exit(1)

finally:
    # Close file handles if any open files were in the list
    for file_tuple in files.values():
        file_obj = file_tuple[1]
        if hasattr(file_obj, "close"):
            file_obj.close()
