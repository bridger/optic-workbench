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
    CGColorRef strokeColor = CGColorCreateGenericRGB(0.0, 0.0, 1.0, 0.5);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGColorRelease(strokeColor); 
    CGContextStrokePath(ctx);
}

+ (NSSet *)keyPathsForValuesAffectingLeftFocalPoint {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", @"focalLength", nil];
}

+ (NSSet *)keyPathsForValuesAffectingRightFocalPoint {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", @"focalLength", nil];
}

- (void)setFocalLength:(CGFloat)focalLength {
    _focalLength = focalLength;
    [self.workbench opticToolAltered:self];
}

- (CGPoint)leftFocalPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle + M_PI_2) * _focalLength, centerPoint.y + sin(_angle + M_PI_2) * _focalLength);
}

- (CGPoint)rightFocalPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle - M_PI_2) * _focalLength, centerPoint.y - sin(_angle + M_PI_2) * _focalLength);
}


- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {    
    //We have to increase the intersection distance by just a bit, so that the point is beyond the lens and doesn't immediately intersect with it again
    CGPoint bouncePoint = rayPointAfterDistance(ray, intersectionDistance + 0.0000001);
    
    CGFloat distanceFromCenter = [self toolIntersectionDistanceForRay:ray rayIntersectionDistance:intersectionDistance] - _length / 2;
    
    //We need to make adjustments if the ray hits the back of the lens
    CGFloat normal = (_angle - M_PI_2);
    if (cos(ray.angle - normal) < 0) {
        normal = (_angle + M_PI_2);
        distanceFromCenter *= -1;
    }
    
    //Find the angle with respect to the normal
    CGFloat theta = ray.angle - normal;
    
    //Compute the new angle
    CGFloat transformedAngle = atan((_focalLength * tan(theta) - distanceFromCenter) / _focalLength);
    
    //Restore the angle so it isn't with respect to the normal
    transformedAngle += normal;
    
    return [NSArray arrayWithObject:[[ray copyWithPosition:bouncePoint angle:transformedAngle intensity:1.0] autorelease]];
}

- (id)copyWithZone:(NSZone *)zone {
    Lens *copy = [super copyWithZone:zone];
    copy.focalLength = _focalLength;
    return copy;
}

@end
