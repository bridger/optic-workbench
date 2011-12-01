//
//  LightFieldView.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LightFieldView : NSView {
    NSArray *_capturedRays;
}

@property (nonatomic, copy) NSArray *capturedRays;

@end
