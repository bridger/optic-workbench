//
//  Beam.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beam.h"
#import "OpticWorkbenchLayer.h"

@implementation Beam

@synthesize color = _color;

- (id)init {
    self = [super init];
    if (self) {
        [self randomizeColor];
    }
    return self;
}


- (NSArray *)startingRays {
    NSMutableArray *array = [NSMutableArray array];
        
    CGPoint offset = CGPointMake(cos(_angle - M_PI_2) * 0.0001, sin(_angle - M_PI_2) * 0.0001);
    for (CGFloat distance = 0; distance < _length; distance += 0.008) {
        CGPoint position = CGPointMake(_flatToolOrigin.x + cos(_angle) * distance,
                                       _flatToolOrigin.y + sin(_angle) * distance);
        position.x += offset.x;
        position.y += offset.y;
        
        [array addObject:[OpticRay rayWithPositionPostion:position angle:_angle - M_PI_2 color:_color]];
    }
    
    
    return array;
}

- (void)setColor:(CGColorRef)color {
    CGColorRef temp = _color;
    _color = CGColorRetain(color);
    CGColorRelease(temp);
    [self.workbench opticToolAltered:self];
}

- (void)randomizeColor {
    CGColorRef color = generateRandomColor();
    self.color = color;
    CGColorRelease(color);
}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x, startPoint.y - self.frame.origin.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x, endPoint.y - self.frame.origin.y);
    
    CGContextSetLineWidth(ctx, 5.0);
    CGColorRef strokeColor = CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGColorRelease(strokeColor);
    CGContextStrokePath(ctx);
}

- (id)copyWithZone:(NSZone *)zone {
    Beam *copy = [super copyWithZone:zone];
    copy.color = _color;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    if (self) {
        [self randomizeColor];
    }
    return self;
}


@end
