In Bicep, decorators are annotations (metadata) that you attach to parameters, variables, resources, modules, or outputs to modify their behavior, add validation, provide defaults, or give helpful descriptions.

They start with the @ symbol and are placed before the declaration.

🔹 Common Bicep Decorators
Decorator	Used With	Purpose / Description	Example
@description()	parameters, variables, outputs	Adds a human-readable description (helpful in ARM portal or docs).	@description('The name of the storage account.')
@minLength()	parameters	Enforces a minimum string/array length.	@minLength(3)
@maxLength()	parameters	Enforces a maximum string/array length.	@maxLength(24)
@allowed()	parameters	Restricts allowed values to a list.	@allowed(['eastus', 'westus'])
@secure()	parameters	Marks parameter as secure (hidden in outputs/logs).	@secure()
@minValue()	parameters	Enforces minimum numeric value.	@minValue(1)
@maxValue()	parameters	Enforces maximum numeric value.	@maxValue(10)
@batchSize()	module	Controls parallel deployment of module instances.	@batchSize(5)
@sys.* decorators	resources	Add metadata for Azure features like diagnostic settings or RBAC.	@sys.lock('CanNotDelete')
🔹 Example: Parameter Decorators
@description('Specifies the Azure region for deployment.')
@allowed([
  'eastus'
  'westus'
  'centralus'
])
param location string = 'eastus'

@description('The name of the storage account.')
@minLength(3)
@maxLength(24)
param storageAccountName string


This adds:

Validation (only certain locations)

Constraints (length rules)

Description (for clarity in the Azure portal)

🔹 Example: Secure Parameter
@secure()
@description('Admin password for the VM.')
param adminPassword string


👉 The password will be hidden in deployment logs and outputs.

🔹 Example: Module Decorator
@batchSize(3)
module storageModule './storage.bicep' = [for i in range(0, 10): {
  name: 'storage${i}'
  params: {
    location: location
  }
}]


➡ Deploys storage modules in batches of 3 at a time (instead of all 10 simultaneously).


To validate all the values and syntax mentioned in all files, we can use 'validate' command.
```eg: az deployment group validate --name decoratorDeployment --resource-group snbiceprg  --template-file main.bicep  --parameters  paramvalues.bicepparam```

if 'validate' is success, list of resources to be created would be displayed in JSON format
Then we can move to actual 'create' command
```az deployment group create --name decoratorDeployment --resource-group snbiceprg  --template-file main.bicep  --parameters  paramvalues.bicepparam```