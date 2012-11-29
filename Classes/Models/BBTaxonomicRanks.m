//
//  BBTaxonomicRanks.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 29/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBTaxonomicRanks.h"

@implementation BBTaxonomicRanks

@synthesize name = _name;
@synthesize type = _type;


-(NSString*)name {
    return _name;
}
-(void)setName:(NSString *)name {
    _name = name;
}


-(NSString*)type{
    return _type;
}
-(void)setType:(NSString *)type {
    _type = type;
}


@end