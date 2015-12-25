//
//  AppDelegate.m
//  dd
//
//  Created by rita on 10/8/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//NSTableViewDataSource


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 1;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return @"a";
}


@end
