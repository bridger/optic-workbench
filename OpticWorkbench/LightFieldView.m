//
//  LightFieldView.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LightFieldView.h"
#import "OpticRay.h"

@implementation LightFieldView

@synthesize capturedRays = _capturedRays;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setCapturedRays:(NSArray *)capturedRays {
    [_capturedRays release];
    _capturedRays = [capturedRays copy];
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
//#define AXIS_SIZE 20
    
    NSGraphicsContext *cocoaContext = [NSGraphicsContext currentContext];
    CGContextRef ctx = (CGContextRef)[cocoaContext graphicsPort];
    NSRect bounds = [self bounds];
    
    NSRect graphRegion = bounds;
//    graphRegion.size.width = graphRegion.size.width - AXIS_SIZE;
//    graphRegion.origin.x = graphRegion.origin.x + AXIS_SIZE;
//    
//    graphRegion.size.height = graphRegion.size.height - AXIS_SIZE;
//    graphRegion.origin.y = graphRegion.origin.y + AXIS_SIZE;
//    
    
    CGColorRef graphColor = CGColorCreateGenericGray(1.0, 1.0);

    
    CGContextBeginPath(ctx);
    CGContextAddRect(ctx, NSInsetRect(graphRegion, 0.5, 0.5));
    
    CGContextSetStrokeColorWithColor(ctx, graphColor);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGFloat dash[2]={3 ,5};
    CGContextSetLineDash(ctx, 0, dash, 2);
    
    CGContextMoveToPoint(ctx, graphRegion.origin.x, graphRegion.origin.y + graphRegion.size.height / 2);
    CGContextAddLineToPoint(ctx, graphRegion.origin.x + graphRegion.size.width, graphRegion.origin.y + graphRegion.size.height / 2);
    
    CGContextMoveToPoint(ctx, graphRegion.origin.x + graphRegion.size.width / 2, graphRegion.origin.y);
    CGContextAddLineToPoint(ctx, graphRegion.origin.x + graphRegion.size.width / 2, graphRegion.origin.y + graphRegion.size.height);
    
    CGContextSetStrokeColorWithColor(ctx, graphColor);
    CGContextStrokePath(ctx);
    
    CGColorRelease(graphColor);
    
    
    for (CapturedOpticRay *ray in _capturedRays) {
        CGPoint point = CGPointMake(graphRegion.size.width * ray.position, 
                                    graphRegion.size.height * (normalizedAngle(ray.angle) / M_PI) );
        
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, point.x + graphRegion.origin.x, point.y + graphRegion.origin.y, 3.0, 0, 2 * M_PI, 0);
        
        CGContextSetFillColorWithColor(ctx, ray.color);
        CGContextFillPath(ctx);
        
        
        
    }
}

@end
