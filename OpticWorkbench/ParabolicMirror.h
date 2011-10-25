//
//  ParabolicMirror.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticTool.h"

@interface ParabolicMirror : OpticTool <FocuseableOpticTool, RotatableOpticTool, ResizeableOpticTool> {
    CGFloat _focalLength;
    CGFloat _angle;
    CGFloat _width;
    CGFloat _length;
    
    CGPoint _gamePosition;
}

@end
