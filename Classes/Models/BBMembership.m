/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMembership.h"

@implementation BBMembership

@synthesize     groupId = _groupId,
              groupType = _groupType,
            permissions = _permissions,
                roleIds = _roleIds;


-(void)setGroupId:(NSString *)groupId
{
    _groupId = groupId;
}
-(NSString*)groupId
{
    return _groupId;
}


-(void)setGroupType:(NSString *)groupType
{
    _groupType = groupType;
}
-(NSString*)groupType
{
    return _groupType;
}


-(void)setPermissions:(NSArray *)permissions
{
    _permissions = permissions;
}
-(NSArray*)permissions
{
    if(!_permissions)_permissions = [[NSArray alloc]init];
    return _permissions;
}
-(NSUInteger)countOfPermissions
{
    return [self.permissions count];
}
-(id)objectInPermissionsAtIndex:(NSUInteger)index
{
    return [self.permissions objectAtIndex:index];
}


-(void)setRoleIds:(NSArray *)roleIds
{
    _roleIds = roleIds;
}
-(NSArray*)roleIds
{
    if(!_roleIds)_roleIds = [[NSArray alloc]init];
    return _roleIds;
}
-(NSUInteger)countOfRoleIds
{
    return [self.roleIds count];
}
-(id)objectInRoleIdsAtIndex:(NSUInteger)index
{
    return [self.roleIds objectAtIndex:index];
}


@end