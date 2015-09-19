//
//  AppDelegate.m
//  dd
//
//  Created by rita on 15/9/19.
//  Copyright (c) 2015年 rita. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize box,v1,v2;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(void)awakeFromNib{
    NSView *view = v1.view;
    [box setContentView:view];
}

-(void) go1:(id)sender{
    NSView *view = v1.view;
    [box setContentView:view];
    
}
-(void) go2:(id)sender{
    NSView *view = v2.view;
    [box setContentView:view];
    
}

@end
