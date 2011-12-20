//
//  Document.h
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OpticWorkbenchView.h"

@interface Document : NSDocument {
    NSDictionary *_puzzleToRestore;
}

@property (assign) IBOutlet OpticWorkbenchView *opticWorkbenchView;

@end
