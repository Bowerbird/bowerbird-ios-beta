//
//  ACMagnifyingGlass.m
//  MagnifyingGlass
//
//  https://github.com/acoomans/iOS-MagnifyingGlass

#import <UIKit/UIKit.h>

@class ACMagnifyingGlass;

@interface ACMagnifyingView : UIView

@property (nonatomic, retain) ACMagnifyingGlass *magnifyingGlass;
@property (nonatomic, assign) CGFloat magnifyingGlassShowDelay;

@end
