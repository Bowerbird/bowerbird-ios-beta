/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBActionController.h"
#import "MGHelpers.h"
#import "BBHelpers.h"


@implementation BBActionController {
    MGBox *actionView;
    UIImage *arrow;
}


#pragma mark -
#pragma mark - Rendering


-(void)loadView{
    [BBLog Log:@"BBActionController.loadView"];
    
    self.view = [MGBox boxWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    
    arrow = [UIImage imageNamed:@"arrow.png"];
    actionView = (MGBox*)self.view;
 }

- (void)viewDidLoad {
    [BBLog Log:@"BBActionController.viewDidLoad"];
    
    [super viewDidLoad];

    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [tapGestureRecognize requireGestureRecognizerToFail:tapGestureRecognize];
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    UISwipeGestureRecognizer *downRecognizer;
    downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [downRecognizer setDirection: UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:downRecognizer];
    
    [self populateAction];
    self.view.alpha = 0;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)populateAction {
    
    MGTableBox *actionChooser = [MGTableBox boxWithSize:CGSizeMake(320, 0)];
    actionChooser.margin = UIEdgeInsetsZero;
    actionChooser.padding = UIEdgeInsetsZero;

    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 288,54)];
    bowerbirdImage.image =[UIImage imageNamed:@"logo-negative.png"];
    MGLine *bowerbirdLogo = [MGLine lineWithSize:CGSizeMake(320,60)];
    bowerbirdLogo.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    bowerbirdLogo.margin = UIEdgeInsetsZero;
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    [actionChooser.topLines addObject:bowerbirdLogo];

    [actionView.boxes addObject:actionChooser];
    
    MGTableBoxStyled *camera = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 44)];
    UIImageView *cameraIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 58,44)];
    cameraIcon.image =[UIImage imageNamed:@"camera-icon.png"];
    [camera.topLines addObject:[MGLine lineWithLeft:cameraIcon right:@"Observe with Camera" size:CGSizeMake(280,44)]];
    camera.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCameraTapped" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
    };
    [actionView.boxes addObject:camera];
    
    MGTableBoxStyled *record = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 44)];
    UIImageView *recordIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 58,44)];
    recordIcon.image =[UIImage imageNamed:@"record-icon.png"];
    [record.topLines addObject:[MGLine lineWithLeft:recordIcon right:@"Record a sighting" size:CGSizeMake(280,44)]];
    record.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createRecordTapped" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
   };
    //[actionView.boxes addObject:record];
    
    MGTableBoxStyled *library = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 44)];
    UIImageView *libraryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 58,44)];
    libraryIcon.image =[UIImage imageNamed:@"global-icon.png"];
    [library.topLines addObject:[MGLine lineWithLeft:libraryIcon right:@"Choose an existing Image" size:CGSizeMake(280,44)]];
    library.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseLibraryTapped" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
    };
    [actionView.boxes addObject:library];

    [(MGBox*)self.view layoutWithSpeed:0.3 completion:^{self.view.height = [UIScreen mainScreen].bounds.size.height;}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBActionController.singleTapGestureRecognizer:"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
}

- (void)handleSwipeDown:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBMenuController.handleSwipeFrom:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTappedClose" object:nil];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBActionController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end