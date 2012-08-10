//
//  MembershipModel.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "CollectionHelper.h"

@interface MembershipModel : NSObject

@property (nonatomic, strong) NSString* groupId;
@property (nonatomic, strong) NSString* groupType;
@property (nonatomic, strong) NSArray* permissions;
@property (nonatomic, strong) NSArray* roleIds;

-(id)initWithJson:(NSDictionary*)dictionary;

@end
