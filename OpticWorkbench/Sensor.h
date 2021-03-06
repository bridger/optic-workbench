//
//  Obstacle.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticTool.h"

@interface Sensor : FlatOpticTool <CapturingOpticTool> {
    NSArray *_capturedRays;
    NSMutableArray *_currentRays;
}

@end
