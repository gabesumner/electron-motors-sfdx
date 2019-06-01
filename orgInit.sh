#sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -w 60
sfdx force:org:create -f config/project-scratch-def.json -s -w 60

# Analytics doesn't deploy without a permset and that will block the deployment of the permset
# Copy a special .forceignore file that will ignore all Analytics resources 
cp .forceignore.pre .forceignore
sfdx force:source:push
sfdx force:user:permset:assign -n electron
sfdx force:apex:execute -f scripts/assignAnalyticsPermset.apex

# The Permset is now deployed and applied, so we can restore the original .forceignore
# Then we can deploy all Analytics resources.
cp .forceignore.post .forceignore
sfdx force:source:deploy --sourcepath ./force-app/main/default/wave
sfdx force:source:deploy --sourcepath ./force-app/main/default/flexipages

# Create the demo accounts
sfdx force:apex:execute -f scripts/createDemoRecords.apex

sfdx force:org:open
sfdx shane:user:password:set -g Admin -l User -p sfdx1234