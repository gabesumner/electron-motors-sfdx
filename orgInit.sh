sfdx force:org:create -f config/project-scratch-def.json -d 1 -s -w 60
sfdx force:source:push
sfdx force:user:permset:assign -n electron
sfdx force:org:open