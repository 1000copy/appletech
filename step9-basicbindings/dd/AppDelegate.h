//
//  AppDelegate.h
//  dd
//
//  Created by rita on 10/6/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (copy)NSString *imageTitle;
@property(assign) NSInteger imageScale;
-(IBAction)resetAllValues :(id)sender;
@end

