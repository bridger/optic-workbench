//
//  LightPoint.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticTool.h"

@interface LightPoint : OpticTool <RotatableOpticTool, ColorableOpticTool> {
    CGFloat _angle;
    CGColorRef _color;
}

@end
