//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import "CoolMGButton.h"
#import "MGLayoutManager.h"

@implementation CoolMGButton {
  BOOL fixedPositionEstablished;
  BOOL asyncDrawing, asyncDrawOnceing;
}

// MGLayoutBox protocol
@synthesize boxes, parentBox, boxLayoutMode, contentLayoutMode;
@synthesize asyncLayout, asyncLayoutOnce, asyncQueue;
@synthesize margin, topMargin, bottomMargin, leftMargin, rightMargin;
@synthesize padding, topPadding, rightPadding, bottomPadding, leftPadding;
@synthesize attachedTo, replacementFor, sizingMode;
@synthesize fixedPosition, zIndex, layingOut;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  [self setup];
  return self;
}

- (void)setup { }

- (void)layout {
  [MGLayoutManager layoutBoxesIn:self];

  // async draws
  if (self.asyncLayout || self.asyncLayoutOnce) {
    dispatch_async(self.asyncQueue, ^{
      if (self.asyncLayout && !asyncDrawing) {
        asyncDrawing = YES;
        self.asyncLayout();
        asyncDrawing = NO;
      }
      if (self.asyncLayoutOnce && !asyncDrawOnceing) {
        asyncDrawOnceing = YES;
        self.asyncLayoutOnce();
        self.asyncLayoutOnce = nil;
        asyncDrawOnceing = NO;
      }
    });
  }
}

#pragma mark - Interaction

- (void)onControlEvent:(UIControlEvents)controlEvent do:(Block)handler {

  // get all handlers for this control event
  NSMutableArray *handlers = self.eventHandlers[@((int)controlEvent)];
  if (!handlers) {
    handlers = @[].mutableCopy;
    self.eventHandlers[@((int)controlEvent)] = handlers;
  }

  // add the handler
  MGBlockWrapper *wrapper = [MGBlockWrapper wrapperForBlock:handler];
  [self addTarget:wrapper action:@selector(doit) forControlEvents:controlEvent];
  [handlers addObject:wrapper];
}

#pragma mark - Getters

- (NSMutableOrderedSet *)boxes {
  if (!boxes) {
    boxes = NSMutableOrderedSet.orderedSet;
  }
  return boxes;
}

- (UIEdgeInsets)margin {
  return UIEdgeInsetsMake(self.topMargin, self.leftMargin, self.bottomMargin,
      self.rightMargin);
}

- (UIEdgeInsets)padding {
  return UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding,
      self.rightPadding);
}

- (CGPoint)fixedPosition {
  if (!fixedPositionEstablished) {
    fixedPosition = self.frame.origin;
    fixedPositionEstablished = YES;
  }
  return fixedPosition;
}

- (dispatch_queue_t)asyncQueue {
  if (!asyncQueue) {
    asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  }
  return asyncQueue;
}

- (NSMutableDictionary *)eventHandlers {
  if (!_eventHandlers) {
    _eventHandlers = @{ }.mutableCopy;
  }
  return _eventHandlers;
}

#pragma mark - Setters

- (void)setMargin:(UIEdgeInsets)_margin {
  self.topMargin = _margin.top;
  self.rightMargin = _margin.right;
  self.bottomMargin = _margin.bottom;
  self.leftMargin = _margin.left;
}

- (void)setPadding:(UIEdgeInsets)_padding {
  self.topPadding = _padding.top;
  self.rightPadding = _padding.right;
  self.bottomPadding = _padding.bottom;
  self.leftPadding = _padding.left;
}

- (void)setFixedPosition:(CGPoint)pos {
  self.boxLayoutMode = MGBoxLayoutFixedPosition;
  fixedPositionEstablished = YES;
  fixedPosition = pos;
}

- (void)setAttachedTo:(id)buddy {
  self.boxLayoutMode = MGBoxLayoutAttached;
  attachedTo = buddy;
}

@end
