//
//  OpticWorkbenchView.h
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OpticWorkbenchLayer;
@interface OpticWorkbenchView : NSView {
    OpticWorkbenchLayer *layer;
}

@property (nonatomic, readonly) OpticWorkbenchLayer *opticWorkbenchLayer;

@end
