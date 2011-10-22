//
//  Lens.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticTool.h"

@interface Lens : FlatOpticTool <FocuseableOpticTool> {
    CGFloat _focalLength;
}

@end
