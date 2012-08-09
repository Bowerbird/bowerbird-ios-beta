//
//  User.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 26/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "UserModel.h"

@interface UserModel()
-(void)loadAvatarImages;
@property (nonatomic, weak) id<UserLoadCompleteDelegate> userLoadCompleteDelegate;
@end

@implementation UserModel

@synthesize identifier = _identifier;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize avatars = _avatars;
@synthesize isLoggedIn = _isLoggedIn;

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


#pragma mark - Object initializers

- (id)initWithCallbackDelegate:(id)delegate
{
    self.userLoadCompleteDelegate = delegate;
    
    return self;
}


#pragma mark - Class methods for iterating JSON blobs.

+(UserModel *)loadUserFromResponseString:(NSString *)responseString
{
    SBJSON *parser = [[SBJSON alloc] init];
    UserModel *user = [[UserModel alloc]init];
    
    id jsonObject = [parser objectWithString:responseString error:nil];
    
    if([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* model = [jsonObject objectForKey:@"Model.User"];
        user = [self buildFromJson:model];
    }
    
    return user;
}

+(UserModel *)buildFromJson:(NSDictionary *)properties;
{
    UserModel* model = [[UserModel alloc]init];
    
    model.identifier = [properties objectForKey:@"Id"];
    model.firstName = @"project";
    model.lastName = [properties objectForKey:@"Name"];
    model.email = [properties objectForKey:@"Description"];
    
    NSDictionary* avatarJson = [properties objectForKey:@"Avatar"];
    NSDictionary* imageJson = [avatarJson objectForKey:@"Image"];
    model.avatars = [AvatarModel buildManyFromJson:imageJson];
    
    return model;
}


#pragma mark - Callback methods to this and methods setting this as delegate

// loads the suer images from Avatar, and sets this class as callback for
// the 'job done' message. delegates to ImageFinishedLoading below..
-(void)loadAvatarImages
{
    for(id avatar in self.avatars)
    {
        AvatarModel* avatarModel = [self.avatars objectForKey:avatar];
        if([avatarModel isKindOfClass:[AvatarModel class]]
           && avatarModel.imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
        {
            // we are passing this object as a callback delegate
            // so we are notified when the avatar image has loaded for the project
            [avatarModel loadImage:(self) forAvatarOwner:(self)];
        }
    }}

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
// If this image is of the projectDisplayImage type, the project is ready to display
-(void)ImageFinishedLoading:(NSString *)imageDimensionName
             forAvatarOwner:(id)avatarOwner
{
    if(imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
    {
        if([self.userLoadCompleteDelegate respondsToSelector:@selector(userLoadCompleteDelegate)])
        {
            [self.userLoadCompleteDelegate UserLoaded:(self)];
        }
    }
}

@end