//
//  ToolEditor.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OpticTool.h"

@class OpticWorkbenchLayer;
@interface ToolEditor : NSObject {
    OpticTool *_editPart;
    __weak OpticWorkbenchLayer *_workbench;
    CALayer *_editIndicatorLayer;
    CALayer *_resizeLayerRight;
    CALayer *_resizeLayerLeft;
    
    bool _isDragging;
    
    bool _rotates;
    bool _isRotating;
    CGFloat _toolStartingAngle; //The angle the tool was at before we started rotating
    CGFloat _editorStartingAngle; //What angle the mouse was at when the drag was started
    
    bool _resizes;
    bool _isResizing;
    bool _focuses;
    
    CGPoint _originalCenterPoint; //Where the tool was when we were first clicked
}

@property (nonatomic, assign) __weak OpticWorkbenchLayer *workbench;

- (void)mouseDownAtWorkbenchPoint:(CGPoint)point;
- (void)mouseDraggedAtWorkbenchPoint:(CGPoint)point;
- (void)mouseUpAtWorkbenchPoint:(CGPoint)point;
- (NSArray *)layers;

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

@end
