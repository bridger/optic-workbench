//
//  OpticTool.h
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OpticRay.h"

@class OpticWorkbenchLayer;
@interface OpticTool : CALayer <NSCopying> {
    CGRect _gameFrame;
    __weak OpticWorkbenchLayer *_workbench;
}

@property (nonatomic) CGRect gameFrame;
@property (nonatomic) CGPoint gamePosition;
@property (nonatomic, assign) __weak OpticWorkbenchLayer *workbench;

- (NSArray *)startingRays;

- (CGFloat)rayIntersectionDistance:(OpticRay *)ray;
- (NSArray *)transformRay:(OpticRay *)ray atPoint:(CGPoint)point afterDistance:(CGFloat)intersectionDistance;

- (id)copyWithZone:(NSZone *)zone;

- (CGFloat)drawingPixelInset; //A buffer of pixels (not game coordinates) to add to the frame for drawing

@end


@protocol RotatableOpticTool <NSObject>
@property (nonatomic) CGFloat angle;
@end


@protocol ResizeableOpticTool <NSObject>
@property (nonatomic) CGFloat length;
- (CGPoint)startPoint;
- (CGPoint)endPoint;
@end


@interface FlatOpticTool : OpticTool <RotatableOpticTool, ResizeableOpticTool> {
    CGPoint _flatToolOrigin;
    CGFloat _angle;
    CGFloat _length;
}

@property (nonatomic) CGPoint flatToolOrigin;

- (CGFloat)toolIntersectionDistanceForRay:(OpticRay *)ray rayIntersectionDistance:(CGFloat)rayDistance;

@end
