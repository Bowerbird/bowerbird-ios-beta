//
//  Created by matt on 28/09/12.
//

#import "MGBox.h"
#import "BBConstants.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderDelegate.h"
#import "UIImageView+WebCache.h"

@interface PhotoBox : MGBox <
    SDWebImageDownloaderDelegate
>

@property (nonatomic,retain) UIView *spinnerView;

+ (PhotoBox *)photoAddBoxWithSize:(CGSize)size;
+ (PhotoBox *)photoBoxFor:(int)i size:(CGSize)size;
+ (PhotoBox *)mediaFor:(NSString*)mediaUrl size:(CGSize)size;
+ (PhotoBox *)mediaForMap:(NSString*)url size:(CGSize)size;
+ (PhotoBox *)mediaForImage:(UIImage*)image size:(CGSize)size;
- (void)loadPhotoFromLocation:(NSString*)photoUrl fromBowerBird:(BOOL)bowerbird;
- (void)loadPhotoFromImage:(UIImage*)image;
- (void)loadPhoto;

@end