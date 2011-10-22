//
//  OpticWorkbenchView.m
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticWorkbenchView.h"
#import "OpticWorkbenchLayer.h"
#import "LightPoint.h"
#import "Mirror.h"
#import "Lens.h"
#import "ToolEditor.h"

@implementation OpticWorkbenchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    _layer = [[OpticWorkbenchLayer alloc] init];
    [self setLayer:_layer];
    [self setWantsLayer:YES];
    [_layer setBackgroundColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)];
    
    [self becomeFirstResponder];
    
    //Preserve the correct aspect ratio
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self 
                                                                  attribute:NSLayoutAttributeWidth 
                                                                  relatedBy:NSLayoutRelationEqual 
                                                                     toItem:self 
                                                                  attribute:NSLayoutAttributeHeight 
                                                                 multiplier:1.0 
                                                                   constant:0.0];
    [self addConstraint:constraint];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (CGPoint)convertWindowPointToWorkbench:(NSPoint)windowPoint {
    NSPoint pointInView = [self convertPoint:windowPoint fromView:nil];
    
    return NSPointToCGPoint([self convertPointToBase:pointInView]);
}

- (void)mouseDown:(NSEvent *)theEvent {
    [_layer.toolEditor mouseDownAtWorkbenchPoint:[self convertWindowPointToWorkbench:[theEvent locationInWindow]]];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    [_layer.toolEditor mouseDraggedAtWorkbenchPoint:[self convertWindowPointToWorkbench:[theEvent locationInWindow]]];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [_layer.toolEditor mouseUpAtWorkbenchPoint:[self convertWindowPointToWorkbench:[theEvent locationInWindow]]];
}

- (void)keyDown:(NSEvent *)theEvent {
    //[_layer.toolEditor keyUp:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent {
    [_layer.toolEditor keyUp:theEvent];
}

@end
