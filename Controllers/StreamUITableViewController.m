//
//  StreamViewController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 1/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "StreamUITableViewController.h"


// is a tableview controller extension
@interface StreamUITableViewController ()

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section;

// protocol methods
@property NSString* responseString;
@property NSData* responseData;
@property NSError *error;

@end

@implementation StreamUITableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// show paged list of objects for stream.

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // return [self.dataSource count];
    return 1;
}

@end
