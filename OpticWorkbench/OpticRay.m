//
//  OpticRay.m
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticRay.h"


CGPoint rayIntersectionOutsideRect(OpticRay *ray, NSRect rect) {
    if (CGRectContainsPoint(rect, ray.position)) {
        
        CGFloat xIntersection;
        CGFloat cosAngle = cos(ray.angle);
        if (cosAngle > 0) {
            //It will intersect on the right size
            xIntersection = (rect.origin.x + rect.size.width - ray.position.x) / cosAngle;
        } else if (cosAngle < 0) {
            //It will intersect on the left size
            xIntersection = (rect.origin.x - ray.position.x) / cosAngle;
        } else {
            //It will not intersect on the left or right
            xIntersection = CGFLOAT_MAX;
        }
        
        
        CGFloat yIntersection;
        CGFloat sinAngle = sin(ray.angle);
        if (sinAngle > 0) {
            //It will intersect on the top size
            yIntersection = (rect.origin.y + rect.size.width - ray.position.y) / sinAngle;
        } else if (sinAngle < 0) {
            //It will intersect on the bottom size
            yIntersection = (rect.origin.y - ray.position.y) / sinAngle;
        } else {
            //It will not intersect on the top or bottom
            yIntersection = CGFLOAT_MAX;
        }
        
        
        CGFloat minIntersectionDistance = MIN(xIntersection, yIntersection);
        
        return CGPointMake(ray.position.x + cos(ray.angle) * minIntersectionDistance, ray.position.y + sin(ray.angle) * minIntersectionDistance);
    } else {
        return ray.position;
    }
}

CGPoint rayPointAfterDistance(OpticRay *ray, CGFloat distance) {
    return CGPointMake(ray.position.x + cos(ray.angle) * distance, ray.position.y + sin(ray.angle) * distance);
}


@implementation OpticRay

@synthesize position = _position, angle = _angle;

- (id)initWithPostion:(CGPoint)position angle:(CGFloat)angle {
    self = [super init];
    if (self) {
        _position = position;
        _angle = angle;
    }
    return self;
}

+ (id)rayWithPositionPostion:(CGPoint)position angle:(CGFloat)angle {
    return [[[OpticRay alloc] initWithPostion:position angle:angle] autorelease];
}

@end
