/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBSightingDataSource.h"
#import "BBSightingEditDelegateProtocol.h"
#import "BBUIControlHelper.h"
#import "MGHelpers.h"
#import "BBHelpers.h"


@class BBMediaEdit, BBProject;


#define SIGHTING_TABLE_SIZE     (CGSize){300,40}
#define EDGE_10_PADDING         (UIEdgeInsets){10,10,10,10}


@interface BBSightingEditView : MGScrollView <
     UITextFieldDelegate
>

@property (nonatomic,retain) id<BBSightingEditDelegateProtocol> controller;
@property (nonatomic,retain) id<BBSightingDataSource> dataSource;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UIPickerView *categoryPickerView;
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,strong) UILabel *locationLatitude;
@property (nonatomic,strong) UILabel *locationLongitude;
@property (nonatomic,strong) UILabel *locationAddress;
@property (nonatomic,strong) UIPickerView *projectPickerView;
@property (nonatomic,strong) UIButton *addMediaButton;
@property (nonatomic,strong) UIButton *changeLocationButton;
@property (nonatomic,strong) UILabel *observedOnLabel;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) MGBox *mediaBox;
@property (nonatomic,strong) MGTableBoxStyled *titleTable, *mediaTable, *observedOnTable, *locationTable, *categoryTable, *projectsTable, *actionTable;

-(UITextField *)createTextFieldWithFrame:(CGRect)frame
                          andPlaceholder:(NSString*)text;

-(CoolMGButton *)createButtonWithFrame:(CGRect)frame
                              andTitle:(NSString*)text
                             withBlock:(ActionBlock)block;

-(BBSightingEditView*)initWithDelegate:(id<BBSightingEditDelegateProtocol>)delegate asObservation:(BOOL)isObservation;

-(void)addMediaItem:(BBMediaEdit *)media;

-(void)addSightingProject:(BBProject*)project;

-(void)updateLatLongDisplay:(CGPoint)location;

-(void)updateLocationAddress:(NSString*)address;

@end