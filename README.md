(The file is currently empty)
# Azure Bicep — 3 Stages Deployment

This repository contains an Azure Infrastructure-as-Code example using Bicep with reusable modules and environment parameter sets for three stages (dev, stage, prod). The project demonstrates organizing Bicep modules, environment parameter files, and simple deployment commands for a VM scale set and related infrastructure.

Contents
- `main.bicep` — root orchestration file for the deployment
- `main_for_vmss.bicep` — alternative root file targeting VM Scale Set scenarios
- `modules/` — reusable component modules (vnet, nic, nsg, publicip, vm, rg, storage, stg-accnt)
- `environments/` — environment-specific parameter files
	- `dev/`, `stage/`, `prod/` — parameter sets (example: `dev_paramvalues.bicepparam`)
- `decorators_examples/` — additional example Bicep files using decorators
- `deployment-command.txt` — example az CLI commands for validate and create

Why this layout
- Modules are placed under `modules/` so they can be referenced from `main.bicep` and re-used across environments.
- Environment parameter files keep environment differences (size, names, credentials) out of templates.

Prerequisites
- Azure CLI (az) installed and logged in. Recommended version: latest.
- Bicep CLI or Azure CLI with integrated Bicep support (az bicep) installed. Example to install/update:

	```bash
	az bicep install
	az --version
	```

- An Azure subscription and a resource group to deploy into. Example resource group used in examples: `snbiceprg`.

Basic deployment workflow

1. Validate the deployment (checks template and parameters):

```bash
az deployment group validate \
	--name vmscalesetdeploy \
	--resource-group <your-resource-group> \
	--template-file main.bicep \
	--parameters ./environments/dev/dev_paramvalues.bicepparam \
	--mode Incremental
```

2. Create (deploy) the resources:

```bash
az deployment group create \
	--name vmscalesetdeploy \
	--resource-group <your-resource-group> \
	--template-file main.bicep \
	--parameters ./environments/dev/dev_paramvalues.bicepparam \
	--mode Incremental
```

3. Example: pass a VM admin password at runtime (not recommended for CI — prefer Key Vault or secure pipeline variables):

```bash
az deployment group create \
	--name envDeployment \
	--resource-group <your-resource-group> \
	--template-file main.bicep \
	--parameters ./environments/dev/dev_paramvalues.bicepparam \
	--parameters vmAdminPassword='<vmPassword>' \
	--mode Incremental
```

Selecting environment and files
- To deploy a different environment, point `--parameters` to the respective file, e.g. `./environments/stage/stage_paramvalues.bicepparam` or `./environments/prod/prod_paramvalues.bicepparam` (if present).
- If you want to use the VMSS-specific root, use `main_for_vmss.bicep` as `--template-file`.

Recommendations for secrets
- Do NOT store secrets (passwords, client secrets) in source control. Use Azure Key Vault and reference secrets at deployment time via parameters or linked templates.
- In CI/CD pipelines use secure variables and service principals with minimal scope.

CI/CD and automation notes
- These commands can be executed from Azure DevOps, GitHub Actions, or any CI runner with az CLI installed. Example high-level steps for a pipeline:
	1. Login using a service principal (az login --service-principal ...)
	2. Select subscription (az account set --subscription <id>)
	3. Run `az deployment group validate` then `az deployment group create`.
    4. Multi stage deployment set up as per workflos in .github folder
       ![alt text](<Screenshot 2025-10-17 at 10.08.09 AM.png>)

Troubleshooting
- Template errors: run `az bicep build --file main.bicep` to ensure compilation to ARM JSON works.
- Parameter mismatches: check parameter names/types between `main.bicep` and the `.bicepparam` file.
- Permission errors: ensure your identity has `Microsoft.Resources/deployments/*` and resource provider registration is complete for required resource types.

Useful commands
- Build Bicep to ARM JSON:

```bash
az bicep build --file main.bicep --outdir ./compiled
```

- Lint/format using Bicep linter (if installed):

```bash
az bicep lint --file main.bicep
```

Repository tips
- Keep modules small and focused (one responsibility each: network, compute, storage).
- Refer to modules using relative paths from `main.bicep`, for example:

```bicep
module vnet 'modules/vnet/vnet.bicep' = {
	name: 'vnet'
	params: {}
}
```

- Add environment-specific overrides only in the `.bicepparam` files.

Next steps (suggested)
- Add a CI pipeline example (GitHub Actions or Azure DevOps) that runs validate -> create using service principal credentials and secrets stored in Key Vault.
- Add a `CONTRIBUTING.md` if you'll accept external contributions and want consistent parameter/variable patterns.
