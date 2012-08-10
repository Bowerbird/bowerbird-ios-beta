//
//  Group.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarModel.h"

@interface GroupModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *groupType;
@property (nonatomic, strong) GroupModel *parentGroup;
@property (nonatomic, strong) NSArray *childGroups;
@property (nonatomic, strong) AvatarModel* avatar;

@end
