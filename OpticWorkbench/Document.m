//
//  Document.m
//  OpticWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Document.h"
#import "OpticWorkbenchLayer.h"

@implementation Document
@synthesize opticWorkbenchView;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    if (_puzzleToRestore) {
        [opticWorkbenchView.opticWorkbenchLayer loadPuzzle:_puzzleToRestore];
        
        [_puzzleToRestore release];
        _puzzleToRestore = NULL;
    }
    
    [self setUndoManager:[opticWorkbenchView undoManager]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    NSDictionary *savedPuzzle = [opticWorkbenchView.opticWorkbenchLayer savePuzzle];
    
    return [NSKeyedArchiver archivedDataWithRootObject:savedPuzzle];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    */
    
    if (opticWorkbenchView != nil) {
        
        return [opticWorkbenchView.opticWorkbenchLayer loadPuzzle:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    } else {
        _puzzleToRestore = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];

        return YES;
    }
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
