//
//  Home.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 26/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterModel.h"
#import "UserModel.h"
#import "SBJSON.h"

@interface HomeModel : NSObject

@property (nonatomic, strong) UserModel *currentUser;
@property (nonatomic) BOOL userIsLoggedIn;

-(UserModel *)registerUser: (RegisterModel *)registration;

@end
