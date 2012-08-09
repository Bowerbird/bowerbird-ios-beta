//
//  Home.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 26/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "HomeModel.h"
#import "UserModel.h"
#import "RegisterModel.h"

@implementation HomeModel

@synthesize currentUser = _currentUser;
@synthesize userIsLoggedIn = _userIsLoggedIn;

-(UserModel *)registerUser: (RegisterModel *)registration
{
    return [[UserModel alloc]init];
}

@end

