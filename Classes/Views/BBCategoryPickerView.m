/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCategoryPickerView.h"
#import "BBHelpers.h"
#import "BBCategory.h"
#import "BBUIControlHelper.h"


@implementation BBCategoryPickerView


@synthesize controller = _controller;
@synthesize categoryPicker = _categoryPicker;
@synthesize categories = _categories;


-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBCategoryPickerView.initWithDelegate:"];
    
    self = [super initWithFrame:CGRectMake(0, 0, 280, 250)];
    _controller = delegate;
    _categories = [_controller getCategories];
    
    UIView *categoryPickerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 280, 200)];
    
    _categoryPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    _categoryPicker.delegate = self;
    _categoryPicker.dataSource = self;
    _categoryPicker.showsSelectionIndicator = YES;
    _categoryPicker.userInteractionEnabled = YES;
    [categoryPickerView addSubview:_categoryPicker];
    
    //mask the picker
    CGFloat width = 0;
    if(_categoryPicker.subviews.count > 0)
    {
        UIPickerView *inner = _categoryPicker.subviews[0];
    
        for (int i = 0; i < inner.numberOfComponents; i++) {
            CGSize size = [inner rowSizeForComponent:i];
            width += size.width + 5;
        }
    }
    else width = 280;
    
    float widthOfParent = 300;
    CGFloat left = roundf((widthOfParent - width) / 2);
    CALayer *mask = CALayer.layer;
    mask.backgroundColor = UIColor.blackColor.CGColor;
    mask.frame = CGRectMake(left, 10, width, 196);
    mask.cornerRadius = 6;
    _categoryPicker.layer.mask = mask;
    
    // wrap the picker
    CGRect frame = CGRectMake(0, 0, width, 196);
    UIView *wrap = [[UIView alloc] initWithFrame:frame];
    _categoryPicker.center = (CGPoint){roundf((frame.size.width+(left*2)) / 2), roundf(frame.size.height / 2)};
    
    [wrap addSubview:categoryPickerView];
    CoolMGButton *doneButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, wrap.size.height + 10, wrap.width - 10, 40)
                                                               andTitle:@"Finished"
                                                              withBlock:^{[self doneClicked];}];
    [self addSubview:wrap];
    [self addSubview:doneButton];
    
    return self;
}

-(void)doneClicked {
    [BBLog Log:@"BBDateSelectView.doneClicked"];
    
    if([self.controller respondsToSelector:@selector(categoryStopEdit)]){
        [self.controller categoryStopEdit];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.controller updateCategory:(BBCategory*)[_categories objectAtIndex:row]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _categories.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    BBCategory* selectedCategory = (BBCategory*)[_categories objectAtIndex: row];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [selectedCategory.name lowercaseString]];
    UIImage *photoImage = [UIImage imageNamed:iconPath];
    UIView *photoImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [photoImageView addSubview:[[UIImageView alloc]initWithImage:photoImage]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 50)];
    label.font = HEADER_FONT;
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 180, 50)];
    [labelView addSubview:label];
    label.text = selectedCategory.name;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    labelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UIView *pickerItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
    [pickerItem addSubview:photoImageView];
    [pickerItem addSubview:labelView];
    
    return pickerItem;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60.0f;
}


@end