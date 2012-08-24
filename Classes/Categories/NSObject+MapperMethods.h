//
//  BBNSObject+MapperMethods.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MapperMethods)

/**
 * Decodes the receiver's JSON text
 *
 */
- (id)BBObject;

@end
