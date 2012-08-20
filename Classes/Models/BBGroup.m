/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBGroup

@synthesize     identifier = _identifier,
                      name = _name,
               description = _description,
                 groupType = _groupType,
               memberCount = _memberCount,
                 postCount = _postCount,
                    avatar = _avatar;


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}
-(NSString*)identifier
{
    return _identifier;
}


-(void)setName:(NSString *)name
{
    _name = name;
}
-(NSString*)name
{
    return _name;
}


-(void)setDescription:(NSString *)description
{
    _description = description;
}
-(NSString*)description
{
    return _description;
}


-(void)setGroupType:(NSString *)groupType
{
    _groupType = groupType;
}
-(NSString*)groupType
{
    return _groupType;
}


-(void)setMemberCount:(NSNumber *)memberCount
{
    _memberCount = memberCount;
}
-(NSNumber*)memberCount
{
    return _memberCount;
}


-(void)setPostCount:(NSNumber *)postCount
{
    _postCount = postCount;
}
-(NSNumber*)postCount
{
    return _postCount;
}


-(void)setAvatar:(BBMediaResource *)avatar
{
    _avatar = avatar;
}
-(BBMediaResource*)avatar
{
    return _avatar;
}

- (void)setNilValueForKey:(NSString *)theKey
{
    //    if ([theKey isEqualToString:@"hidden"]) {
    //        [self setValue:@YES forKey:@"hidden"];
    //    }
    //    else {
    //        [super setNilValueForKey:theKey];
    //    }
}


@end
