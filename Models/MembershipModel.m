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

-(id)initWithJson:(NSDictionary*)dictionary
{
    self.groupId = [dictionary objectForKey:@"GroupId"];
    self.groupType = [dictionary objectForKey:@"GroupType"];
    self.permissions = [dictionary objectForKey:@"PermissionIds"];
    self.roleIds = [dictionary objectForKey:@"RoleIds"];

    return self;
}

@end