sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -w 60
cp .forceignore.pre .forceignore
sfdx force:source:push
sfdx force:user:permset:assign -n electron
sfdx force:apex:execute -f scripts/assignAnalyticsPermset.apex

cp .forceignore.post .forceignore
sfdx force:source:deploy --sourcepath ./force-app/main/default/wave 

sfdx force:apex:execute -f scripts/createAccounts.apex
sfdx force:apex:execute -f scripts/createDemoRecords.apex

sfdx force:org:open
sfdx shane:user:password:set -g Gabe -l Sumner -p sfdx1234