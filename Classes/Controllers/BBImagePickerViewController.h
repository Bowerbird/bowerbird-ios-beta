/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BBImagePickerViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *takePictureButton;
    IBOutlet UIButton *selectFromCameraRollButton;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *takePictureButton;
@property (nonatomic, retain) UIButton *selectFromCameraRollButton;

- (IBAction)getCameraPicture:(id)sender;
- (IBAction)selectExistingPicture;

@end