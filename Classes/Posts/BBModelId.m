//
//  BBModelId.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 22/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBModelId.h"

@implementation BBModelId

@synthesize identifier = _identifier;

-(NSString*)identifier {
    return _identifier;
}
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}

@end