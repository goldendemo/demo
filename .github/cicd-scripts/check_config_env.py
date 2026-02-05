#!/usr/bin/env python3
"""Check config file for explicit environment_name."""
import yaml
import sys

try:
    with open('.maia-experience/maia_demo_config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    env_name = config.get('environment_name', '')
    print(env_name if env_name else '')
except Exception:
    print('')
