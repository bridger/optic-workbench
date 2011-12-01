//
//  Obstacle.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Sensor.h"
#import "OpticWorkbenchLayer.h"

@interface Sensor ()

@property (nonatomic, copy, readwrite) NSArray *capturedRays;

@end



@implementation Sensor

@synthesize capturedRays = _capturedRays;

- (id)init {
    self = [super init];
    if (self) {
        _currentRays = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint endPoint = CGPointMake(_flatToolOrigin.x + cos(_angle) * _length,
                                   _flatToolOrigin.y + sin(_angle) * _length);
    
    endPoint = [self.workbench gameToPixelTransformPoint:endPoint];
    CGPoint startPoint = [self.workbench gameToPixelTransformPoint:_flatToolOrigin];
    
    //The white sensor line is drawn on the axis where the intersection is recorded, so the back black line should be moved back a bit
    //Now draw the white border that is the sensor side
    CGPoint sensorOffset = CGPointMake(-3 * cos(_angle + M_PI_2), -3 * sin(_angle + M_PI_2));
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x + sensorOffset.x, startPoint.y - self.frame.origin.y + sensorOffset.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x + sensorOffset.x, endPoint.y - self.frame.origin.y + sensorOffset.y);
    
    CGContextSetLineWidth(ctx, 5.0);
    CGColorRef strokeColor = CGColorCreateGenericGray(0.0, 1.0);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGColorRelease(strokeColor);     
    CGContextStrokePath(ctx);

    
    sensorOffset = CGPointMake(-1 * cos(_angle + M_PI_2), -1 * sin(_angle + M_PI_2));
    
    CGContextMoveToPoint(ctx, startPoint.x - self.frame.origin.x + sensorOffset.x, startPoint.y - self.frame.origin.y + sensorOffset.y);
    CGContextAddLineToPoint(ctx, endPoint.x - self.frame.origin.x + sensorOffset.x, endPoint.y - self.frame.origin.y + sensorOffset.y);
    
    CGContextSetLineWidth(ctx, 2.0);
    strokeColor = CGColorCreateGenericGray(0.8, 1.0);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGColorRelease(strokeColor);     
    CGContextStrokePath(ctx);
}

- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance {
    
    CGFloat angle = normalizedAngle(ray.angle - self.angle);
    
    if (angle < 0) { //If it hit the top of the sensor
        CGFloat distance = sqrt( pow(point.x - self.flatToolOrigin.x, 2) + pow(point.y - self.flatToolOrigin.y, 2) );
        
        CapturedOpticRay *capturedRay = [[CapturedOpticRay alloc] initWithPostion:distance/self.length angle:ray.angle - self.angle color:ray.color];
        
        [_currentRays addObject:capturedRay];
        
        [capturedRay release];
    }
    
    return nil;
}

- (void)traceDidStart {
    [_currentRays removeAllObjects];
}

- (void)traceDidEnd {
    self.capturedRays = _currentRays;
}

@end
