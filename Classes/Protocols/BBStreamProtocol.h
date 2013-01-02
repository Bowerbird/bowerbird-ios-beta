//
//  BBStreamProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 10/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBStreamView;

@protocol BBStreamProtocol <NSObject>

@required
-(void)displayStreamView:(BBStreamView*)streamView;

@optional
-(NSSet*)getStreamItems;

@end