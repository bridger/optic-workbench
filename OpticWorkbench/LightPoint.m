//
//  LightPoint.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LightPoint.h"
#import "OpticRay.h"
#import "OpticWorkbenchLayer.h"

@implementation LightPoint

@synthesize angle = _angle, color = _color;

- (id)init {
    self = [super init];
    if (self) {
        [self randomizeColor];
    }
    return self;
}

- (NSArray *)startingRays {
    NSMutableArray *array = [NSMutableArray array];
    CGPoint startPoint = self.gamePosition;
        
    for (CGFloat currentAngle = 0; currentAngle < 2 * M_PI; currentAngle += M_PI/64 + 0.00001) {
        [array addObject:[OpticRay rayWithPositionPostion:startPoint angle:currentAngle + _angle  color:_color]];
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

- (id)copyWithZone:(NSZone *)zone {
    LightPoint *copy = [super copyWithZone:zone];
    copy.angle = _angle;
    copy.color = _color;
    return copy;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
    radius = radius / 2;
    
    CGContextAddArc(ctx, self.bounds.size.width / 2 + self.bounds.origin.x,
                    self.bounds.size.height / 2 + self.bounds.origin.y, 
                    radius - 1.0, 0, M_PI * 2, 1);
    
    CGColorRef fillColor = CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0);
    CGContextSetFillColorWithColor(ctx, fillColor);
    CGColorRelease(fillColor);
    
    CGContextFillPath(ctx);
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeDouble:_angle forKey:@"angle"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    CGFloat angle = [decoder decodeDoubleForKey:@"angle"];
    
    self = [super initWithCoder:decoder];
    if (self) {
        [self randomizeColor];
        self.angle = angle;
    }
    return self;
}


@end
