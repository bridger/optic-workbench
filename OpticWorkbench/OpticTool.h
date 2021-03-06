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

- (void)traceDidStart;
- (void)traceDidEnd;

@end


@protocol RotatableOpticTool <NSObject>
@property (nonatomic) CGFloat angle;
@end


@protocol ResizeableOpticTool <NSObject>
@property (nonatomic) CGFloat length;
@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, readonly) CGPoint endPoint;
@end

@protocol FocuseableOpticTool <NSObject>
@property (nonatomic) CGFloat focalLength;
@property (nonatomic, readonly) CGPoint leftFocalPoint;
@property (nonatomic, readonly) CGPoint rightFocalPoint;
@end

@protocol ColorableOpticTool <NSObject>
@property (nonatomic, assign) CGColorRef color;
- (void)randomizeColor;
@end


@protocol CapturingOpticTool <NSObject>
@property (nonatomic, copy, readonly) NSArray *capturedRays;
@end


@interface FlatOpticTool : OpticTool <RotatableOpticTool, ResizeableOpticTool> {
    CGPoint _flatToolOrigin;
    CGFloat _angle;
    CGFloat _length;
}

@property (nonatomic) CGPoint flatToolOrigin;

- (CGFloat)toolIntersectionDistanceForRay:(OpticRay *)ray rayIntersectionDistance:(CGFloat)rayDistance;

@end
