#sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -w 60
sfdx force:org:create -f config/project-scratch-def.json -s -w 60

# Analytics doesn't deploy without a permset and that will block the deployment of the permset
# The .forceignore file will exclude the problematic files.
sfdx force:source:push
sfdx force:user:permset:assign -n electron
sfdx force:apex:execute -f scripts/assignAnalyticsPermset.apex

# The Permset is now deployed and applied, so we can restore the original .forceignore
# Now deploy the files we skipped.
sfdx force:source:deploy --sourcepath ./force-app/main/default/wave
sfdx force:source:deploy --sourcepath ./force-app/main/default/flexipages/Finance_Home1.flexipage-meta.xml

# Create the demo accounts
sfdx force:apex:execute -f scripts/createDemoRecords.apex

sfdx force:org:open
sfdx shane:user:password:set -g Admin -l User -p sfdx1234