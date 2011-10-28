//
//  OpticRay.h
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpticRay : NSObject {
    CGPoint _position;
    CGFloat _angle;
    CGColorRef _color;
}

- (id)initWithPostion:(CGPoint)position angle:(CGFloat)angle color:(CGColorRef)color;
- (id)copyWithPosition:(CGPoint)position angle:(CGFloat)angle intensity:(CGFloat)intensity;
+ (id)rayWithPositionPostion:(CGPoint)position angle:(CGFloat)angle color:(CGColorRef)color;

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat angle;
@property (nonatomic, readonly) CGColorRef color;

@end

CGPoint rayIntersectionOutsideRect(OpticRay *ray, NSRect rect);
CGPoint rayPointAfterDistance(OpticRay *ray, CGFloat distance);