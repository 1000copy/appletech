//
//  AppDelegate.h
//  status
//
//  Created by rita on 9/21/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSImage* 				iconSmallNormal;
    NSImage* 				iconSmallNormalReverse;
    NSImage    	*iconSmallAlaternate		 ;
    IBOutlet NSMenu*		statusBarMenu;
    NSStatusItem*			statusBarItem;	
}
-(IBAction)exit_menu:(id)sender;

@end

