/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


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
        NSDictionary* userJson = [jsonObject objectForKey:@"Model.User"];
        user = [[UserModel alloc]initWithJsonBlob:userJson];
    }
    
    return user;
}

-(id)initWithJsonBlob:(NSDictionary*)jsonBlob
{
    UserModel* model = [[UserModel alloc]init];
    
    model.identifier = [jsonBlob objectForKey:@"Id"];
    model.firstName = @"FirstName";
    model.lastName = [jsonBlob objectForKey:@"LastName"];
    model.email = [jsonBlob objectForKey:@"Email"];
    
    NSDictionary* avatarJson = [jsonBlob objectForKey:@"Avatar"];
    NSDictionary* imageJson = [avatarJson objectForKey:@"Image"];
    model.avatars = [AvatarModel buildManyFromJson:imageJson];
    
    return self;
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
    }
}

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