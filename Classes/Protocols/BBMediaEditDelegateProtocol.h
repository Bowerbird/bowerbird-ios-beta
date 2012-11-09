//
//  BBMediaEditProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 24/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMediaEdit.h"

@protocol BBMediaEditDelegateProtocol <NSObject>

// only implemented in the MediaEditController
-(NSArray*)getLicences;
-(NSString*)getUserDefaultLicence;
-(void)updateLicence:(NSString*)licence;
-(void)updateCaption:(NSString*)caption;
-(void)setAsPrimaryImage;

// only implemented in the ObservationEditController
-(void)saveMediaEdit;
-(void)cancelMediaEdit;

@end