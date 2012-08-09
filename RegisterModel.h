//
//  Register.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"

@interface RegisterModel : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

-(UserModel *)registerUser: (RegisterModel *)registration;

//- (void)loadProjects:(id)withDelegate;

@end