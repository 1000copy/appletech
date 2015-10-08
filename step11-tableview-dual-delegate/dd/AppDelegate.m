//
//  AppDelegate.m
//  dd
//
//  Created by rita on 10/8/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (){
    NSMutableArray * states;
    NSMutableArray * citys;
    NSInteger r;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
-(id)init{
    self = [super init];
    r = 0;
    states = [[NSMutableArray alloc]initWithArray: @[@"CA",@"Washington"]];
    NSArray *citys1 = @[@"LA",@"SF"];
    NSArray *citys2 = @[@"Portland",@"Seatle"];
    citys = [[NSMutableArray alloc]initWithCapacity:10];
    [citys addObject:citys1];
    [citys addObject:citys2];
    return self;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
//    NSMutableArray * citys;

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
//NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (tableView == self.tv1)
        return states.count;
    if (tableView == self.tv2){
        NSArray * arr =(NSArray*)(citys[r]);
        return arr.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (tableView == self.tv1){
        return [states objectAtIndex:row];
    }
    if (tableView == self.tv2){
        return [[citys objectAtIndex:r] objectAtIndex:row];
    }return nil;
}

// delegate

//- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
//    return YES;
//}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
//    NSLog(@"Row changed%@",    [[self tv1] selectedRow]);
//     NSLog(@"Row changed%@",     [[aNotification object] selectedRow]);
//       NSLog(@"Row changed%d",     [[aNotification object] selectedRow]);
    r = [[aNotification object] selectedRow];
    [self.tv2 reloadData];
}
@end
