//
//  BBStreamProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 10/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBStreamView;

/* Used for a Stream controller to talk to it's container view */
@protocol BBStreamProtocol <NSObject>

@required
-(void)displayStreamView:(UIView*)streamView;

@end