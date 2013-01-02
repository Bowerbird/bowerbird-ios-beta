//
//  BBStreamView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "MGScrollView.h"
#import "BBStreamProtocol.h"
#import "MGHelpers.h"

@interface BBStreamView : MGScrollView

-(BBStreamView*)initWithDelegate:(id<BBStreamProtocol>)delegate andSize:(CGSize)size;

-(BOOL)renderStreamItem:(MGBox*)boxItem
              forItemId:(NSString*)itemId;

-(BOOL)renderStreamItem:(MGBox*)boxItem
            inDirection:(BOOL)scrollingDownward
              forItemId:(NSString*)itemId;

-(NSString*)itemAtStreamBottom;

-(NSString*)itemAtStreamTop;

@end