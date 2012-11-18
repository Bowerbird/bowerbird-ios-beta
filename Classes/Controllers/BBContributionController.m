//
//  BBObservationController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBContributionController.h"

@implementation BBContributionController

@synthesize contributionType = _contributionType;

#pragma mark -
#pragma mark - Setup and Render

-(BBContributionController*)initWithCamera {
    [BBLog Log:@"BBContributionController.initWithCamera:"];
    
    self = [super init];
    self.contributionType = BBContributionCamera;
    
    return self;
}

-(BBContributionController*)initWithLibrary {
    [BBLog Log:@"BBContributionController.initWithLibrary:"];
    
    self = [super init];
    self.contributionType = BBContributionLibrary;
    
    return self;
}

-(BBContributionController*)initWithRecord {
    [BBLog Log:@"BBContributionController.initWithRecord:"];
    
    self = [super init];
    self.contributionType = BBContributionRecord;
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBContributionController.loadView"];
    
    BBContainerView *container = [[BBContainerView alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelCreateSighting)
                                                 name:@"createSightingCancel"
                                               object:nil];
    
    self.view = container;
}

-(void)viewDidLoad {
    [BBLog Log:@"BBContributionController.viewDidLoad"];
    
    [super viewDidLoad];
    
    switch (self.contributionType) {
        case BBContributionCamera:
            [self showCamera];
            break;
        case BBContributionLibrary:
            [self showLibrary];
            break;
        case BBContributionRecord:
            [self showCreateRecord];
            break;
        case BBContributionNone:
        default:
            
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [BBLog Log:@"BBContributionController.viewDidAppear"];
}

#pragma mark -
#pragma mark - Utilities and Helpers



#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)showCamera {
    [BBLog Log:@"BBContributionController.showCamera"];
    
    self.contributionType = BBContributionNone;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing the Camera"
                                                        message:@"The device doesn't support a Camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    }
}

-(void)showLibrary {
    [BBLog Log:@"BBContributionController.showLibrary"];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing the photo library"
                                                        message:@"The device doesn't support the photo library"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    }
}

-(void)showCreateRecord {
    [BBLog Log:@"BBContributionController.showCreateRecord"];
    
    BBSightingEditController *observationController = [[BBSightingEditController alloc]initAsRecord];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:observationController animated:NO];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [BBLog Log:@"BBContributionController.imagePickerController:"];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* image;
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        [BBLog Log:@"BBContributionController: source is library"];
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else
    {
        [BBLog Log:@"BBContributionController: source is edited image"];
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    BBMediaEdit *mediaEdit = [[BBMediaEdit alloc]init];
    mediaEdit.image = image;
    
    BBSightingEditController *observationController = [[BBSightingEditController alloc]initWithMedia:mediaEdit];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:observationController animated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [BBLog Log:@"BBContributionController.imagePickerControllerDidCancel"];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)cancelCreateSighting {
    [BBLog Log:@"BBContributionController.cancelCreateSighting"];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContributionController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end