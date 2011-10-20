//
//  LightPoint.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LightPoint.h"
#import "OpticRay.h"

@implementation LightPoint

@synthesize angle = _angle;

- (NSArray *)startingRays {
    NSMutableArray *array = [NSMutableArray array];
    CGPoint startPoint = self.gamePosition;
    
    for (CGFloat currentAngle = 0; currentAngle < 2 * M_PI; currentAngle += M_PI/32) {
        [array addObject:[OpticRay rayWithPositionPostion:startPoint angle:currentAngle + _angle]];
    }
    
    return array;
}

- (id)copyWithZone:(NSZone *)zone {
    LightPoint *copy = [super copyWithZone:zone];
    copy.angle = _angle;
    return copy;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
    radius = radius / 2;
    
    CGContextAddArc(ctx, self.bounds.size.width / 2 + self.bounds.origin.x,
                    self.bounds.size.height / 2 + self.bounds.origin.y, 
                    radius - 1.0, 0, M_PI * 2, 1);
    
    CGContextSetFillColorWithColor(ctx, CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0));
    
    CGContextFillPath(ctx);
}

@end
