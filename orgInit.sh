
# Create the scratch org (uncomment for local development)
# sfdx force:org:delete -u electron-motors-sfdx
# sfdx force:org:create -f config/project-scratch-def.json --setalias electron-motors-sfdx --setdefaultusername

# Create the scratch org (uncomment for the SFDX Deployer)
sfdx shane:org:create -f config/project-scratch-def.json -d 30 -s -n --userprefix admin --userdomain electron.demo

# Push the metadata into the new scratch org.
sfdx force:source:push

# Assign the permset to the default admin user.
sfdx force:user:permset:assign -n electron

# Assign a special analytics (non-Modify-All) permset to the Integration User used by Einstein Analytics
sfdx shane:user:permset:assign -n analytics -g Integration -l User

# Import the data required by the demo
sfdx automig:load --inputdir ./data --deletebeforeload

# Deploy the metadata for the the dataflow (this needed to happen AFTER the other meta data was pushed and the permset was applied to the Integration user)
sfdx force:source:deploy -p dataflow

# Start the dataflow for the Analytics.
sfdx shane:analytics:dataflow:start -n Electron

# Deploy the metadata for the visualizations
sfdx force:source:deploy -p visualizations

# Activate the custom theme.
sfdx shane:theme:activate -n Electron

# Set the default password.
sfdx shane:user:password:set -g User -l User -p sfdx1234

# Create records for prediction builder.
sfdx force:apex:execute -f ./scripts/createPredictionAccounts.apex
sfdx force:apex:execute -f ./scripts/createPredictionAccounts.apex
sfdx force:apex:execute -f ./scripts/createPredictionAccounts.apex
sfdx force:apex:execute -f ./scripts/createPredictionAccounts.apex

# Open the demo org.
sfdx force:org:open

