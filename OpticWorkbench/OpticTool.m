//
//  OpticTool.m
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticTool.h"
#import "OpticRay.h"
#import "OpticWorkbenchLayer.h"

@implementation OpticTool

@synthesize gameFrame = _gameFrame, workbench = _workbench;

- (id)init {
    self = [super init];
    if (self) {
        [self setNeedsDisplayOnBoundsChange:YES];
    }
    return self;
}

- (void)setGamePosition:(CGPoint)gamePosition {
    CGRect newFrame = _gameFrame;
    newFrame.origin = CGPointMake(gamePosition.x - _gameFrame.size.width / 2, gamePosition.y - _gameFrame.size.height / 2);
    self.gameFrame = newFrame;
}

- (CGPoint)gamePosition {
    return CGPointMake(_gameFrame.origin.x + _gameFrame.size.width / 2, _gameFrame.origin.y + _gameFrame.size.height / 2);
}

- (NSArray *)startingRays {
    return nil;
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {
    return nil;
}

- (CGFloat)rayIntersectionDistance:(OpticRay *)ray {
    return CGFLOAT_MAX;
}

- (id)copyWithZone:(NSZone *)zone {
    OpticTool *copy = [[[self class] allocWithZone:zone] init];
    copy.gameFrame = _gameFrame;
    return copy;
}

- (CGFloat)drawingPixelInset {
    return 0.0;
}

- (void)traceDidStart {
}
- (void)traceDidEnd {
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeRect:NSRectFromCGRect(_gameFrame) forKey:@"gameFrame"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    CGRect gameFrame = NSRectToCGRect([decoder decodeRectForKey:@"gameFrame"]);
    
    self = [self init];
    if (self) {
        self.gameFrame = gameFrame;
    }
    return self;
}

@end


@implementation FlatOpticTool

@synthesize flatToolOrigin = _flatToolOrigin, angle = _angle, length = _length;

+ (NSSet *)keyPathsForValuesAffectingGameFrame {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", nil];
}

+ (NSSet *)keyPathsForValuesAffectingGamePosition {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", nil];
}

//TODO: setGameFrame

- (void)setGamePosition:(CGPoint)gamePosition {
    //We need to move the _flatToolOrigin to match
    //_flatToolOrigin.x + cos(_flatToolAngle) * halfSize = gamePosition.x
    //_flatToolOrigin.x = gamePosition.x - cos(_flatToolAngle) * halfSize
    CGFloat halfSize = _length / 2;
    self.flatToolOrigin = CGPointMake(gamePosition.x - cos(_angle) * halfSize,
                                      gamePosition.y - sin(_angle) * halfSize);
}

- (CGPoint)gamePosition {
    CGFloat halfSize = _length / 2;
    return CGPointMake(_flatToolOrigin.x + cos(_angle) * halfSize,
                       _flatToolOrigin.y + sin(_angle) * halfSize);
}

- (CGPoint)startPoint {
    return _flatToolOrigin;
}

- (CGPoint)endPoint {
    return CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                       _flatToolOrigin.y + sin(_angle) * _length);
}

+ (NSSet *)keyPathsForValuesAffectingStartPoint {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", nil];
}

+ (NSSet *)keyPathsForValuesAffectingEndPoint {
    return [NSSet setWithObjects:@"flatToolOrigin", @"angle", @"length", nil];
}

- (CGRect)gameFrame {
    //We need a rect that at least covers the flat tool origin, angle, and size
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    CGRect minFrame = CGRectMake(MIN(endPoint.x, _flatToolOrigin.x), 
                                 MIN(endPoint.y, _flatToolOrigin.y), 
                                 ABS(endPoint.x - _flatToolOrigin.x),
                                 ABS(endPoint.y - _flatToolOrigin.y));
    
    return minFrame;
}

- (CGFloat)drawingPixelInset {
    return -5;
}



- (CGFloat)rayIntersectionDistance:(OpticRay *)ray {
    CGFloat rayDistance = ((ray.position.y - _flatToolOrigin.y) - tan(_angle) * (ray.position.x - _flatToolOrigin.x)) /
    (tan(_angle) * cos(ray.angle) - sin(ray.angle) );
    
    
    //50 is arbitrarily defined... We should fix that later
    if (rayDistance > 0 && rayDistance < 50) {
        
        // We can also use the equation 
        CGFloat mirrorDistance = [self toolIntersectionDistanceForRay:ray rayIntersectionDistance:rayDistance];
        
        if (mirrorDistance > 0 && mirrorDistance < _length) {
            return rayDistance;
        }
    }
    
    return CGFLOAT_MAX;
}

- (CGFloat)toolIntersectionDistanceForRay:(OpticRay *)ray rayIntersectionDistance:(CGFloat)rayDistance {
    //We have two equations for solving this. One divides by cos, the other divides by sin. Choosing the wrong one results in an invalid answer
    
    if (abs(sin(_angle)) > 0.5) {
        return (sin(ray.angle) * rayDistance + ray.position.y - _flatToolOrigin.y) / sin(_angle);
    } else {
        return (cos(ray.angle) * rayDistance + ray.position.x - _flatToolOrigin.x) / cos(_angle);
    }
}

- (id)copyWithZone:(NSZone *)zone {
    FlatOpticTool *copy = [super copyWithZone:zone];
    copy.length = self.length;
    copy.flatToolOrigin = _flatToolOrigin;
    copy.angle = _angle;
    return copy;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:_angle forKey:@"angle"];
    [encoder encodeDouble:_length forKey:@"length"];
    [encoder encodePoint:NSPointFromCGPoint(_flatToolOrigin) forKey:@"flatToolOrigin"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    CGFloat angle = [decoder decodeDoubleForKey:@"angle"];
    CGFloat length = [decoder decodeDoubleForKey:@"length"];
    CGPoint origin = NSPointToCGPoint([decoder decodePointForKey:@"flatToolOrigin"]);
    
    self = [self init];
    if (self) {
        self.angle = angle;
        self.length = length;
        self.flatToolOrigin = origin;
    }
    return self;
}


@end
