/*
 Copyright 2012, Matt Greenfield
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 https://github.com/sobri909/MGBox
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MGBox;

typedef enum {
    MGUnderlineNone, MGUnderlineTop, MGUnderlineBottom
} UnderlineType;

typedef enum {
    MGSidePrecedenceLeft, MGSidePrecedenceRight
} SidePrecedence;

@interface MGBoxLine : UIView

@property (nonatomic, retain) NSMutableArray *contentsLeft;
@property (nonatomic, retain) NSMutableArray *contentsRight;
@property (nonatomic, assign) UnderlineType underlineType;
@property (nonatomic, assign) SidePrecedence sidePrecedence;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIFont *rightFont;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) MGBox *parentBox;
@property (nonatomic, retain) CALayer *solidUnderline;
@property (nonatomic, assign) CGFloat linePadding;
@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, retain) UIView *leftViews;
@property (nonatomic, retain) UIView *rightViews;
@property (nonatomic, retain) id misc;

+ (id)line;
+ (id)lineWithWidth:(CGFloat)width;
+ (id)lineWithLeft:(NSObject *)left right:(NSObject *)right;
+ (id)lineWithLeft:(NSObject *)left right:(NSObject *)right
             width:(CGFloat)width;
+ (id)multilineWithText:(NSString *)text font:(UIFont *)font
                padding:(CGFloat)padding;
+ (id)multilineWithText:(NSString *)text font:(UIFont *)font
                padding:(CGFloat)padding width:(CGFloat)width;
- (void)layoutContents;

- (UILabel *)makeLabel:(NSString *)text right:(BOOL)right;

@end
