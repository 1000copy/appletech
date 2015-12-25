//
//  AppDelegate.m
//  status
//
//  Created by rita on 9/21/15.
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
-(void)awakeFromNib{
    NSBundle* bundle = [NSBundle mainBundle];
    [self.window setIsVisible:NO];
    //    [NSApp activateIgnoringOtherApps:NO];
    iconSmallNormal			= [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menu_normal" ofType:@"png"]];
    iconSmallNormalReverse	= [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menu_highlight" ofType:@"png"]];
    iconSmallAlaternate		= [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menu_alternate" ofType:@"png"]];

    statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusBarItem setTitle:@""];
    [statusBarItem setImage:iconSmallNormal];
    [statusBarItem setAlternateImage:iconSmallAlaternate];
    [statusBarItem setMenu:statusBarMenu];
    [statusBarItem setHighlightMode:YES];

}

-(IBAction)exit_menu:(id)sender{NSLog(@"exit");
//    [self terminate];
}
-(IBAction)help_menu:(id)sender{NSLog(@"?");}


@end
