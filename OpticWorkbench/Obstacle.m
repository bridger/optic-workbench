//
//  Obstacle.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"
#import "OpticWorkbenchLayer.h"

@implementation Obstacle

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x, startPoint.y - self.frame.origin.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x, endPoint.y - self.frame.origin.y);
    
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetStrokeColorWithColor(ctx, CGColorCreateGenericGray(0.0, 1.0));
    CGContextStrokePath(ctx);
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {    
    return nil;
}

@end
