/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "Membership.h"

@implementation Membership

@synthesize groupId = _groupId;
@synthesize groupType = _groupType;
@synthesize permissions = _permissions;
@synthesize roleIds = _roleIds;

-(id)initWithJson:(NSDictionary*)dictionary
{
    if([BowerBirdConstants Trace]) NSLog(@"Membership.initWithJson:");
    
    self.groupId = [dictionary objectForKey:@"GroupId"];
    self.groupType = [dictionary objectForKey:@"GroupType"];
    self.permissions = [dictionary objectForKey:@"PermissionIds"];
    self.roleIds = [dictionary objectForKey:@"RoleIds"];

    return self;
}

+(NSArray*)loadTheseMembershipsFromJson:(NSArray*)array
{
    if([BowerBirdConstants Trace]) NSLog(@"Membership.loadTheseMembershipsFromJson:");
    
    NSMutableArray* membershipModels = [[NSMutableArray alloc]init];
    for(id memberDictionary in array)
    {
        Membership* membership = [[Membership alloc]initWithJson:memberDictionary];
        if(membership){
            [membershipModels addObject:(membership)];
        }
    }
    
    return [[NSArray alloc]initWithArray:membershipModels];
}

@end