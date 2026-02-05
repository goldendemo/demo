#!/usr/bin/env python3
"""Check user mapping file for user's environment.

Expects GH_USER environment variable to be set.
Outputs: <env_name>|<source> where source is 'mapped' or 'default'
"""
import yaml
import os
import sys

try:
    with open('.maia-experience/user-environment-mappings.yaml', 'r') as f:
        mappings = yaml.safe_load(f)
    
    user = os.environ.get('GH_USER', '')
    env_name = mappings.get('mappings', {}).get(user, '')
    
    if not env_name:
        # User not in mappings, use default
        env_name = mappings.get('default', 'demo')
        print(f"{env_name}|default")
    else:
        # User found in mappings
        print(f"{env_name}|mapped")
except Exception:
    # Fallback if file doesn't exist or can't be read
    print('demo|default')
