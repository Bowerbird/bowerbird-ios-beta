//
//  BBModelId.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 22/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBModelId.h"

@implementation BBModelId

-(id)initWithId:(NSString*)identifier {
    self = [super init];
    
    if(self) {
        _identifier = identifier;
    }
    
    return self;
}

@synthesize identifier = _identifier;

-(NSString*)identifier {
    return _identifier;
}
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"Id"]) self.identifier = value;
}

@end