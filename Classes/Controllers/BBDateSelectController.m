/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Displays a custom, wrapped picker with dates to sit inside the CreateSighting VC
 
 -----------------------------------------------------------------------------------------------*/


#import "BBDateSelectController.h"
#import "BBHelpers.h"
#import "BBDateSelectView.h"


@implementation BBDateSelectController


#pragma mark -
#pragma mark - Member Accessors


@synthesize controller = _controller,
            dateSelectView = _dateSelectView;


#pragma mark -
#pragma mark - Constructors


-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBDateSelectController.initWithDelegate"];
    
    self = [super init];
    
    _controller = delegate;
    _dateSelectView = [[BBDateSelectView alloc]initWithDelegate:self];
    _dateSelectView.backgroundColor = [UIColor whiteColor];
    
    return self;
}


#pragma mark -
#pragma mark - Rendering


-(void)loadView {
    [BBLog Log:@"BBDateSelectController.loadView"];
    
    self.view = self.dateSelectView;
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(NSDate*)createdOn {
    [BBLog Log:@"BBDateSelectController.createdOn"];
    
    return [_controller createdOn];
}

-(void)updateCreatedOn:(NSDate*)date {
    [BBLog Log:@"BBDateSelectController.updateCreatedOn:"];
    
    if([_controller respondsToSelector:@selector(updateCreatedOn:)]){
        [_controller updateCreatedOn:date];
    }
    else [BBLog Log:@"LOGIC ERROR: BBObservationEditController does not respond to updateCreatedOn"];
}

-(void)createdOnStopEdit {
    [BBLog Log:@"BBDateSelectController.createdOnStopEdit"];
    
    if([_controller respondsToSelector:@selector(createdOnStopEdit)]){
        [_controller createdOnStopEdit];
    }
    else [BBLog Log:@"LOGIC ERROR: BBObservationEditController does not respond to createdOnStopEdit"];
}


@end