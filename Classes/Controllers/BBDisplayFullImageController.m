/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 View a full screen, full size image of the sighting's original photo
 
 -----------------------------------------------------------------------------------------------*/


#import "BBDisplayFullImageController.h"
#import "BBUIControlHelper.h"
#import "BBImage.h"


@interface BBDisplayFullImageController ()

@property (nonatomic,strong) BBImage* image;

@end


@implementation BBDisplayFullImageController {
    CGSize imgSize;
    PhotoBox *photoBox;
    UIImageView *imageView;
    UIScrollView *uiScrollView;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize image = _image;


#pragma mark -
#pragma mark - Constructors


-(id)initWithImage:(BBImage*)img {
    self = [super init];
    
    if(self) {
        _image = img;
        imgSize = CGSizeMake([_image.width floatValue], [_image.height floatValue]);
    }
    
    return self;
}


#pragma mark -
#pragma mark - Rendering


-(void)loadView {
    [BBLog Log:@"BBDisplayFullImageController.loadView"];
    
    [SVProgressHUD showWithStatus:@"Loading full size Image"];
    
    CoolMGButton *backBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 320, 50)
                                                            andTitle:@"Back to Sighting"
                                                           withBlock:^{
                                                               [[self navigationController] popViewControllerAnimated:NO];
                                                           }];
    
    
    self.view = [[UIView alloc]init];//]WithFrame:CGRectMake(0, 50, [self screenSize].width, [self screenSize].height - 50)];
    
    [self.view addSubview:backBtn];
    
    [self loadPhotoFromLocation:_image.uri];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBDisplayFullImageController.viewDidLoad"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // add a loading spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin;
    spinner.color = UIColor.lightGrayColor;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    CGRect frame = CGRectMake(0, 50, [self screenSize].width, [self screenSize].height- 50);
    
    uiScrollView = [[UIScrollView alloc]init];
    uiScrollView.contentSize = imgSize;
    
    uiScrollView.frame = frame;
    uiScrollView.delegate = self;
    uiScrollView.minimumZoomScale=1/[self calculateZoomScale];
    uiScrollView.maximumZoomScale=1.0;
    uiScrollView.zoomScale = 1/[self calculateZoomScale];
    
    [uiScrollView addSubview:spinner];
    
    [self.view addSubview:uiScrollView];
    
    [BBLog Log:[NSString stringWithFormat:@"ScrollView Frame x:%f y:%f w:%f h:%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height]];
}

-(void)viewDidUnload {
    [SVProgressHUD dismiss];
}


#pragma mark -
#pragma mark - Utilities and Helpers


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContainerController"];
    
    [super didReceiveMemoryWarning];
}

-(void)loadPhotoFromLocation:(NSString*)location {
    [BBLog Log:@"BBDisplayFullImageController.loadPhotoFromLocation"];
    
    id fullPath = [NSString stringWithFormat:@"%@%@", [BBConstants RootUriString], location];
    NSURL *url = [NSURL URLWithString:fullPath];
    
    //UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImageWithURL:url placeholderImage:nil];
  
    
    // do UI stuff back in UI land
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // ditch the spinner
        UIActivityIndicatorView *spinner = uiScrollView.subviews.lastObject;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        
        // failed to get the photo?
        //if (!imageView) {
        //    self.alpha = 0.3;
        //    return;
        //}
        
        // got the photo, so lets show it
        //UIImage *image = [UIImage imageWithData:data];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [uiScrollView addSubview:imageView];
        imageView.size = imgSize;
        imageView.alpha = 0;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // fade the image in
        [UIView animateWithDuration:0.2 animations:^{
            imageView.alpha = 1;
        }];
    });
    
    /*
    // TODO: INTEGRATE SOME OUT OF PROC LOADING HERE...
    
    // fetch the remote photo
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    CGRect frame = CGRectMake(0, 0, [self screenSize].width, [self screenSize].height); //uiScrollView.frame;
        
    CGPoint center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    
    imageView.frame = frame;
    [BBLog Log:[NSString stringWithFormat:@"ImageView Frame x:%f y:%f w:%f h:%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height]];
    
    [uiScrollView setCenter:center];
    
    [uiScrollView setNeedsDisplay];
    uiScrollView.backgroundColor = [self backgroundColor];
    
    [self.view addSubview:uiScrollView];
    
    // do UI stuff back in UI land
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // ditch the spinner
        UIActivityIndicatorView *spinner = self.view.subviews.lastObject;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        
        [SVProgressHUD dismiss];
        
        // failed to get the photo?
        if (!data) {
            self.view.alpha = 0.3;
            [SVProgressHUD setStatus:@"Download of image failed for some reason"];
            return;
        }
        
        // got the photo, so lets show it
        UIImage *image = [UIImage imageWithData:data];
        imageView = [[UIImageView alloc] initWithImage:image];
        
        [uiScrollView addSubview:imageView];
        [self.view addSubview:uiScrollView];
        
        //[uiScrollView setZoomScale:uiScrollView.minimumZoomScale];
        
        imageView.size = imgSize;
        imageView.alpha = 0;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        
        // fade the image in
        [UIView animateWithDuration:0.2 animations:^{
            imageView.alpha = 1;
        }];
        
    });
     
     */
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

-(float)calculateZoomScale {
    
    float heightRatio = imgSize.height / ([self screenSize].height - 50);
    float widthRatio = imgSize.width / [self screenSize].width;
    
    return heightRatio >= widthRatio ? heightRatio : widthRatio;
}


@end