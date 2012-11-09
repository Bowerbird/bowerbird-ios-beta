//
//  BBMediaDescriptionView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMediaEditView.h"


typedef void (^ActionBlock)();


@implementation BBMediaEditView {
    UIImage* mediaImage;
    NSDictionary* ccLicences;
}


@synthesize controller = _controller;
@synthesize mediaBox = _mediaBox;
@synthesize licencePicker = _licencePicker;
@synthesize captionTextField = _captionTextField;
@synthesize isPrimaryMedia = _isPrimaryMedia;


#pragma mark -
#pragma mark - Setup and Config


-(BBMediaEditView*)initWithDelegate:(id<BBMediaEditDelegateProtocol>)delegate andImage:(UIImage *)image {
    
    self = [self init];
    
    self.controller = delegate;
    mediaImage = image;
    
    return self;
}


#pragma mark -
#pragma mark - Delegate and Protocol interaction

-(NSArray*)getLicences {
    return [self.controller getLicences];
}

-(NSString*)getUserDefaultLicence {
    return [self.controller getUserDefaultLicence];
}

-(void)setAsPrimaryImage {
    [self.controller setAsPrimaryImage];
}

-(void)updateCaption:(NSString *)caption {
    [self.controller updateCaption:caption];
}

-(void)updateLicence:(NSString *)licence {
    [self.controller updateLicence:licence];
}

-(void)saveMediaEdit{
    [self.controller saveMediaEdit];
}

-(void)cancelMediaEdit {
    [self.controller cancelMediaEdit];
}


@end