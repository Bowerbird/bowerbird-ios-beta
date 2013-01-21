//
//  BBIdentifySightingEdit.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBIdentifySightingEdit : NSObject

-(BBIdentifySightingEdit*)initWithSightingId:(NSString*)sightingId;
-(void)setCustomIdentification:(NSDictionary*)customId;

@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSString *taxonomy;
@property BOOL isCustomIdentification;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *kingdom;
@property (nonatomic,strong) NSString *phylum;
@property (nonatomic,strong) NSString *klass;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *family;
@property (nonatomic,strong) NSString *genus;
@property (nonatomic,strong) NSString *species;
@property (nonatomic,strong) NSString *subSpecies;
@property (nonatomic,strong) NSMutableArray *commonGroupNames;
@property (nonatomic,strong) NSMutableArray *commonNames;

@end