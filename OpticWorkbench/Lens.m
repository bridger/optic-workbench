//
//  Lens.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Lens.h"
#import "OpticWorkbenchLayer.h"

@implementation Lens

@synthesize focalLength = _focalLength;

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x, startPoint.y - self.frame.origin.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x, endPoint.y - self.frame.origin.y);
    
    CGContextSetLineWidth(ctx, 7.0);
    CGContextSetStrokeColorWithColor(ctx, CGColorCreateGenericRGB(0.0, 0.0, 1.0, 0.5));
    CGContextStrokePath(ctx);
}


- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {    
    //We have to increase the intersection distance by just a bit, so that the point is beyond the lens and doesn't immediately intersect with it again
    CGPoint bouncePoint = rayPointAfterDistance(ray, intersectionDistance + 0.0000001);
    
    CGFloat distanceFromCenter = [self toolIntersectionDistanceForRay:ray rayIntersectionDistance:intersectionDistance] - _length / 2;
    
    CGFloat transformedAngle = ray.angle - distanceFromCenter / _focalLength;
    
    return [NSArray arrayWithObject:[OpticRay rayWithPositionPostion:bouncePoint angle:transformedAngle]];
}

- (id)copyWithZone:(NSZone *)zone {
    Lens *copy = [super copyWithZone:zone];
    copy.focalLength = _focalLength;
    return copy;
}

@end
