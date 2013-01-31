/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au

 NOTE:
 https://github.com/enormego/ABTableViewCell/blob/master/ABTableViewCell.m
 
 -----------------------------------------------------------------------------------------------*/


#import "BBTableViewCell.h"

@interface BBTableViewCellView : UIView
@end

@interface BBTableViewSelectedCellView : UIView
@end

@implementation BBTableViewCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
    
	return self;
}

- (void)drawRect:(CGRect)rect {
	[(BBTableViewCell *)[self superview] drawContentView:rect highlighted:NO];
}

@end


@implementation BBTableViewSelectedCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
    
    
    
	return self;
}

- (void)drawRect:(CGRect)rect {
	[(BBTableViewCell *)[self superview] drawContentView:rect highlighted:NO];
}

@end

@implementation BBTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //contentView = [[BBTableViewCellView alloc] initWithFrame:CGRectZero];
        //contentView.opaque = YES;
        //contentView.backgroundColor = [UIColor blackColor];
        //[self addSubview:contentView];
    }
    return self;
}

- (void)setFrame:(CGRect)f
{
    [super setFrame:f];
    CGRect b = [self bounds];
    b.size.height -= 1; // leave room for the seperator line
    [contentView setFrame:b];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r highlighted:(BOOL)highlighted
{
    // subclasses should implement this
}

@end