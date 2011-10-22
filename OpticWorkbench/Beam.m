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


- (NSArray *)startingRays {
    NSMutableArray *array = [NSMutableArray array];
    
    CGPoint offset = CGPointMake(cos(_angle - M_PI_2) * 0.0001, sin(_angle - M_PI_2) * 0.0001);
    for (CGFloat distance = 0; distance < _length; distance += 0.02) {
        CGPoint position = CGPointMake(_flatToolOrigin.x + cos(_angle) * distance,
                                       _flatToolOrigin.y + sin(_angle) * distance);
        position.x += offset.x;
        position.y += offset.y;
        
        [array addObject:[OpticRay rayWithPositionPostion:position angle:_angle - M_PI_2]];
    }
    
    return array;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x, startPoint.y - self.frame.origin.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x, endPoint.y - self.frame.origin.y);
    
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetStrokeColorWithColor(ctx, CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0));
    CGContextStrokePath(ctx);
}

@end
