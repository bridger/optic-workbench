//
//  ToolEditor.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ToolEditor.h"
#import "OpticTool.h"
#import "OpticWorkbenchLayer.h"

@interface ToolEditor ()

@property (nonatomic, retain) OpticTool *editPart;
@property (nonatomic, assign) bool rotates;
@property (nonatomic, assign) bool resizes;
@property (nonatomic, assign) bool focuses;

@end

@implementation ToolEditor

@synthesize workbench = _workbench, editPart = _editPart, rotates = _rotates, resizes = _resizes, focuses = _focuses;

- (id)init {
    self = [super init];
    if (self) {        
        _editIndicatorLayer = [[CALayer alloc] init];
        _editIndicatorLayer.frame = CGRectMake(0, 0, 120, 120);
        _editIndicatorLayer.delegate = self;
        _editIndicatorLayer.hidden = YES;
        [_editIndicatorLayer setNeedsDisplayOnBoundsChange:YES];
        [_editIndicatorLayer setNeedsDisplay];
        
        _resizeLayerRight = [[CALayer alloc] init];
        _resizeLayerRight.frame = CGRectMake(0, 0, 10, 10);
        _resizeLayerRight.hidden = YES;
        _resizeLayerRight.backgroundColor = CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0);
        
        _resizeLayerLeft = [[CALayer alloc] init];
        _resizeLayerLeft.frame = CGRectMake(0, 0, 10, 10);
        _resizeLayerLeft.hidden = YES;
        _resizeLayerLeft.backgroundColor = CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0);
        
        
        _focusLayerRight = [[CALayer alloc] init];
        _focusLayerRight.frame = CGRectMake(0, 0, 10, 10);
        _focusLayerRight.hidden = YES;
        _focusLayerRight.backgroundColor = CGColorCreateGenericRGB(0.0, 0.0, 1.0, 1.0);
        
        _focusLayerLeft = [[CALayer alloc] init];
        _focusLayerLeft.frame = CGRectMake(0, 0, 10, 10);
        _focusLayerLeft.hidden = YES;
        _focusLayerLeft.backgroundColor = CGColorCreateGenericRGB(0.0, 0.0, 1.0, 1.0);
    }
    return self;
}

- (NSArray *)layers {
    return [NSArray arrayWithObjects:_editIndicatorLayer, _resizeLayerRight, _resizeLayerLeft, _focusLayerLeft, _focusLayerRight, nil];
}


- (void)setEditPart:(OpticTool *)editPart {
    if (editPart == NULL) {
        _editIndicatorLayer.hidden = YES;
    } else {
        _editIndicatorLayer.hidden = NO;
    }
    
    [_editPart removeObserver:self forKeyPath:@"position"];
    if (self.rotates) {
        [_editPart removeObserver:self forKeyPath:@"angle"];
    }
    if (self.resizes) {
        [_editPart removeObserver:self forKeyPath:@"startPoint"];
        [_editPart removeObserver:self forKeyPath:@"endPoint"];
    }
    if (self.focuses) {
        [_editPart removeObserver:self forKeyPath:@"leftFocalPoint"];
        [_editPart removeObserver:self forKeyPath:@"rightFocalPoint"];
    }
    [_editPart autorelease];
    
    _editPart = [editPart retain];
    [_editPart addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionInitial context:nil];
    
    
    self.rotates = [_editPart conformsToProtocol:@protocol(RotatableOpticTool)];
    self.resizes = [_editPart conformsToProtocol:@protocol(ResizeableOpticTool)];
    self.focuses = [_editPart conformsToProtocol:@protocol(FocuseableOpticTool)];
    
    
    if (self.rotates) {
        [_editPart addObserver:self forKeyPath:@"angle" options:NSKeyValueObservingOptionInitial context:nil];
    } else {
        //Set the rotation to 0
        [_editIndicatorLayer setValue:[NSNumber numberWithDouble:0] forKeyPath:@"transform.rotation"];
    }
    if (self.resizes) {
        [_editPart addObserver:self forKeyPath:@"startPoint" options:NSKeyValueObservingOptionInitial context:nil];
        [_editPart addObserver:self forKeyPath:@"endPoint" options:NSKeyValueObservingOptionInitial context:nil];
    }
    if (self.focuses) {
        [_editPart addObserver:self forKeyPath:@"leftFocalPoint" options:NSKeyValueObservingOptionInitial context:nil];
        [_editPart addObserver:self forKeyPath:@"rightFocalPoint" options:NSKeyValueObservingOptionInitial context:nil];
    }
}

- (void)setResizes:(bool)resizes {
    if (resizes != _resizes) {
        [_editIndicatorLayer setNeedsDisplay];
    }
    _resizes = resizes;
    if (_resizes) {
        _resizeLayerRight.hidden = NO;
        _resizeLayerLeft.hidden = NO;
    } else {
        _resizeLayerRight.hidden = YES;
        _resizeLayerLeft.hidden = YES;
    }
}

- (void)setFocuses:(bool)focuses {
    if (focuses != _focuses) {
        [_editIndicatorLayer setNeedsDisplay];
    }
    _focuses = focuses;
    if (_focuses) {
        _focusLayerRight.hidden = NO;
        _focusLayerLeft.hidden = NO;
    } else {
        _focusLayerRight.hidden = YES;
        _focusLayerLeft.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _editPart) {
        if ([keyPath isEqualToString:@"position"]) { 
            _editIndicatorLayer.position = _editPart.position;
        } else if ([keyPath isEqualToString:@"angle"]) {
            CGFloat newAngle = [(OpticTool<RotatableOpticTool> *)_editPart angle];
            [_editIndicatorLayer setValue:[NSNumber numberWithDouble:newAngle] forKeyPath:@"transform.rotation"];
        } else if ([keyPath isEqualToString:@"startPoint"]) {            
            CGPoint startPoint = [(OpticTool<ResizeableOpticTool> *)_editPart startPoint];
            _resizeLayerLeft.position = [self.workbench gameToPixelTransformPoint:startPoint];
        } else if ([keyPath isEqualToString:@"endPoint"]) {
            CGPoint endPoint = [(OpticTool<ResizeableOpticTool> *)_editPart endPoint];
            _resizeLayerRight.position = [self.workbench gameToPixelTransformPoint:endPoint];
        } else if ([keyPath isEqualToString:@"leftFocalPoint"]) {
            CGPoint point = [(OpticTool<FocuseableOpticTool> *)_editPart leftFocalPoint];
            _focusLayerLeft.position = [self.workbench gameToPixelTransformPoint:point];
        } else if ([keyPath isEqualToString:@"rightFocalPoint"]) {
            CGPoint point = [(OpticTool<FocuseableOpticTool> *)_editPart rightFocalPoint];
            _focusLayerRight.position = [self.workbench gameToPixelTransformPoint:point];
        }
    }
}


- (void)mouseDownAtWorkbenchPoint:(CGPoint)point {
    //Decide if we are rotating or dragging if we click within our rect
    _isResizing = false;
    _isRotating = false;
    _isDragging = false;
    _isFocusing = false;
    
    if (_editPart != NULL) {
        _originalCenterPoint = _editPart.gamePosition;
        
        if (_resizes && (CGRectContainsPoint([_resizeLayerLeft frame], point) || 
                         CGRectContainsPoint([_resizeLayerRight frame], point))) {
            
            _isResizing = true;
            
        } else if (_focuses && (CGRectContainsPoint([_focusLayerLeft frame], point) || 
                                CGRectContainsPoint([_focusLayerRight frame], point))) { 
            
            _isFocusing = true;
            
        } else if (CGRectContainsPoint([_editIndicatorLayer frame], point)) {
            //Either a drag or a rotation
            
            CGFloat centerDistance = sqrt( pow((point.x - _editIndicatorLayer.position.x), 2) +  pow((point.y - _editIndicatorLayer.position.y), 2) );
            
            if (centerDistance / (_editIndicatorLayer.bounds.size.width / 2) > 0.65 && _rotates) {
                
                //Clicked in the circle. It is a rotation
                _isRotating = true;
                _toolStartingAngle = [(OpticTool<RotatableOpticTool> *)_editPart angle];
                _editorStartingAngle = atan2(point.x - _editIndicatorLayer.position.x, point.y - _editIndicatorLayer.position.y);
                
            } else {
                //Clicked in the center. It is a drag
                _isDragging = true;
            }
        }
    }
    
    //No operation was chosen, so we can deselect or select a new tool
    if (!_isResizing && !_isRotating && !_isDragging && !_isFocusing) {
        CALayer *hitTool = [_workbench.toolsLayer hitTest:point];
        if ([hitTool isKindOfClass:[OpticTool class]]) {
            self.editPart = (OpticTool *)hitTool;
            _isDragging = true;
            _originalCenterPoint = _editPart.gamePosition;
        } else {
            
            //Maybe clicked on a template tool, so we should duplicate it and start editing it
            CALayer *hitTemplate = [_workbench.toolTemplatesLayer hitTest:point];
            if ([hitTemplate isKindOfClass:[OpticTool class]]) {
                OpticTool *copy = [(OpticTool *)hitTemplate copy];
                [self.workbench addOpticTool:copy];
                
                self.editPart = copy;
                _isDragging = true;
                _originalCenterPoint = _editPart.gamePosition;
            } else {
                self.editPart = NULL;
            }
        }
    }
}

- (void)mouseDraggedAtWorkbenchPoint:(CGPoint)point {
    if (_editPart != NULL) {
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        if (_isRotating) {
            CGFloat newEditorAngle = atan2(point.x - _editIndicatorLayer.position.x, point.y - _editIndicatorLayer.position.y);
            CGFloat angleDifference = newEditorAngle - _editorStartingAngle;
            CGFloat newToolAngle = _toolStartingAngle - angleDifference;
                        
            [(OpticTool<RotatableOpticTool> *)_editPart setAngle:newToolAngle];
            _editPart.gamePosition = _originalCenterPoint;
            
        } else if (_isDragging) {
            //It is just a drag
            CGPoint newGamePoint = [_workbench pixelToGameTransformPoint:point];

            
            _editPart.gamePosition = newGamePoint;
        } else if (_isResizing) {
            //Find the new distance from the cursor to the center. This is half the new length            
            CGPoint newPoint = [self.workbench pixelToGameTransformPoint:point];
            
            CGFloat newDistance = sqrt( pow(newPoint.x - _originalCenterPoint.x, 2) + pow(newPoint.y - _originalCenterPoint.y, 2) );
            
            [(OpticTool<ResizeableOpticTool> *)_editPart setLength:newDistance * 2];
            [_editPart setGamePosition:_originalCenterPoint]; //We want it to remain in the same place
        } else if (_isFocusing) {
            //Find the new distance from the cursor to the center. This is the new focal length         
            CGPoint newPoint = [self.workbench pixelToGameTransformPoint:point];
            
            CGFloat newDistance = sqrt( pow(newPoint.x - _originalCenterPoint.x, 2) + pow(newPoint.y - _originalCenterPoint.y, 2) );
            
            [(OpticTool<FocuseableOpticTool> *)_editPart setFocalLength:newDistance];
        }
        
        [CATransaction commit];
    }
}

- (void)mouseUpAtWorkbenchPoint:(CGPoint)point {
    
}

- (void)keyUp:(NSEvent *)theEvent {
    if ([theEvent keyCode] == 51) { //Delete key
        if (_editPart) {
            //Remove the part
            OpticTool *deleteTool = self.editPart;
            
            self.editPart = nil;
            [self.workbench removeOpticTool:deleteTool];
            
        }
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == _editIndicatorLayer) {
        CGPoint centerPoint = CGPointMake(_editIndicatorLayer.bounds.size.width / 2 + _editIndicatorLayer.bounds.origin.x, 
                                          _editIndicatorLayer.bounds.size.height / 2 + _editIndicatorLayer.bounds.origin.y);
        
        CGFloat outerRadius = 0.98 * _editIndicatorLayer.bounds.size.width / 2;
        
        CGFloat innerRadius = 0.85 * _editIndicatorLayer.bounds.size.width / 2;
        CGFloat arrowPointRadius = 0.60 * _editIndicatorLayer.bounds.size.width / 2;
        
        CGFloat arrowWidth = M_PI / 16;
        
        CGFloat resizeSpacer = M_PI / 32;
        
        for (int i = 0; i < 4; i++ ) {
            CGFloat startAngle = M_PI_2 * i;
            CGFloat endAngle = M_PI_2 * (i + 1);
            
            if (self.resizes) { //Leave a little space for the resize indicators
                if (i == 0 || i == 2) {
                    startAngle += resizeSpacer;
                } else if (i == 1 || i == 3) {
                    endAngle -= resizeSpacer;
                }
            }
            
            //Draw the first stroke of the inner circle, until it hits the inner arrow
            CGContextAddArc(ctx, centerPoint.x, centerPoint.y, innerRadius, startAngle, startAngle + M_PI_4 - arrowWidth, 0);
            
            //Draw the point of the inner arrw
            CGContextAddLineToPoint(ctx, centerPoint.x + cos(M_PI_4 + M_PI_2 * i) * arrowPointRadius,
                                    centerPoint.y + sin(M_PI_4 + M_PI_2 * i) * arrowPointRadius);
            
            //Finish the inside are from the inner arrow
            CGContextAddArc(ctx, centerPoint.x, centerPoint.y, innerRadius,endAngle - M_PI_4 + arrowWidth, endAngle, 0);        
            
            //Draw the outside arc
            CGContextAddArc(ctx, centerPoint.x, centerPoint.y, outerRadius, endAngle, startAngle, 1);  
            
            CGContextSetFillColorWithColor(ctx, CGColorCreateGenericRGB(1.0, 0.0, 1.0, 0.8));
            CGContextFillPath(ctx);
        }
    }
}

@end
