sfdx force:org:create -f config/project-scratch-def.json -d 1 -s -w 60
sfdx force:source:push
sfdx force:org:open