//
//  BBMediaDescriptionView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMediaEditDelegateProtocol.h"
#import "MGBox.h"
#import "CoolMGButton.h"
#import "PhotoBox.h"

@interface BBMediaEditView : MGBox <
     UITextFieldDelegate // respond to text field interaction
    ,BBMediaEditDelegateProtocol
>

@property (nonatomic,strong) id<BBMediaEditDelegateProtocol> controller; // parent controller action access delegate
@property (nonatomic,strong) PhotoBox* mediaBox; // display the media a user has added to the observation
@property (nonatomic,strong) UIPickerView* licencePicker; // 
@property (nonatomic,strong) UITextField* captionTextField;
@property (nonatomic,strong) UISwitch* isPrimaryMedia;

-(BBMediaEditView *)initWithDelegate:(id<BBMediaEditDelegateProtocol>)delegate
                            andImage:(UIImage*)image;

-(NSArray*)getLicences;
-(NSString*)getUserDefaultLicence;
-(void)updateLicence:(NSString *)licence;
-(void)updateCaption:(NSString *)caption;

@end