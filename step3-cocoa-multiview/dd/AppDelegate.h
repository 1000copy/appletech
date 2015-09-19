//
//  AppDelegate.h
//  dd
//
//  Created by rita on 15/9/19.
//  Copyright (c) 2015年 rita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

//@property (weak)IBOutlet NSWindow* window;
@property(weak)IBOutlet NSViewController * v1;
@property (weak)IBOutlet NSViewController * v2 ;
@property (weak)IBOutlet NSBox *box;

-(IBAction)go1 :(id)sender;
-(IBAction)go2  :(id)sender;
@end

