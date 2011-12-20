//
//  LightFieldViewController.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LightFieldViewController.h"
#import "Sensor.h"
#import "LightFieldView.h"

@implementation LightFieldViewController
@synthesize lightFieldView;


- (id)initWithSensor:(NSObject <CapturingOpticTool> *)sensor {
    self = [super initWithNibName:@"LightFieldViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _sensor = [sensor retain];
        
    }
    return self;
}


- (void)awakeFromNib {
    [_sensor addObserver:self forKeyPath:@"capturedRays" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"capturedRays"]) {
        [self.lightFieldView setCapturedRays:[change valueForKey:NSKeyValueChangeNewKey]];
    }
}

- (void)dealloc {
    [_sensor removeObserver:self forKeyPath:@"capturedRays"];
    [_sensor release];
    
    [super dealloc];
}

- (IBAction)copyLightField:(id)sender {
    NSArray *lightField = [_sensor capturedRays];
    
    NSArray *sortedLightField = [lightField sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        CGFloat position1 = [(CapturedOpticRay *)obj1 position];
        CGFloat position2 = [(CapturedOpticRay *)obj2 position];

        
        if (position1 < position2) {
            return -1;
        } else if (position1 > position2) {
            return 1;
        } else {
            return 0;
        }
    }];
    
    
    NSMutableString *copyString = [[NSMutableString alloc] init];
    for (CapturedOpticRay *ray in sortedLightField) {
        [copyString appendFormat:@"[%f, %f]\n", [ray position], normalizedAngle([ray angle])];
    }
    
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    [pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pboard setString:copyString forType:NSStringPboardType];
}



@end
