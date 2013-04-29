//
//  BBValidationError.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 29/04/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBValidationError.h"

@implementation BBValidationError


#pragma mark -
#pragma mark - Synthesizers


@synthesize field = _field;
@synthesize messages = _messages;


#pragma mark -
#pragma mark - Member Accessors


-(NSString*)field { return _field; }
-(void)setField:(NSString *)field { _field = field; }

-(void)setMessages:(NSArray *)messages { _messages = messages; }
-(NSArray*)permissions {
    if(!_messages)_messages = [[NSArray alloc]init];
    return _messages;
}
-(NSUInteger)countOfMessages { return [self.messages count]; }
-(id)objectInMessagesAtIndex:(NSUInteger)index { return [self.messages objectAtIndex:index]; }


@end