//
//  LightFieldViewController.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OpticTool.h"

@class LightFieldView;
@class Sensor;
@interface LightFieldViewController : NSViewController {
    NSObject <CapturingOpticTool> *_sensor;
}

- (id)initWithSensor:(NSObject <CapturingOpticTool> *)sensor;

@property (assign) IBOutlet LightFieldView *lightFieldView;
- (IBAction)copyLightField:(id)sender;

@end
