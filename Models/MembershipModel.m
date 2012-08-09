//
//  MembershipModel.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "MembershipModel.h"

@implementation MembershipModel

@synthesize groupId = _groupId;
@synthesize groupType = _groupType;
@synthesize permissions = _permissions;
@synthesize roleIds = _roleIds;

-(id)initWithJsonBlob:(NSDictionary*)jsonBlob
{
    self.groupId = [jsonBlob objectForKey:@"GroupId"];
    self.groupType = @"GroupType";
    self.permissions = [jsonBlob objectForKey:@"PermissionIds"];
    self.roleIds = [jsonBlob objectForKey:@"RoleIds"];

    return self;
}

@end