//
//  BBMediaDescriptionController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBHelpers.h"
#import "BBMediaEdit.h"
#import "BBMediaEditView.h"
#import "BBMediaEditDelegateProtocol.h"

@interface BBMediaEditController : BBControllerBase <BBMediaEditDelegateProtocol>

@property (nonatomic,retain) id controller; // parent controller
@property (nonatomic,strong) BBMediaEdit* media;
@property (nonatomic,retain) BBMediaEditView *mediaEditView;

-(id)initWithDelegate:(id<BBMediaEditDelegateProtocol>)delegate andMedia:(BBMediaEdit*)media;

-(NSArray*)getLicences;
-(NSString*)getUserDefaultLicence;
-(void)updateLicence:(NSString*)licence;
-(void)updateCaption:(NSString*)caption;
-(void)setAsPrimaryImage;
-(void)saveMediaEdit:(BBMediaEdit *)media:(BBMediaEdit*)media;
-(void)cancelMediaEdit;

@end