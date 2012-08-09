/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "LoadingViewController.h"
#import <UIKit/UIKit.h>

#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI) // Our conversion definition
#define BOWERBIRD_PREFS "BowerBird.Cookie.Prefs"

@interface LoadingViewController ()
-(BOOL)applicationRequiresLoginOrRegistration;
- (void)segueToLogin;
- (void)segueToHome;
- (void)startRotation;
- (void)rotateImage:(UIImageView *)image
           duration:(NSTimeInterval)duration
              curve:(int)curve
            degrees:(CGFloat)degrees;
@property (nonatomic, strong) UIImageView *imageToMove;
@property (nonatomic, strong) NSFileManager *filemgr;
@end

@implementation LoadingViewController

@synthesize imageToMove = _imageToMove;
@synthesize filemgr = _filemgr;


#pragma mark - Initialize the Application and Segue

-(BOOL)applicationRequiresLoginOrRegistration
{
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    self.filemgr = [NSFileManager defaultManager];
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file - this will be replaced with a query for the NSData database file
    dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    return YES;
}

-(void)segueToLogin
{
    [self performSegueWithIdentifier:@"Login" sender:nil];
}

-(void)segueToHome
{
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Login"])
    {
        //[segue.destinationViewController]
        //RegisterOrLoginViewController *registerOrLoginViewController = segue.destinationViewController;
        // we can now pass to a delegate within the view controller, some data..
    }
    else if([segue.identifier isEqualToString:@"Home"])
    {
        
    }
}


#pragma mark - View Display logic


- (void) viewDidAppear:(BOOL) animated
{
    [self startRotation];
    
    if([self applicationRequiresLoginOrRegistration])
    {
        [self performSelector:@selector(segueToLogin)withObject:self afterDelay:1];
    }
    else
    {
        [self performSelector:@selector(segueToHome)withObject:self afterDelay:1];
    }
    
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Loading screen animation

- (void)rotateImage:(UIImageView *)image
           duration:(NSTimeInterval)duration
              curve:(int)curve
            degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}


- (void)startRotation
{
    if(!self.imageToMove)
    {
        self.imageToMove =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loader.png"]];
        self.imageToMove.frame = CGRectMake(100, 100, 100, 100);
        [self.view addSubview:self.imageToMove];
        
    }
    
    [self rotateImage:self.imageToMove duration:1.0
                curve:UIViewAnimationCurveLinear
              degrees:180];
}


@end
