/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Used to display static content for Privacy Policy, Terms and Conditions, Resources etc
 
 -----------------------------------------------------------------------------------------------*/


#import "BBAboutController.h"
#import "BBHelpers.h"
#import "BBUIControlHelper.h"
#import "MGHelpers.h"


@interface BBAboutController ()

@end


@implementation BBAboutController


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBAboutController.loadView:"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
    
    // display buttons which link off to the various static components.
    view.backgroundColor = [self backgroundColor];
    
    CoolMGButton *privacy = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 40, 300, 60) andTitle:@"Privacy Policy" withBlock:^{
        UIViewController *privacyViewController = [[UIViewController alloc]init];
        privacyViewController.view = [self getPrivacyTextView];
        privacyViewController.title = @"Privacy Policy";
        privacyViewController.navigationController.navigationBarHidden = NO;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Back"
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        [privacyViewController.navigationItem setBackBarButtonItem: backButton];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:privacyViewController animated:YES];
    }];
    //privacy.margin = UIEdgeInsetsMake(40, 10, 40, 10);
    
    CoolMGButton *terms = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 140, 300, 60) andTitle:@"Terms & Conditions" withBlock:^{
        UIViewController *termsViewController = [[UIViewController alloc]init];
        termsViewController.view = [self getTermsTextView];
        termsViewController.title = @"Terms & Conditions";
        termsViewController.navigationController.navigationBarHidden = NO;
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:termsViewController animated:YES];
    }];
    //terms.margin = UIEdgeInsetsMake(40, 10, 40, 10);
    
    CoolMGButton *resources = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 240, 300, 60) andTitle:@"Resources" withBlock:^{
        UIViewController *resourcesViewController = [[UIViewController alloc]init];
        resourcesViewController.view = [self getResourcesTextView];
        resourcesViewController.title = @"Resources";
        resourcesViewController.navigationController.navigationBarHidden = NO;
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:resourcesViewController animated:YES];
    }];
    //resources.margin = UIEdgeInsetsMake(40, 10, 40, 10);
    
    [view addSubview:privacy];
    [view addSubview:terms];
    [view addSubview:resources];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBAboutController.viewWillAppear"];
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    self.title = @"BowerBird";
}


#pragma mark -
#pragma mark - Helpers and Utilities


-(UIWebView*)getPrivacyTextView {
    [BBLog Log:@"BBAboutController.getPrivacyTextView:"];

    NSString *localFilePath = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy" ofType:@"html"] ;
    NSURLRequest *localRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localFilePath]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
    
    [webView loadRequest:localRequest];
    
    return webView;
}

-(UIWebView*)getTermsTextView {
    [BBLog Log:@"BBAboutController.getTermsText:"];
    
    NSString *localFilePath = [[NSBundle mainBundle] pathForResource:@"TermsAndConditions" ofType:@"html"] ;
    NSURLRequest *localRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localFilePath]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
    
    [webView loadRequest:localRequest];
    
    return webView;
}

-(UIWebView*)getResourcesTextView {
    [BBLog Log:@"BBAboutController.getResourcesText:"];

    NSString *localFilePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"html"] ;
    NSURLRequest *localRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localFilePath]];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
    
    [webView loadRequest:localRequest];
    
    return webView;
}


@end