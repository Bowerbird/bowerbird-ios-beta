//
//  BBCategory.m
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBCategory.h"

@implementation BBCategory

@synthesize identifier = _identifier,
                  name = _name,
              taxonomy = _taxonomy;


-(NSString*)identifier {
    return _identifier;
}

-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}


-(NSString*)name {
    return _name;
}

-(void)setName:(NSString *)name {
    _name = name;
}


-(NSString*)taxonomy {
    return _taxonomy;
}

-(void)setTaxonomy:(NSString *)taxonomy {
    _taxonomy = taxonomy;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Id is the serverside representation of identifier.. had to change because of keyword id.
    if([key isEqualToString:@"Id"]) self.identifier = value;
}


@end