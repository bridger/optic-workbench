//
//  ParabolicMirror.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ParabolicMirror.h"
#import "OpticWorkbenchLayer.h"

@implementation ParabolicMirror

@synthesize focalLength = _focalLength, angle = _angle, length = _length;

- (id)init {
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.0);
        [self setNeedsDisplay];
        [self setNeedsDisplayOnBoundsChange:YES];
    }
    return self;
}

+ (NSSet *)keyPathsForValuesAffectingGameFrame {
    return [NSSet setWithObjects:@"gamePosition", @"length", @"focalLength", nil];
}

- (CGRect)gameFrame {
    CGFloat maxX = sqrt(4 * _focalLength * _length);
    
    return CGRectMake(_gamePosition.x - maxX, _gamePosition.y, maxX * 2, _length);
}

- (void)setGamePosition:(CGPoint)gamePosition {
    _gamePosition = gamePosition;
}

- (CGPoint)gamePosition {
    return _gamePosition;
}

+ (NSSet *)keyPathsForValuesAffectingLeftFocalPoint {
    return [NSSet setWithObjects:@"gamePosition", @"focalLength", @"angle", nil];
}

+ (NSSet *)keyPathsForValuesAffectingRightFocalPoint {
    return [NSSet setWithObjects:@"gamePosition", @"focalLength", @"angle", nil];
}

- (CGPoint)leftFocalPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle + M_PI_2) * _focalLength, 
                       centerPoint.y + sin(_angle + M_PI_2) * _focalLength);
}

- (CGPoint)rightFocalPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle - M_PI_2) * _focalLength, 
                       centerPoint.y + sin(_angle - M_PI_2) * _focalLength);
}

+ (NSSet *)keyPathsForValuesAffectingStartPoint {
    return [NSSet setWithObjects:@"gameFrame", @"focalLength", @"angle", nil];
}

+ (NSSet *)keyPathsForValuesAffectingEndPoint {
    return [NSSet setWithObjects:@"gameFrame", @"focalLength", @"angle", nil];
}

- (CGPoint)startPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle + M_PI_2) * _length, 
                       centerPoint.y + sin(_angle + M_PI_2) * _length);
}

- (CGPoint)endPoint {
    CGPoint centerPoint = [self gamePosition];
    return CGPointMake(centerPoint.x + cos(_angle - M_PI_2) * _length, 
                       centerPoint.y + sin(_angle - M_PI_2) * _length);
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setValue:[NSNumber numberWithDouble:angle] forKeyPath:@"transform.rotation"];
    [self.workbench opticToolAltered:self];
}

- (void)setFocalLength:(CGFloat)focalLength {
    _focalLength = focalLength;
    [self.workbench opticToolAltered:self];
}

- (void)setLength:(CGFloat)length {
    _length = length / 2;
}

- (CGFloat)length {
    return _length * 2;
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {
    //This assumes that the center of the parabola is at 0,0 and the angle is 0. To accomodate this, we translate the ray parameters    
    CGFloat rayAngle = ray.angle - _angle;
    CGPoint translation = self.gamePosition;
    CGPoint intersection = CGPointMake(point.x - translation.x,
                                       point.y - translation.y);
    
    intersection = CGPointMake(cos(-_angle) * intersection.x - sin(-_angle) * intersection.y,
                               cos(-_angle) * intersection.y + sin(-_angle) * intersection.x);
        
    CGFloat tangentAngle = atan(2 * intersection.x / (4 * _focalLength));
    
    CGFloat transformedAngle = 2 * tangentAngle - rayAngle;
    transformedAngle += _angle;
    
    //We move the point by BUFFER_DISTANCE away after it has bounced, so it can get clear of the mirror
#define BUFFER_DISTANCE 0.0000001
    CGPoint bouncePoint = CGPointMake(point.x + cos(transformedAngle) * BUFFER_DISTANCE, point.y + sin(transformedAngle) * BUFFER_DISTANCE);
        
    return [NSArray arrayWithObject:[[ray copyWithPosition:bouncePoint angle:transformedAngle intensity:1.0] autorelease]];
}

- (CGFloat)rayIntersectionDistance:(OpticRay *)ray {
    //The equation for the x-intersection is 2(am +- sqrt(a (am^2 - mx' + y')) )
    //Where a = _focalLength, m = tan(ray.angle), x' = ray.origin.x, y' = ray.origin.y
    //This assumes that the center of the parabola is at 0,0 and the angle is 0. To accomodate this, we translate the ray parameters
    
    CGFloat maxX = sqrt(4 * _focalLength * _length);
    CGFloat distance = CGFLOAT_MAX;
    
    CGFloat rayAngle = ray.angle - _angle;
    CGPoint translation = self.gamePosition;
    CGPoint rayOrigin = CGPointMake(ray.position.x - translation.x,
                                    ray.position.y - translation.y);
            
    rayOrigin = CGPointMake(cos(-_angle) * rayOrigin.x - sin(-_angle) * rayOrigin.y,
                            cos(-_angle) * rayOrigin.y + sin(-_angle) * rayOrigin.x);
    
    //rayAngle = atan2(rayEnd.y - rayOrigin.y, rayEnd.x - rayOrigin.x);
    
    if (fabs(cos(rayAngle)) > 0.0001) {
        CGFloat raySlope = tan(rayAngle);

        
        CGFloat determinant = sqrt(_focalLength * (_focalLength * raySlope * raySlope - raySlope * rayOrigin.x + rayOrigin.y));
                
        CGFloat x1 = 2 * (_focalLength * raySlope + determinant);
        CGFloat x2 = 2 * (_focalLength * raySlope - determinant);
        
        CGFloat distance1 = (x1 - rayOrigin.x) / cos(rayAngle);
        CGFloat distance2 = (x2 - rayOrigin.x) / cos(rayAngle);
        if (distance1 > 0 && fabs(x1) < maxX) {
            distance = MIN(distance, distance1);
        }
        if (distance2 > 0 && fabs(x2) < maxX) {
            distance = MIN(distance, distance2);
        }
    } else {
        //This line is vertical, so there aren't two x-intercepts. It is actually much easier to solve, so this is okay
        if (fabs(rayOrigin.x) < maxX) {
            CGFloat y = rayOrigin.x * rayOrigin.x / (4 * _focalLength);
            CGFloat distance1 = (y - rayOrigin.y) / sin(rayAngle);
            
            if (distance1 > 0) {
                distance = MIN(distance, distance1);
            }
        }
    }
    
    
    return distance;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat scalar = self.bounds.size.height / _length;
    CGFloat intermediate = 1 / (4 * _focalLength);
    CGFloat canvasWidth = self.bounds.size.width;
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height -3);
    for (CGFloat x = 0; x <= canvasWidth; x += 1) {
        CGFloat translatedX = x - canvasWidth / 2;
        CGFloat y = intermediate * translatedX * translatedX / scalar + 3;
        
        CGContextAddLineToPoint(ctx, x, y);
    }
    
    CGContextSetLineWidth(ctx, 5.0);
    CGColorRef strokeColor = CGColorCreateGenericGray(0.5, 1.0);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGColorRelease(strokeColor);
    CGContextStrokePath(ctx);
}

- (CGFloat)drawingPixelInset {
    return -3;
}

- (id)copyWithZone:(NSZone *)zone {
    ParabolicMirror *copy = [super copyWithZone:zone];
    copy.focalLength = _focalLength;
    copy.length = self.length;
    copy.angle = _angle;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeDouble:_focalLength forKey:@"focalLength"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    CGFloat focalLength = [decoder decodeDoubleForKey:@"focalLength"];
    
    self = [super initWithCoder:decoder];
    if (self) {
        self.focalLength = focalLength;
    }
    return self;
}


@end
