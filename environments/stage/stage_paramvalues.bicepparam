using '../../main.bicep'

param envPrefix = 'stage'
param location = 'eastus2'
param vmNameFromParams = 'stageLinuxVM'
param vmAdminUsername = '<passfromsecret>'
param vmAdminPassword = '<passfromsecret>'
