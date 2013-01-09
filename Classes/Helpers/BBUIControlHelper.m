//
//  BBUIControlHelper.m
//  BowerBird
//
//  Created by Hamish Crittenden on 31/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBUIControlHelper.h"

@implementation BBUIControlHelper

+(UIImage *)arrow {
    return [UIImage imageNamed:@"arrow.png"];
}

+(UIImage *)back {
    return [UIImage imageNamed:@"back.png"];
}


+(UITextField *)createTextFieldWithFrame:(CGRect)frame
                          andPlaceholder:(NSString*)text
                             andDelegate:(id)delegate {
    //UITextField *textField = [[UITextField alloc]init];
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = text;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = delegate;
    
    return textField;
}

+(UITextView *)createTextViewWithFrame:(CGRect)frame
                           andDelegate:(id)delegate {
    //UITextField *textField = [[UITextField alloc]init];
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:15];

    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = delegate;
    
    return textView;
}

+(CoolMGButton *)createButtonWithFrame:(CGRect)frame
                              andTitle:(NSString*)text
                             withBlock:(ActionBlock)block {
    CoolMGButton *button = [[CoolMGButton alloc]initWithFrame:frame];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    //[button setButtonColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1]];
    [button setButtonColor:[UIColor colorWithRed:0.38 green:0.65 blue:0.9 alpha:1]];
    [button onControlEvent:UIControlEventTouchUpInside do:block];
    
    return button;
}

+(MGTableBoxStyled *)createMGTableBoxStyledWithSize:(CGSize)size
                                         andBGColor:(UIColor *)color
                                         andHeading:(NSString*)heading
                                         andPadding:(UIEdgeInsets)padding {
    MGTableBoxStyled *styledTable = [MGTableBoxStyled boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}

+(MGTableBox *)createMGTableBoxWithSize:(CGSize)size
                             andBGColor:(UIColor *)color
                             andHeading:(NSString*)heading
                             andPadding:(UIEdgeInsets)padding {
    MGTableBox *styledTable = [MGTableBox boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}

+(MGLine *)createUserProfileLineForUser:(BBUser*)usr
                        withDescription:(NSString*)desc
                                forSize:(CGSize)size {
    [BBLog Log:@"BBUIControlHelper.createUserProfileDescriptionForUser"];

    // AVATAR
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:usr.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    // parameterise the allowable size for the description line. Allows caller to put an arrow to the left or right of the user profile.
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = size.width - 50 - horizontalPaddingTotalWidth * 2;
    
    // ACTIVITY DISCRIPTION
    MGLine *description = [MGLine multilineWithText:desc
                                               font:DESCRIPTOR_FONT
                                              width:descriptionWidth
                                            padding:UIEdgeInsetsMake(15, horizontalPaddingTotalWidth/2, 0, horizontalPaddingTotalWidth/2)];
    
    description.underlineType = MGUnderlineNone;
    
    // COMBINED AVATAR AND DESCRIPTION
    MGLine *user = [MGLine lineWithLeft:avatar
                                  right:description size:size];
    
    user.underlineType = MGUnderlineNone;
    
    return user;
}

+(MGLine *)createLocationViewForSighting:(BBSighting*)sighting
                                 forSize:(CGSize)size {
    return [MGLine line];
}

+(MGBox *)createMediaViewerForMedia:(NSArray*)media
                        withPrimary:(BBMedia*)primaryMedia
                            forSize:(CGSize)size
                   displayingThumbs:(BOOL)displayThumbs {
    
    [BBLog Log:@"BBUIControlHelper.createMediaViewerForMedia:"];
    
    MGBox *mediaViewer = [MGBox boxWithSize:size];
    mediaViewer.boxLayoutMode = MGLayoutTableStyle;
    BBImage *fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:primaryMedia.mediaResource.imageMedia];
    
    __block MGBox* currentImageBox = [MGBox boxWithSize:CGSizeMake(300, 240)];
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:CGSizeMake(300, 240)];
    [currentImageBox.boxes addObject:currentPic];
    
    [mediaViewer.boxes addObject:currentImageBox];
    
    // add the thumb nails
    if(displayThumbs && media.count > 1)
    {
        MGBox *thumbs = [MGBox box];
        thumbs.contentLayoutMode = MGLayoutGridStyle;
        
        // take the current box out - add the new box
        //for (__block BBMedia* m in media)
        for (BBMedia* m in media)
        {
            //__weak PhotoBox *thumb = [PhotoBox mediaFor:[BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:m.mediaResource.imageMedia].uri size:(CGSizeMake(50, 50))];
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
    
    return mediaViewer;
}

+(MGLine *)createIdentification:(BBIdentification*)identification
                        forSize:(CGSize)size {
    
    BBApplication *appData = [BBApplication sharedInstance];
    NSArray* categories = appData.authenticatedUser.categories;
    __block BBCategory* selectedCategory;
    [categories enumerateObjectsUsingBlock:^(BBCategory* category, NSUInteger idx, BOOL *stop) {
        if([category.name isEqualToString:identification.category]){
            selectedCategory = category;
            *stop = YES;
        }
    }];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [selectedCategory.name lowercaseString]];
    UIImage *photoImage = [UIImage imageNamed:iconPath];
    PhotoBox *categoryIcon = [PhotoBox mediaForImage:photoImage size:CGSizeMake(70, 70)];
    
    NSString *identificationText = [NSString stringWithFormat:@"Category: %@\n%@: %@\nName: %@", selectedCategory.name, [identification.rankType capitalizeFirstLetter], identification.rankName, identification.name];
    MGLine *identificationInfo = [MGLine multilineWithText:identificationText font:DESCRIPTOR_FONT width:220 padding:UIEdgeInsetsMake(0, 10, 0, 0)];
    identificationInfo.underlineType = MGUnderlineNone;
    
    MGLine *categoryLine = [MGLine lineWithLeft:categoryIcon right:identificationInfo size:size];
    categoryLine.bottomMargin = 10;
    categoryLine.underlineType = MGUnderlineNone;
    
    return categoryLine;
}

+(MGLine *)createCurrentClassification:(BBClassification*)classification
                               forSize:(CGSize)size {
    
    BBApplication *appData = [BBApplication sharedInstance];
    NSArray* categories = appData.authenticatedUser.categories;
    __block BBCategory* selectedCategory;
    [categories enumerateObjectsUsingBlock:^(BBCategory* category, NSUInteger idx, BOOL *stop) {
        if([category.name isEqualToString:classification.category]){
            selectedCategory = category;
            *stop = YES;
        }
    }];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [selectedCategory.name lowercaseString]];
    UIImage *photoImage = [UIImage imageNamed:iconPath];
    PhotoBox *categoryIcon = [PhotoBox mediaForImage:photoImage size:CGSizeMake(70, 70)];
    
    NSString *identificationText = [NSString stringWithFormat:@"Category: %@\n%@: %@\nName: %@", selectedCategory.name, [classification.rankType capitalizeFirstLetter], classification.rankName, classification.name];
    MGLine *identificationInfo = [MGLine multilineWithText:identificationText font:DESCRIPTOR_FONT width:220 padding:UIEdgeInsetsMake(0, 10, 0, 0)];
    identificationInfo.underlineType = MGUnderlineNone;
    
    MGLine *categoryLine = [MGLine lineWithLeft:categoryIcon right:identificationInfo size:size];
    categoryLine.bottomMargin = 10;
    categoryLine.underlineType = MGUnderlineNone;
    
    return categoryLine;
}

+(PhotoBox*)createCategoryImageBoxForCategory:(NSString*)category
                                     withSize:(CGSize)size {
    
    BBApplication *appData = [BBApplication sharedInstance];
    NSArray* categories = appData.authenticatedUser.categories;
    __block BBCategory* selectedCategory;
    [categories enumerateObjectsUsingBlock:^(BBCategory* cat, NSUInteger idx, BOOL *stop) {
        if([cat.name isEqualToString:category]){
            selectedCategory = cat;
            *stop = YES;
        }
    }];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [selectedCategory.name lowercaseString]];
    UIImage *photoImage = [UIImage imageNamed:iconPath];
    PhotoBox *categoryIcon = [PhotoBox mediaForImage:photoImage size:size];
    
    return categoryIcon;
}


+(MGBox *)createSelectedClassification:(BBClassification*)classification
                               forSize:(CGSize)size {
    
    MGBox *selectedClassificationBox = [MGBox boxWithSize:size];
    BBApplication *appData = [BBApplication sharedInstance];
    NSArray* categories = appData.authenticatedUser.categories;
    __block BBCategory* selectedCategory;
    [categories enumerateObjectsUsingBlock:^(BBCategory* category, NSUInteger idx, BOOL *stop) {
        if([category.name isEqualToString:classification.category]){
            selectedCategory = category;
            *stop = YES;
        }
    }];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [selectedCategory.name lowercaseString]];
    UIImage *photoImage = [UIImage imageNamed:iconPath];
    PhotoBox *categoryIcon = [PhotoBox mediaForImage:photoImage size:CGSizeMake(50, 50)];
    
    if(selectedCategory.name == nil) {
        // display instructions to find an identification
        MGLine *browseForIdentification = [MGLine multilineWithText:@"Navigate the taxanomic ranks below to make your identification" font:HEADER_FONT width:300 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
        browseForIdentification.underlineType = MGUnderlineNone;
        selectedClassificationBox.height = 50;
        [selectedClassificationBox.boxes addObject:browseForIdentification];
    }
    else {
        // display the currently selected identification
        NSString *categoryName = selectedCategory.name != nil ? selectedCategory.name : @"Undetermined";
        NSString *taxonomyName = classification.taxonomy != nil ? classification.taxonomy : @"Undetermined";
        
        NSString *identificationText = [NSString stringWithFormat:@"Category: %@\nName: %@", categoryName, classification.name];
        NSString *taxonomyText = [NSString stringWithFormat:@"Taxonomy: %@", taxonomyName];
        
        MGLine *identificationInfo = [MGLine multilineWithText:identificationText font:DESCRIPTOR_FONT width:240 padding:UIEdgeInsetsMake(0, 10, 0, 0)];
        identificationInfo.underlineType = MGUnderlineNone;
        
        MGLine *taxonomyInfo = [MGLine multilineWithText:taxonomyText font:DESCRIPTOR_FONT width:300 padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxonomyInfo.underlineType = MGUnderlineNone;
        
        MGLine *categoryLine = [MGLine lineWithLeft:categoryIcon right:identificationInfo size:CGSizeMake(size.width, 70)];
        categoryLine.underlineType = MGUnderlineNone;
        
        [selectedClassificationBox.boxes addObject:categoryLine];
        [selectedClassificationBox.boxes addObject:taxonomyInfo];
    }
    
    return selectedClassificationBox;
}

+(MGLine *)createSubHeadingWithTitle:(NSString*)title
                             forSize:(CGSize)size {
    MGLine *titleLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%@:", title] right:nil size:size];
    titleLine.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    UIFont *subHeadingFont = [UIFont systemFontOfSize:12]; //DESCRIPTOR_FONT;
    titleLine.textColor = [UIColor grayColor];
    titleLine.font = subHeadingFont;
    titleLine.underlineType = MGUnderlineBottom;
    titleLine.backgroundColor = [UIColor whiteColor];
    
    return titleLine;
}

+(MGTableBox *)createSubObservation:(BBObservation*)observation
                            forSize:(CGSize)size
                          withBlock:(ActionBlock)block {
    
    BBImage *primaryMediaImage = [BBCollectionHelper getImageWithDimension:@"Square100" fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    PhotoBox *photo = [PhotoBox mediaFor:primaryMediaImage.uri size:CGSizeMake(100, 100)];
    photo.margin = UIEdgeInsetsZero;
    photo.padding = UIEdgeInsetsZero;
    
    MGTableBox* subObservationTable = [[MGTableBox alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subObservationTable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    subObservationTable.margin = UIEdgeInsetsMake(10, 10, 0, 0);
    
    MGBox* subObservationSummary = [MGBox boxWithSize:CGSizeMake(size.width, size.height)];
    subObservationSummary.contentLayoutMode = MGLayoutGridStyle;
    
    MGBox* subObservationMedia = [MGBox boxWithSize:CGSizeMake(100, 100)];
    [subObservationMedia.boxes addObject:photo];
    subObservationMedia.margin = UIEdgeInsetsZero;
    subObservationMedia.padding = UIEdgeInsetsZero;
    [subObservationSummary.boxes addObject:subObservationMedia];
    
    // add a box to the right of the image box to display the summary for the observation.
    MGBox *sightingSummary = [MGBox box];
    sightingSummary.width = 140;
    sightingSummary.margin = UIEdgeInsetsMake(0, 10, 0, 0);
    sightingSummary.contentLayoutMode = MGLayoutTableStyle;
    
    MGLine *titleLine = [MGLine multilineWithText:observation.title font:[UIFont boldSystemFontOfSize:13] width:135 padding:UIEdgeInsetsMake(0, 0, 0, 0)];
    [sightingSummary.boxes addObject:titleLine];
    MGLine *noteCountLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i notes", [observation.noteCount intValue]] right:nil size:CGSizeMake(120,20)];
    noteCountLine.font = SMALL_DESCRIPTOR_FONT;
    [sightingSummary.boxes addObject:noteCountLine];
    MGLine *projectCountLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i projects", [observation.projectCount intValue]] right:nil size:CGSizeMake(120,20)];
    projectCountLine.font = SMALL_DESCRIPTOR_FONT;
    [sightingSummary.boxes addObject:projectCountLine];
    MGLine *commentCountLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i comments", [observation.commentCount intValue]] right:nil size:CGSizeMake(120,20)];
    commentCountLine.font = SMALL_DESCRIPTOR_FONT;
    [sightingSummary.boxes addObject:commentCountLine];
    
    [subObservationSummary.boxes addObject:sightingSummary];
    
    MGBox *detailArrowBox = [BBUIControlHelper getForwardArrow];
    detailArrowBox.margin = UIEdgeInsetsMake(10, 10, 0, 0);
    [subObservationSummary.boxes addObject:detailArrowBox];

    MGLine *subSightingTitleLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%@:", @"The Original Sighting"] right:nil size:CGSizeMake(size.width, 20)];
    subSightingTitleLine.padding = UIEdgeInsetsMake(5, 0, 5, 10);
    subSightingTitleLine.textColor = [UIColor grayColor];
    subSightingTitleLine.font = [UIFont systemFontOfSize:12];
    subSightingTitleLine.underlineType = MGUnderlineBottom;
    subSightingTitleLine.backgroundColor = [UIColor whiteColor];
    
    [subObservationTable.topLines addObject:subSightingTitleLine];
    [subObservationTable.middleLines addObject:subObservationSummary];
    
    /*
    NSString *subObservationCreatorText = [NSString stringWithFormat:@"%@ sighted %@", observation.user.name, [observation.observedOnDate timeAgo]];
    MGLine *subObservationCreator = [BBUIControlHelper createUserProfileLineForUser:observation.user
                                                                    withDescription:subObservationCreatorText
                                                                            forSize:CGSizeMake(size.width, 60)];
    
    subObservationCreator.underlineType = MGUnderlineBottom;
    [subObservation.bottomLines addObject:subObservationCreator];
    */
    
    subObservationTable.onTap = block;
    return subObservationTable;
}

+(MGLine *)createTwoColumnRowWithleftText:(NSString*)leftText
                             andRightText:(NSString*)rightText
                                andHeight:(double)height
                             andLeftWidth:(double)leftWidth
                            andRightWidth:(double)rightWidth {
    
    MGLine *leftCol = [MGLine lineWithLeft:leftText right:nil size:CGSizeMake(leftWidth, height)];
    MGLine *rightCol = [MGLine lineWithLeft:rightText right:nil size:CGSizeMake(rightWidth, height)];
    MGLine *line = [MGLine lineWithLeft:leftCol right:rightCol size:CGSizeMake(leftWidth+rightWidth, height)];
    
    return line;
}

+(MGBox*)createBoxForIdentification:(BBIdentification*)identification
                           withSize:(CGSize)size{
    MGBox *identificationBox = [MGBox boxWithSize:size];
    
    // get the category image for the identification
    BBApplication *app = [BBApplication sharedInstance];

    // display the taxonomy, name et al for the identification
    return identificationBox;
}

+(MGBox*)getForwardArrow {
    // Set up reusable forward and back arrows
    UIView *forwardArrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                             andDirection:BBArrowNext
                                           andArrowColour:[UIColor colorWithRed:0.26 green:0.57 blue:0.88 alpha:1.0]
                                              andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(forwardArrow.width, forwardArrow.height)];
    [arrowWrapper addSubview:forwardArrow];
    
    return arrowWrapper;
}

@end