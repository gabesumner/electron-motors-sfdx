#sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -w 60
sfdx force:org:create -f config/project-scratch-def.json -s -w 60

# Analytics doesn't deploy without a permset and that will block the deployment of the permset
# I removed the problematic files to ~/custom and we'll deploy them after we have the permset set.
sfdx force:source:push
sfdx force:user:permset:assign -n electron
sfdx force:apex:execute -f scripts/assignAnalyticsPermset.apex

# The Permset is now deployed and applied, so we can restore the original .forceignore
# Now deploy the files we skipped.
sfdx force:source:deploy --sourcepath ./custom/wave
sfdx force:source:deploy --sourcepath ./custom/flexipages/Finance_Home1.flexipage-meta.xml

# Create the demo accounts
sfdx force:apex:execute -f scripts/createDemoRecords.apex

sfdx force:org:open
sfdx shane:user:password:set -g Admin -l User -p sfdx1234