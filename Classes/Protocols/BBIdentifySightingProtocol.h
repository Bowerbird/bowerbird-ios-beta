//
//  BBIdentifySightingProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBIdentifySightingProtocol <NSObject>

@required

-(void)searchClassifications;
-(void)browseClassifications;
-(void)createClassification;
-(void)removeClassification;
-(void)save;
-(void)cancel;

@end
