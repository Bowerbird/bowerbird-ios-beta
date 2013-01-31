/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBHeaderController.h"
#import "BBUserHeadingView.h"


@implementation BBHeaderController


#pragma mark -
#pragma mark - Renderers


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BBLog Log:@"BBHeaderController.viewDidLoad"];
}


-(void)loadView {
    [BBLog Log:@"BBHeaderController.loadView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setHeadingWithTitle:)
                                                 name:@"updateHeadingTitle"
                                               object:nil];
    
    self.view = [[BBUserHeadingView alloc] initWithSize:IPHONE_HEADER_PORTRAIT andTitle:@"BowerBird"];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)setHeadingWithTitle:(NSNotification *) notification
{
    NSDictionary* userInfo = [notification userInfo];
    self.view = [[BBUserHeadingView alloc] initWithSize:IPHONE_HEADER_PORTRAIT andTitle:[userInfo objectForKey:@"name"]];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBHeaderController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end