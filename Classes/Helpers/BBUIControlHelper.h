/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "MGHelpers.h"
#import "BBArrowView.h"


@class BBClassification, BBSighting, BBObservation, BBMedia, BBIdentification, BBUser;


typedef void (^ActionBlock)();

@interface BBUIControlHelper : NSObject

+(UIImage *)arrow;

+(UIImage *)back;

+(UITextField *)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)text andDelegate:(id)delegate;

+(UITextView *)createTextViewWithFrame:(CGRect)frame andDelegate:(id)delegate;

+(CoolMGButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString*)text withBlock:(ActionBlock)block;

+(MGTableBoxStyled *)createMGTableBoxStyledWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding;

+(MGTableBox *)createMGTableBoxWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding;

+(MGLine *)createCurrentClassification:(BBClassification*)classification forSize:(CGSize)size;

+(MGBox *)createSelectedClassification:(BBClassification*)classification forSize:(CGSize)size;

+(MGLine *)createLocationViewForSighting:(BBSighting*)sighting forSize:(CGSize)size;

+(MGLine *)createUserProfileLineForUser:(BBUser*)usr withDescription:(NSString*)desc forSize:(CGSize)size;

+(MGLine *)createIdentification:(BBIdentification*)identification forSize:(CGSize)size;

+(MGBox *)createMediaViewerForMedia:(NSArray*)media withPrimary:(BBMedia*)primaryMedia forSize:(CGSize)size displayingThumbs:(BOOL)displayThumbs ;

+(MGLine *)createSubHeadingWithTitle:(NSString*)title forSize:(CGSize)size;

+(PhotoBox*)createCategoryImageBoxForCategory:(NSString*)category withSize:(CGSize)size;

+(MGTableBoxStyled *)createSubObservation:(BBObservation*)observation forSize:(CGSize)size withBlock:(ActionBlock)block;

+(MGLine *)createTwoColumnRowWithleftText:(NSString*)leftText
                 andRightText:(NSString*)rightText
                    andHeight:(double)height
                 andLeftWidth:(double)leftWidth
                andRightWidth:(double)rightWidth;


@end