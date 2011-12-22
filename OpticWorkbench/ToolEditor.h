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
    NSUndoManager *_undoManager;
    CALayer *_editIndicatorLayer;
    
    CALayer *_resizeLayerRight;
    CALayer *_resizeLayerLeft;
    
    CALayer *_focusLayerRight;
    CALayer *_focusLayerLeft;
    
    bool _hasEdited;
    
    bool _isDragging;
    CGPoint _originalCenterPoint; //Where the tool was when we were first clicked
    CGPoint _dragCenterOffset;
    bool _isNewPart;
    
    bool _rotates;
    bool _isRotating;
    CGFloat _originalAngle; //The angle the tool was at before we started rotating
    CGFloat _editorStartingAngle; //What angle the mouse was at when the drag was started
    
    bool _resizes;
    bool _isResizing;
    CGFloat _originalLength;
    
    bool _focuses;
    bool _isFocusing;
    CGFloat _originalFocalLength;
    
    bool _colors;    
    bool _showsLightField;
}

@property (nonatomic, assign) __weak OpticWorkbenchLayer *workbench;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)mouseDownAtWorkbenchPoint:(CGPoint)point;
- (void)mouseDraggedAtWorkbenchPoint:(CGPoint)point;
- (void)mouseUpAtWorkbenchPoint:(CGPoint)point;
- (void)keyUp:(NSEvent *)theEvent;
- (NSArray *)layers;

- (void)rotateTool:(OpticTool *)tool toAngle:(CGFloat)angle;
- (void)moveTool:(OpticTool *)tool toPosition:(CGPoint)position;
- (void)setTool:(OpticTool *)tool onBoard:(BOOL)onBoard;
- (void)resizeTool:(OpticTool<ResizeableOpticTool> *)tool toLength:(CGFloat)length;
- (void)focusTool:(OpticTool<FocuseableOpticTool> *)tool toFocalLength:(CGFloat)focalLength;

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

@end
