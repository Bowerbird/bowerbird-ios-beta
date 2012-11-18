//
//  BBCategoryPickerController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBCategoryPickerController.h"

@implementation BBCategoryPickerController

@synthesize delegate = _delegate;
@synthesize categoryPickerView = _categoryPickerView;

-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBCategoryPickerController.initWithDelegate"];
    
    self = [super init];
    _delegate = delegate;
    _categoryPickerView = [[BBCategoryPickerView alloc]initWithDelegate:self];
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBCategoryPickerController.loadView"];
    
    self.view = _categoryPickerView;
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBCategoryPickerController.viewWillAppear"];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBCategoryPickerController.viewDidLoad"];
    
    [super viewDidLoad];
}

-(NSArray*)getCategories {
    [BBLog Log:@"BBCategoryPickerController.getCategories"];
    
    BBApplication* application = [BBApplication sharedInstance];
    NSArray *categories = application.authenticatedUser.categories;
    
    return categories;
}

-(void)updateCategory:(BBCategory*)category {
    [BBLog Log:@"BBCategoryPickerController.updateCategory:"];
    
    [self.delegate updateCategory:category];
}

-(void)categoryStopEdit {
    [BBLog Log:@"BBCategoryPickerController.categoryStopEdit"];
    
    [_delegate categoryStopEdit];
    //[self.app.navController popViewControllerAnimated:YES];
}

@end