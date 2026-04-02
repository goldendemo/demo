# Maia Experience Configuration Required

## Status
⚠️ **No Maia Experience automation has been run yet.**

## Next Steps
To configure your personalized Maia demo environment:

### 1. Update Configuration File
Open `.maia-experience/maia_demo_config.yaml` and update the required fields:

```yaml
demo:
  company: "Your Company Name"
  role: "Your Role"
  name: "Your Name"
  description: "Brief description of your data goals"
  environment_name: "demo"
```

### 2. Commit and Push Your Changes
The automation will then process your configuration and provision your environment.

---
**Note:** Alternatively, you can use the `company_role_name` branch naming format (e.g., `Acme_Engineer_John`) to trigger automation immediately upon branch creation.
