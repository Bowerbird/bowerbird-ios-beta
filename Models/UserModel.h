//
//  User.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 26/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarModel.h"
#import "AvatarImageLoadCompleteDelegate.h"
#import "RequestDataFromServer.h"
#import "BowerBirdConstants.h"



@interface UserModel : NSObject <AvatarImageLoadCompleteDelegate, RequestDataFromServer>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDictionary* avatars;
@property (nonatomic) BOOL isLoggedIn;

+(UserModel *)buildFromJson:(NSDictionary *)properties;

-(void)setAvatars:(NSDictionary *)avatars;

-(void)addAvatar:(AvatarModel *)avatar;

@end