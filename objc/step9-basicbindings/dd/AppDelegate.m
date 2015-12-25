//
//  AppDelegate.m
//  dd
//
//  Created by rita on 10/6/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize imageScale;
@synthesize imageTitle;
-(IBAction)resetAllValues:(id)sender{
    self.imageTitle = @"default title";
    self.imageScale = 50;
    
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
