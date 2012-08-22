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

#import "MGBox.h"
#import "MGBoxLine.h"

#define DEFAULT_WIDTH     304.0
#define DEFAULT_LEFT_MARGIN 8.0

@interface MGBox ()
- (void)drawLine:(UIView *)line fromLines:(NSArray *)lines at:(CGFloat)y;
@end

@implementation MGBox

@synthesize topLines, middleLines, bottomLines, content, isReplacement;
@synthesize topMargin, bottomMargin, width, misc;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topLines = [NSMutableArray array];
        self.middleLines = [NSMutableArray array];
        self.bottomLines = [NSMutableArray array];
        self.width = frame.size.width;
    }
    return self;
}

+ (id)box {
    CGRect frame = CGRectMake(DEFAULT_LEFT_MARGIN, 0, DEFAULT_WIDTH, 0);
    MGBox *box = [[self alloc] initWithFrame:frame];
    [box addLayers];
    return box;
}

- (void)draw {

    // collapse the lines
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObjectsFromArray:self.topLines];
    [lines addObjectsFromArray:self.middleLines];
    [lines addObjectsFromArray:self.bottomLines];

    // remove removed lines
    for (UIView *view in self.content.subviews) {
        if (view.tag != 1000 && [lines indexOfObject:view] == NSNotFound) {
            [view removeFromSuperview];
        }
    }

    // draw the remaining lines
    CGFloat y = 0;
    for (UIView *line in lines) {
        [self drawLine:line fromLines:lines at:y];
        y += line.frame.size.height;
    }

    // resize to fit
    UIView *superview = self.content.superview;
    CGPoint origin = superview.frame.origin;
    superview.frame = CGRectMake(origin.x, origin.y, self.width, y);
    self.content.frame = superview.bounds;
}

- (void)drawLine:(UIView *)line fromLines:(NSArray *)lines at:(CGFloat)y {
    if ([line isKindOfClass:[MGBoxLine class]]) {
        MGBoxLine *pline = (MGBoxLine *)line;
        pline.parentBox = self;
        [pline layoutContents];
        if (pline == [lines lastObject] && pline.underlineType
            != MGUnderlineTop) {
            pline.underlineType = MGUnderlineNone;
        }
    }
    CGFloat x = 0;
    CGSize lineSize = line.frame.size;
    if (lineSize.width != self.width) {
        x = (self.width - lineSize.width) / 2;
    }
    line.frame = CGRectMake(roundf(x), y, lineSize.width, lineSize.height);
    [self.content addSubview:line];
}

- (void)addLayers {
    if (!self.content) {
        self.content = [[UIView alloc] initWithFrame:self.bounds];
        self.content.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.content.layer.masksToBounds = YES;
    }
    [self.content removeFromSuperview];
    [self addSubview:self.content];
}

- (UIImage *)screenshot:(float)scale {
    CGSize size = self.frame.size;

    // box
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
            cornerRadius:self.layer.cornerRadius] addClip];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIGraphicsEndImageContext();

    // box with shadow
    CGRect frame = CGRectMake(0, 0, size.width + 40, size.height + 40);
    CGFloat cx = roundf(frame.size.width / 2),
            cy = roundf(frame.size.height / 2);
    cy = (int)size.height % 2 ? cy + 0.5 : cy; // avoid blur
    imageView.center = CGPointMake(cx, cy);
    imageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    imageView.layer.borderColor =
            [UIColor colorWithWhite:0.65 alpha:0.7].CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = self.layer.cornerRadius;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset = CGSizeZero;
    imageView.layer.shadowOpacity = 0.2;
    imageView.layer.shadowRadius = 10;

    // final
    UIView *canvas = [[UIView alloc] initWithFrame:frame];
    [canvas addSubview:imageView];
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, scale);
    [canvas.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return final;
}

- (void)setWidth:(CGFloat)_width {
    width = _width;
    [self addLayers];
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    [self setNeedsDisplay];
}

@end
