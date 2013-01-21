//
//  BBDisplayFullImage.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 18/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBDisplayFullImageController.h"

@interface BBDisplayFullImageController ()
@property (nonatomic,strong) BBImage* image;
@end

@implementation BBDisplayFullImageController {
    CGSize imgSize;
    PhotoBox *photoBox;
}

@synthesize image = _image;

-(id)initWithImage:(BBImage*)img {
    self = [super init];
    
    if(self) {
        _image = img;
        imgSize = CGSizeMake([_image.width floatValue], [_image.height floatValue]);
    }
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBDisplayFullImageController.loadView"];
    
    photoBox = [PhotoBox mediaFor:_image.uri size:imgSize];
    
    CoolMGButton *backBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 320, 50)
                                                            andTitle:@"Back to Sighting"
                                                           withBlock:^{
                                                               //[((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popToViewController:self.parentViewController animated:NO];
                                                               [[self navigationController] popViewControllerAnimated:NO];
                                                           }];
    
    CGRect frame = CGRectMake(0, 50, [self screenSize].width, [self screenSize].height- 50);
    
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    scrollView.contentSize = imgSize;
    scrollView.frame = frame;
    
    [SVProgressHUD showWithStatus:@"Loading full size Image"];
    
    CGPoint center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    [scrollView setCenter:center];
    [scrollView addSubview:photoBox];
    scrollView.backgroundColor = [self backgroundColor];
    
    self.view = scrollView;
    [self.view addSubview:backBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidUnload {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end