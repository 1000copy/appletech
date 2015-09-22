//
//  AppDelegate.m
//  drawer
//
//  Created by rita on 9/22/15.
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
-(IBAction)buttonClicked:(id)sender{
    NSLog(@"1");
}
@end
