//
//  BeamSplitter.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeamSplitter.h"
#import "OpticWorkbenchLayer.h"

@implementation BeamSplitter

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x, startPoint.y - self.frame.origin.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x, endPoint.y - self.frame.origin.y);
    
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetStrokeColorWithColor(ctx, CGColorCreateGenericGray(0.5, 0.5));
    CGContextStrokePath(ctx);
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {    
    //We have to decrease the intersection distance by just a bit, so that the point is off the mirror and doesn't immediately intersect with it again
    CGPoint bouncePointFront = rayPointAfterDistance(ray, intersectionDistance - 0.0000001);
    CGPoint bouncePointBehind = rayPointAfterDistance(ray, intersectionDistance + 0.0000001);
    
    CGFloat transformedAngle = 2 * _angle - ray.angle;
    
    return [NSArray arrayWithObjects:[OpticRay rayWithPositionPostion:bouncePointFront angle:transformedAngle],
            [OpticRay rayWithPositionPostion:bouncePointBehind angle:ray.angle], nil];
}

@end
