//
//  BBSightingNoteEditDelegateProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSightingNoteDescription;

@protocol BBSightingNoteEditDelegateProtocol <NSObject>

@required

// start selecting description to add, finish selecting description to add, add description, remove description
-(void)startAddDescription;
-(void)endAddDescription;
-(void)addDescription:(BBSightingNoteDescription *)description;
-(void)removeDescription:(BBSightingNoteDescription *)description;
-(NSArray*)getDescriptions;

// add a tag, remove a tag
-(void)startAddTag;
-(void)endAddTag;
-(void)addTag:(NSString*)tag;
-(void)removeTag:(NSString*)tag;
-(NSArray*)getTags;

// save, cancel
-(void)save;
-(void)cancel;

@end