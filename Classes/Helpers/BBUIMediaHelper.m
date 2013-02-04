/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
  -----------------------------------------------------------------------------------------------*/


#import "BBUIMediaHelper.h"
#import "BBHelpers.h"
#import "BBBaseMedia.h"
#import "BBMedia.h"
#import "BBImage.h"
#import "BBCollectionHelper.h"
#import "BBMediaResource.h"
#import "BBObservation.h"


@implementation BBUIMediaHelper


/*
-(MGBox*)displayMedia:(BBObservation*)observation {
    
    MGBox *mediaWrapperBox = [MGBox box];
    
    BBImage *fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240"
                                                      fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    BBImage *originalSize = [self getImageWithDimension:@"Original"
                                            fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    
    MGBox* currentImageBox = [MGBox box];
    currentImageBox.width = 300;
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:CGSizeMake(300, 240)];
    __weak UINavigationController *nav = self.navigationController;
    currentPic.onTap = ^{
        BBDisplayFullImageController *fullImageController = [[BBDisplayFullImageController alloc]initWithImage:originalSize];
        [nav pushViewController:fullImageController animated:NO];
    };
    
    [currentImageBox.boxes addObject:currentPic];
    
    [mediaWrapperBox.boxes addObject:currentImageBox];
    MGBox *thumbs = [MGBox box];
    thumbs.width = 300;
    thumbs.contentLayoutMode = MGLayoutGridStyle;
    // add the thumb nails
    if(observation.media.count > 1)
    {
        // take the current box out - add the new box
        for (__block BBMedia* m in observation.media) {
            PhotoBox *thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.imageMedia].uri
                                            size:(CGSizeMake(90, 90))];
            thumb.onTap = ^{
                [self displayFullSizeImage:m toReplace:currentPic];
            };
            [thumbs.boxes addObject:thumb];
        }
    }
    [mediaWrapperBox.boxes addObject:thumbs];
    
    return mediaWrapperBox;
}



+(MGBox *)createMediaViewerForMedia:(NSArray*)media
                        withPrimary:(BBMedia*)primaryMedia
                            forSize:(CGSize)size
                   displayingThumbs:(BOOL)displayThumbs {
    
    [BBLog Log:@"BBUIControlHelper.createMediaViewerForMedia:"];
    
    // create the box:
    MGBox *mediaViewer = [MGBox boxWithSize:size];
    mediaViewer.boxLayoutMode = MGLayoutTableStyle;
    
    // grab the primary media's fullsize image:
    BBMediaType typeOfMedia = [BBUIMediaHelper typeOfMedia:primaryMedia.mediaResource.mediaType];
    BBImage *fullSizePrimary = [BBUIMediaHelper getPrimaryImageForMedia:primaryMedia
                                                                 ofType:typeOfMedia];
    
    // fetch and insert the primary media into the fullsize box:
    __block MGBox* currentImageBox = [MGBox boxWithSize:CGSizeMake(300, 240)];
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSizePrimary.uri size:CGSizeMake(300, 240)];
    [currentImageBox.boxes addObject:currentPic];
    [mediaViewer.boxes addObject:currentImageBox];
    
    
    switch (typeOfMedia) {
        case BBMediaImage:
        {
            
            
            // add the thumb nails
            if(displayThumbs && media.count > 1)
            {
                MGBox *thumbs = [MGBox box];
                thumbs.contentLayoutMode = MGLayoutGridStyle;
                
                for (BBMedia* m in media)
                {
                    PhotoBox *thumb = [PhotoBox mediaFor:[BBCollectionHelper getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.imageMedia].uri size:(CGSizeMake(80, 80))];
                    
                    thumb.onTap = ^{
                        BBImage *fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:m.mediaResource.imageMedia];
                        MGBox *section = (id)currentPic.parentBox;
                        [section.boxes removeAllObjects];
                        [section.boxes addObject:[PhotoBox mediaFor:fullSize.uri size:IPHONE_OBSERVATION]];
                        [section layoutWithSpeed:0.0 completion:nil];
                    };
                    
                    [thumbs.boxes addObject:thumb];
                }
                
                [mediaViewer.boxes addObject:thumbs];
            }
        }
        break;
        
        case BBMediaAudio:
            
            fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:primaryMedia.mediaResource.audioMedia];
            
            
            
            
            
            break;
        case BBMediaVideo:
            
            fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:primaryMedia.mediaResource.videoMedia];
            
            
            
            
            
            
            break;
        case BBMediaUnknown:
            
            // don't display anything - perhaps use a placeholder
            
        default:
            break;
    }
    
    
    
    return mediaViewer;
}

+(BBImage*)getPrimaryImageForMedia:(BBMedia*)media ofType:(BBMediaType)mediaType {
    
    switch (mediaType) {
        case BBMediaImage:
            return (BBImage*)[BBUIMediaHelper getMediaOfSize:@"Constrained240" from:media.mediaResource.imageMedia];
            
        case BBMediaAudio:
            return (BBImage*)[BBUIMediaHelper getMediaOfSize:@"Constrained240" from:media.mediaResource.audioMedia];
            
        case BBMediaVideo:
            return (BBImage*)[BBUIMediaHelper getMediaOfSize:@"Constrained240" from:media.mediaResource.videoMedia];
            
        case BBMediaUnknown:
        default:
            // return a default image;
            break;
    }
}
 
*/


+(BBBaseMedia*)getMediaOfSize:(NSString*)sizeName from:(NSArray*)mediaItems {
    return [BBCollectionHelper getImageWithDimension:sizeName fromArrayOf:mediaItems];
}


+(BBMediaType)typeOfMedia:(NSString*)mediaType {
    return
    [[mediaType lowercaseString] isEqualToString:@"image"] ? BBMediaImage :
    [[mediaType lowercaseString] isEqualToString:@"video"] ? BBMediaVideo :
    [[mediaType lowercaseString] isEqualToString:@"audio"] ? BBMediaAudio :
    BBMediaUnknown;
}


@end
