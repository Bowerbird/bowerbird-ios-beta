//
//  BBStreamView.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBStreamView.h"

@interface BBStreamView()

@property (nonatomic,strong) id<BBStreamProtocol> controller;
@property double top, bottom, height;
@property (nonatomic,strong) NSMutableSet *renderedItems;
@property (nonatomic,strong) NSMutableArray *streamItems;

@end

@implementation BBStreamView

@synthesize controller = _controller;
@synthesize top, bottom, height;
@synthesize renderedItems = _renderedItems;
@synthesize streamItems = _streamItems;

-(BBStreamView*)initWithDelegate:(id<BBStreamProtocol>)delegate andSize:(CGSize)size{
    self = [super init];

    self.size = size;
    
    _controller = delegate;
    
    //self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

// it's always MGBox items in a view so this implementation will stick to that premise
-(BOOL)renderStreamItem:(MGBox*)boxItem
            inDirection:(BOOL)scrollingDownward
              forItemId:(NSString*)itemId {
    
    // if scrollingDownward, add items to the bottom of the streamItems array, and the renderedItems set.
    // then add the box to the scroller and return the padded out second page down worth of view content
    // so we have views at the ready
    
    if(scrollingDownward)// we're going down the page back through time.
    {
        if(![_streamItems containsObject:itemId]) {
            // add this item to our list of items being viewed
            [_streamItems addObject:itemId];
        }
    
        if(![_renderedItems containsObject:boxItem])
        {
            [_renderedItems addObject:boxItem];
            
            // this will change when the items get thrown off the view... this will need to be outside the loop
            [self.boxes addObject:boxItem];
            [self layout];
        }
    }
    else // we're going up the page to the present
    {
        if(![_streamItems containsObject:itemId]) {
            // add this item to the start of our list of items being viewed
            [_streamItems insertObject:itemId atIndex:0];
        }
        
        if(![_renderedItems containsObject:itemId]){
            NSSet *newItems = [[NSSet alloc]initWithObjects:itemId, nil];
            NSSet *evenNewerItems = [newItems setByAddingObjectsFromSet:_renderedItems];
            _renderedItems = [[NSMutableSet alloc]initWithSet:evenNewerItems];
            [self.boxes insertObject:boxItem atIndex:0];
            [self layout];
        }
    }
    
    double viewHeight = self.size.height;
    double offset = self.contentOffset.y;
    double contentHeight = self.contentSize.height;
    offset = offset < 0 ? offset * -1 : offset;// assert offset is positive
    /*
    for (MGBox* box in self.boxes) {        
        if(box.y > viewHeight * 2) {
            // we are way off the viewing window:
            [_renderedItems removeObject:box];
            [box removeFromSuperview];
            [self layout];
        }
    }
    */
    return scrollingDownward ? contentHeight <= viewHeight : offset > viewHeight;
}


-(NSString*)itemAtStreamBottom {
    return [_streamItems lastObject];
}

-(NSString*)itemAtStreamTop {
    return [_streamItems objectAtIndex:0];
}


@end