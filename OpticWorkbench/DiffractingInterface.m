//
//  DiffractingInterface.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DiffractingInterface.h"
#import "OpticWorkbenchLayer.h"

@implementation DiffractingInterface

- (id)init {
    self = [super init];
    if (self) {
        _interfaceRatio = 1.000293 / 1.3330; //Air / water
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    //We draw two lines, the darker one where the index is higher
    CGColorRef darkStrokeColor = CGColorCreateGenericRGB(0.0, 0.5, 1.0, 0.7);
    CGColorRef lightStrokeColor = CGColorCreateGenericRGB(0.0, 1.0, 1.0, 0.7);
    
    CGPoint lineOffset = CGPointMake(1 * cos(_angle + M_PI_2), 1 * sin(_angle + M_PI_2));
    
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x + lineOffset.x, startPoint.y - self.frame.origin.y + lineOffset.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x + lineOffset.x, endPoint.y - self.frame.origin.y + lineOffset.y);
    
    if (_interfaceRatio > 1) {
        CGContextSetStrokeColorWithColor(ctx, darkStrokeColor);
    } else {
        CGContextSetStrokeColorWithColor(ctx, lightStrokeColor);
    }
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(ctx);

    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x - lineOffset.x, startPoint.y - self.frame.origin.y - lineOffset.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x - lineOffset.x, endPoint.y - self.frame.origin.y - lineOffset.y);
    
    if (_interfaceRatio < 1) {
        CGContextSetStrokeColorWithColor(ctx, darkStrokeColor);
    } else {
        CGContextSetStrokeColorWithColor(ctx, lightStrokeColor);
    }
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(ctx);

    
    CGColorRelease(darkStrokeColor); 
    CGColorRelease(lightStrokeColor);
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {    
    //We have to decrease the intersection distance by just a bit, so that the point is off the mirror and doesn't immediately intersect with it again
    CGPoint bouncePoint = rayPointAfterDistance(ray, intersectionDistance + 0.0000001);
    
    CGFloat ourAngle = _angle;
    CGFloat interfaceRatio = _interfaceRatio;
    
    BOOL hitBack = sin(ray.angle - _angle) > 0;
    if (hitBack) {
        interfaceRatio = 1 / _interfaceRatio;
        ourAngle += M_PI;
    }
    
        
    CGFloat incomingAngleFromNormal = ray.angle - ourAngle + M_PI_2;
    
    CGFloat outgoingAngleFromNormal = asin( interfaceRatio * sin(incomingAngleFromNormal) );
    
    CGFloat transformedAngle = ourAngle - M_PI_2 + outgoingAngleFromNormal;
    
    
    return [NSArray arrayWithObject:[[ray copyWithPosition:bouncePoint angle:transformedAngle intensity:1.0] autorelease]];
}


@end
