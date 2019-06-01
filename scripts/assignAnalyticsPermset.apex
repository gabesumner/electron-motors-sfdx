User u = [SELECT ID FROM User WHERE Name='Integration User'];
PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'analytics'];
INSERT new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);