/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 This provides a custom selector to choose a category by displaying the icon and name
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCategoryPickerController.h"
#import "BBAuthenticatedUser.h"
#import "BBCategoryPickerView.h"
#import "BBApplication.h"


@implementation BBCategoryPickerController


#pragma mark -
#pragma mark - Member Accessors


@synthesize delegate = _delegate,
            categoryPickerView = _categoryPickerView;


#pragma mark -
#pragma mark - Constructors


-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBCategoryPickerController.initWithDelegate"];
    
    self = [super init];
    _delegate = delegate;
    _categoryPickerView = [[BBCategoryPickerView alloc]initWithDelegate:self];
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


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


#pragma mark -
#pragma mark - Delegation and Event Handling


-(NSArray*)getCategories {
    [BBLog Log:@"BBCategoryPickerController.getCategories"];
    
    return [BBCategory getCategoryList];
}

-(void)updateCategory:(BBCategory*)category {
    [BBLog Log:@"BBCategoryPickerController.updateCategory:"];
    
    [self.delegate updateCategory:category];
}

-(void)categoryStopEdit {
    [BBLog Log:@"BBCategoryPickerController.categoryStopEdit"];
    
    [_delegate categoryStopEdit];
}


@end