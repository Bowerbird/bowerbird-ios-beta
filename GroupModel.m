//
//  Group.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize description = _description;
@synthesize groupType = _groupType;
@synthesize parentGroup = _parentGroup;
@synthesize childGroups = _childGroups;
@synthesize avatars = _avatars;

-(NSDictionary *) avatars
{
    if(! _avatars)
    {
        _avatars = [[NSDictionary alloc]init];
    }
    return _avatars;
}
-(void)setAvatars:(NSDictionary *)avatars
{
    _avatars = avatars;
}
 
-(void) addAvatar:(AvatarModel *)avatar
{
    NSMutableDictionary* projectAvatars = [NSMutableDictionary dictionaryWithDictionary:self.avatars];
    [projectAvatars setObject:avatar forKey:avatar.imageDimensionName];
    
    [self setAvatars:[NSDictionary dictionaryWithDictionary: projectAvatars]];
}

@end
