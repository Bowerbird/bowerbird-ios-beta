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

#import "MGStyledBox.h"

#define DEFAULT_WIDTH          304.0
#define DEFAULT_TOP_MARGIN      10.0
#define DEFAULT_LEFT_MARGIN      8.0
#define CORNER_RADIUS            4.0

@implementation MGStyledBox

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.topMargin = DEFAULT_TOP_MARGIN;
        self.bottomMargin = 0;
    }
    return self;
}

+ (id)box {
    CGRect frame = CGRectMake(DEFAULT_LEFT_MARGIN, 0, DEFAULT_WIDTH, 0);
    MGStyledBox *box = [[self alloc] initWithFrame:frame];
    return box;
}

+ (id)boxWithWidth:(CGFloat)width {
    CGRect frame = CGRectMake(DEFAULT_LEFT_MARGIN, 0, width, 0);
    MGStyledBox *box = [[self alloc] initWithFrame:frame];
    return box;
}

- (void)addLayers {
    [super addLayers];
    self.backgroundColor =
            [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowRadius = 0.7;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)draw {
    [super draw];

    // make shadow faster
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
            cornerRadius:self.layer.cornerRadius].CGPath;
}

@end
