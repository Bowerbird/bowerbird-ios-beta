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


+(UITextField *)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)text andDelegate:(id)delegate {
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

+(CoolMGButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString*)text withBlock:(ActionBlock)block {
    CoolMGButton *button = [[CoolMGButton alloc]initWithFrame:frame];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    //[button setButtonColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1]];
    [button setButtonColor:[UIColor colorWithRed:0.38 green:0.65 blue:0.9 alpha:1]];
    [button onControlEvent:UIControlEventTouchUpInside do:block];
    
    return button;
}

+(MGTableBoxStyled *)createMGTableBoxStyledWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding {
    MGTableBoxStyled *styledTable = [MGTableBoxStyled boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}

+(MGTableBox *)createMGTableBoxWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding {
    MGTableBox *styledTable = [MGTableBox boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}

+(MGLine *)createUserProfileLineForUser:(BBUser*)usr withDescription:(NSString*)desc forSize:(CGSize)size {
    [BBLog Log:@"BBUIControlHelper.createUserProfileDescriptionForUser"];
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:usr.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_AVATAR_SIZE];
    
    // parameterise the allowable size for the description line. Allows caller to put an arrow to the left or right of the user profile.
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = size.width - IPHONE_AVATAR_SIZE.width - horizontalPaddingTotalWidth;
    
    MGLine *description = [MGLine multilineWithText:desc font:DESCRIPTOR_FONT width:descriptionWidth padding:UIEdgeInsetsMake(15, horizontalPaddingTotalWidth/2, 0, horizontalPaddingTotalWidth/2)];
    description.underlineType = MGUnderlineNone;
    MGLine *user = [MGLine lineWithLeft:avatar right:description size:size];
    user.underlineType = MGUnderlineNone;
    
    return user;
}

+(MGLine *)createLocationViewForSighting:(BBSighting*)sighting forSize:(CGSize)size {
    return [MGLine line];
}

+(MGBox *)createMediaViewerForMedia:(NSArray*)media withPrimary:(BBMedia*)primaryMedia forSize:(CGSize)size displayingThumbs:(BOOL)displayThumbs {
    [BBLog Log:@"BBUIControlHelper.createMediaViewerForMedia:"];
    
    MGBox *mediaViewer = [MGBox boxWithSize:size];
    mediaViewer.boxLayoutMode = MGLayoutTableStyle;
    BBImage *fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:primaryMedia.mediaResource.imageMedia];
    
    MGBox* currentImageBox = [MGBox boxWithSize:CGSizeMake(300, 240)];
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:CGSizeMake(300, 240)];
    [currentImageBox.boxes addObject:currentPic];
    
    [mediaViewer.boxes addObject:currentImageBox];
    
    // add the thumb nails
    if(displayThumbs && media.count > 1)
    {
        MGBox *thumbs = [MGBox box];
        thumbs.contentLayoutMode = MGLayoutGridStyle;
        
        // take the current box out - add the new box
        for (__block BBMedia* m in media)
        {
            PhotoBox *thumb = [PhotoBox mediaFor:[BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:m.mediaResource.imageMedia].uri size:(CGSizeMake(50, 50))];
            
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

+(MGLine *)createIdentification:(BBIdentification*)identification forSize:(CGSize)size {
    
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
    MGLine *identificationInfo = [MGLine multilineWithText:identificationText font:DESCRIPTOR_FONT width:230 padding:UIEdgeInsetsZero];
    identificationInfo.underlineType = MGUnderlineNone;
    
    MGLine *categoryLine = [MGLine lineWithLeft:categoryIcon right:identificationInfo size:CGSizeMake(320, 100)];
    categoryLine.underlineType = MGUnderlineNone;
    
    return categoryLine;
}

+(MGLine *)createSubHeadingWithTitle:(NSString*)title forSize:(CGSize)size {
    MGLine *titleLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%@:", title] right:nil size:size];
    titleLine.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    UIFont *subHeadingFont = [UIFont italicSystemFontOfSize:12]; //DESCRIPTOR_FONT;
    titleLine.textColor = [UIColor grayColor];
    
    titleLine.font = subHeadingFont;
    titleLine.underlineType = MGUnderlineBottom;
    //titleLine.underlineType = MGUnderlineTop;
    titleLine.backgroundColor = [UIColor whiteColor];
    
    
    return titleLine;
}

// description


// tags

@end