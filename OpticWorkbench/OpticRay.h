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
}

- (id)initWithPostion:(CGPoint)position angle:(CGFloat)angle;
+ (id)rayWithPositionPostion:(CGPoint)position angle:(CGFloat)angle;

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat angle;

@end

CGPoint rayIntersectionOutsideRect(OpticRay *ray, NSRect rect);
CGPoint rayPointAfterDistance(OpticRay *ray, CGFloat distance);