//
//  Register.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

/*
 http://stackoverflow.com/questions/11264163/how-to-implement-user-registration-authentication-in-ios
 I would not pass the user login and password every time. Have the user login initially and then create an authentication token, store it on your server, and pass it back to the client and store it in the keychain. Then, you can just pass in the token each time.
 */


// This class will make a network API call to register a new user
// and pass back the authenticated token
#import "RegisterModel.h"

@implementation RegisterModel

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize password = _password;

-(UserModel *)registerUser: (RegisterModel *)registration
{
    return [[UserModel alloc]init];
}

@end