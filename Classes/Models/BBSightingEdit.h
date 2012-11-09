//
//  BBSightingCreate.h
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMediaEdit.h"
#import "BBProject.h"

@interface BBSightingEdit : NSObject

@property (nonatomic,strong) NSString* category;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) NSMutableArray *media;
@property CGPoint location;
@property (nonatomic,strong) NSString* address;
@property BOOL isHidden;
@property (nonatomic,strong) NSArray* projects;
@property (nonatomic,strong) NSMutableSet *projectsObservationIsIn, *projectsObservationIsNotIn;

@end