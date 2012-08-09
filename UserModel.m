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


#pragma mark - Class methods for iterating JSON blobs.

+(UserModel *)buildFromJson:(NSDictionary *)properties;
{
    UserModel* loggedInUser = [[UserModel alloc]init];
    
    // parse user properties out of response string dictionary structure - see commented out below.
    
    return loggedInUser;
}


#pragma mark - Callback methods to this and methods setting this as delegate

// loads the suer images from Avatar, and sets this class as callback for
// the 'job done' message. delegates to ImageFinishedLoading below..
-(void)loadAvatarImages
{
    
    //    for (ProjectModel *project in self.projects) {
    //        for(id avatar in project.avatars)
    //        {
    //            // not sure why, but id avatar in the for loop above points to the dictionary item
    //            AvatarModel* avatarModel = [project.avatars objectForKey:avatar];
    //            if([avatarModel isKindOfClass:[AvatarModel class]]
    //               && avatarModel.imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
    //            {
    //                // we are passing this object as a callback delegate
    //                // so we are notified when image has loaded
    //                [avatarModel loadImage:(self) forProject:(project)];
    //            }
    //        }
    //    }
}

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
// If this image is of the projectDisplayImage type, the project is ready to display
-(void)ImageFinishedLoading:(NSString *)imageDimensionName
             forAvatarOwner:(id)avatarOwner
{
    if(imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
    {
        //ProjectModel* projectModel = [self.projects objectAtIndex:[self.projects indexOfObject:(project)]];
        
        // notify this object's delegate that project is successfully loaded
        //[self.projectLoadCompleteDelegate ProjectLoaded:projectModel];
    }
}

@end

/*
 {
     "Model": 
        {
         "User": 
            {
             "Id": "users/2",
             "Avatar": {
                 "Id": "mediaresources/",
                 "MediaType": "image",
                 "UploadedOn": "2012-08-02T05:32:39Z",
                 "Metadata": {},
                 "Image": {
                 "Square42": {
                 "FileName": "default-user-avatar.jpg",
                 "RelativeUri": "/img/default-user-avatar.jpg",
                 "Format": "jpeg",
                 "Width": 42,
                 "Height": 42,
                 "Extension": "jpg"
             },
             "Square100": {
                 "FileName": "default-user-avatar.jpg",
                 "RelativeUri": "/img/default-user-avatar.jpg",
                 "Format": "jpeg",
                 "Width": 100,
                 "Height": 100,
                 "Extension": "jpg"
             },
             "Square200": {
                 "FileName": "default-user-avatar.jpg",
                 "RelativeUri": "/img/default-user-avatar.jpg",
                 "Format": "jpeg",
                 "Width": 200,
                 "Height": 200,
                 "Extension": "jpg"
                 }
             },
                "Key": "dbc87770-8f71-4be2-bfa6-571dd1b3af25"
             },
             "FirstName": "Hamish",
             "LastName": "Crittenden",
             "Name": "Hamish Crittenden"
         }
     }
 }
 
 */