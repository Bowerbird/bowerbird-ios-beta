/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "UserModel.h"


@interface UserModel()

@property (nonatomic, weak) id<UserLoaded> userLoaded;

@end


@implementation UserModel

@synthesize identifier = _identifier;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize avatar = _avatar;


#pragma mark - Class methods for iterating JSON blobs.

-(id)initWithJson:(NSDictionary*)dictionary
{
    self.identifier = [dictionary objectForKey:@"Id"];
    self.firstName = @"FirstName";
    self.lastName = [dictionary objectForKey:@"LastName"];
    self.email = [dictionary objectForKey:@"Email"];

    NSDictionary* avatarJson = [[[dictionary objectForKey:@"Avatar"] objectForKey:@"Image"] objectForKey:([BowerBirdConstants NameOfAvatarImageThatGetsDisplayed])];
    self.avatar = [[AvatarModel alloc]initWithJson:avatarJson andNotifyImageDownloadComplete:self];
    
    return self;
}


#pragma mark - Callback methods to this and methods setting this as delegate

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
// If this image is of the projectDisplayImage type, the project is ready to display
-(void)ImageFinishedLoading:(AvatarModel*)forAvatar;
{
    if([self.userLoaded respondsToSelector:@selector(UserLoaded:)])
    {
        [self.userLoaded UserLoaded:(self)];
    }
}

@end