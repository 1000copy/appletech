//
//  AppDelegate.h
//  dd
//
//  Created by rita on 10/8/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSTableView *tv1;
@property (weak) IBOutlet NSTableView *tv2;

@end

