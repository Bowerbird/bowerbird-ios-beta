//
//  ProjectsViewController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 14/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "ProjectsViewController.h"

@implementation ProjectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BowerBirdConstants Trace]) NSLog(@"ProjectsViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Projects";
        self.title = @"Projects";
    }
    return self;
}

#pragma mark - Authentication methods and Segues

-(void)segueToBrowseProjects
{
    if([BowerBirdConstants Trace]) NSLog(@"ProjectsViewController.segueToBrowse");
    
    [self performSegueWithIdentifier:@"BrowseProjects" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"ProjectsViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"BrowseProjects"])
    {
        // set up data if req'd
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *browseProjectsButton = [[UIBarButtonItem alloc] initWithTitle:@"Browse"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:@selector(segueToBrowseProjects:)];
    
    self.navigationItem.rightBarButtonItem = browseProjectsButton;
}

@end
