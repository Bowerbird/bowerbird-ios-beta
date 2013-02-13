/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBUserHeadingView.h"
#import "BBPlusView.h"


@implementation BBUserHeadingView 


@synthesize headingLabel =_headingLabel;


-(void)setHeadingText:(NSString *)heading{
    [BBLog Log:@"BBHeaderView.setHeadingText:"];
    
    self.headingLabel.text = heading;
}

-(BBUserHeadingView *)initWithSize:(CGSize)size
                     andTitle:(NSString *)title {
    [BBLog Log:@"BBHeaderView.initWithSize:andTitle:"];
    
    self = [BBUserHeadingView boxWithSize:size];
    
    UIColor *headerBgColor = [UIColor whiteColor]; //[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    self.backgroundColor = headerBgColor;
    self.tag = -1;
    self.contentLayoutMode = MGLayoutTableStyle;
    
    UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(PADDING,PADDING,HEADER_BTTN.width, HEADER_BTTN.height)];
    menuBtn.frame = CGRectMake(PADDING,PADDING,HEADER_BTTN.width, HEADER_BTTN.height);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    menuBtn.backgroundColor = headerBgColor;
    [menuBtn addTarget:self action:@selector(menuTapped) forControlEvents:UIControlEventTouchDown];
    
    self.headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
    self.headingLabel.text = title;
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(size.width - HEADER_BTTN.width - PADDING, PADDING, HEADER_BTTN.width, HEADER_BTTN.height);
    
    UIColor *plusColour = [UIColor colorWithRed:0.26 green:0.57 blue:0.88 alpha:1.0];
    UIColor *backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    
    BBPlusView *actionView = [[BBPlusView alloc]initWithFrame:frame
                                                  andBgColour:backgroundColor
                                                andPlusColour:plusColour
                                                  andPlusSize:10];
    
    actionBtn.frame = CGRectMake(size.width - HEADER_BTTN.width - PADDING, PADDING, HEADER_BTTN.width, HEADER_BTTN.height);
    [actionBtn addSubview:actionView];
    [actionBtn addTarget:self action:@selector(actionTapped) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:menuBtn];
    [self addSubview:self.headingLabel];
    //[self addSubview:logoView];
    [self addSubview:actionBtn];
        
    return self;
}

-(void)menuTapped {
    [BBLog Log:@"BBHeaderView.menuTapped"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}

-(void)actionTapped {
    [BBLog Log:@"BBHeaderView.actionTapped"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTapped" object:nil];
}


@end