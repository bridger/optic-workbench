//
//  OpticWorkbenchLayer.h
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OpticTool.h"

@class ToolEditor;
@class OpticWorkbenchView;
@interface OpticWorkbenchLayer : CALayer {
    __weak OpticWorkbenchView *_view;
    
    NSMutableSet *_tools;
    CALayer *_rayLayer;
    CALayer *_toolsLayer;
    CALayer *_toolTemplatesLayer;
    ToolEditor *_toolEditor;
    
    NSMapTable *_lightFieldInspectors;
}

@property (nonatomic, assign) __weak OpticWorkbenchView *view;
@property (nonatomic, readonly) ToolEditor *toolEditor;
@property (nonatomic, readonly) CALayer *toolsLayer; //For hit-testing
@property (nonatomic, readonly) CALayer *toolTemplatesLayer; //For hit-testing

- (void)addOpticTool:(OpticTool *)tool;
- (void)removeOpticTool:(OpticTool *)tool;
- (void)opticToolAltered:(OpticTool *)tool;
- (void)showLightFieldInspector:(OpticTool <CapturingOpticTool> *)sensor;

- (CGRect)gameToPixelTransformRect:(CGRect)rect;
- (CGPoint)gameToPixelTransformPoint:(CGPoint)point;

- (CGPoint)pixelToGameTransformPoint:(CGPoint)point;
- (CGRect)pixelToGameTransformRect:(CGRect)rect;

@end
