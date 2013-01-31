//
//  BBPostActivityController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 30/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBPostActivityController.h"

@interface BBPostActivityController ()

@property (nonatomic,strong) BBActivity* activity;

@end

@implementation BBPostActivityController

@synthesize activity = _activity;

- (id)initWithPostActivity:(BBActivity*)activity
{
    self = [super init];
    if (self) {

        self.activity = activity;
        
    }
    return self;
}

-(void)loadView {
    self.view = [self render];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MGBox*)render {
    [BBLog Log:@"BBStreamController.renderPost"];
    
    BBActivity *activity = self.activity;
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                          right:nil
                                                          width:240
                                                      minHeight:50];
    activityDescription.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    activityDescription.padding = UIEdgeInsetsZero;
    activityDescription.underlineType = MGUnderlineNone;
    
    MGBox *detailArrow = [self getForwardArrow];
    detailArrow.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    
    MGBox *userProfileWithArrow = [MGBox boxWithSize:CGSizeMake(310, 50)];
    userProfileWithArrow.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    userProfileWithArrow.contentLayoutMode = MGLayoutGridStyle;
    
    [userProfileWithArrow.boxes addObject:avatar];
    [userProfileWithArrow.boxes addObject:activityDescription];
    [info.topLines addObject:userProfileWithArrow];
    
    MGLine *subjectLine = [MGLine multilineWithText:activity.post.subject
                                               font:HEADER_FONT
                                              width:300
                                            padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    MGLine *messageLine = [MGLine multilineWithText:activity.post.message
                                               font:DESCRIPTOR_FONT
                                              width:300
                                            padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [info.middleLines addObject:subjectLine];
    [info.middleLines addObject:messageLine];
    
    return info;
}

@end