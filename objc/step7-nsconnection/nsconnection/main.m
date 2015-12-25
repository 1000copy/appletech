//
//  main.m
//  nsconnection
//
//  Created by rita on 10/1/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Main : NSObject
-(NSString*)Echo:(NSString*)s;
+(void)start;

@end

@interface Friend : NSObject{
    
}
-(void)ServerThread:(NSArray*)ports;
@end

@implementation Friend;

-(void)ServerThread:(NSArray*)ports{
    NSPort *p1 = [ports objectAtIndex:0];
    NSPort *p2 = [ports objectAtIndex:1];
    // reverse to peer
    NSConnection *c = [NSConnection connectionWithReceivePort:p2 sendPort:p1];
    id proxy = [c rootProxy];
    NSLog(@"%@",[proxy Echo:@"hallo"]);
}

@end
NSConnection *c ;
@implementation Main
+(void)start{
    NSPort *p1 = [NSPort port];
    NSPort *p2 = [NSPort port];
    // troubleshooting:will free on start exit,then thread call rootproxy will no result
//    NSConnection *c = [NSConnection connectionWithReceivePort:p1 sendPort:p2];
    c = [NSConnection connectionWithReceivePort:p1 sendPort:p2];
    Main *m = [[Main alloc]init];
    Friend *friend = [[Friend alloc]init];
    [c setRootObject:m];
    [NSThread detachNewThreadSelector:@selector(ServerThread:) toTarget:friend withObject:@[p1,p2] ];
    NSLog(@"Hello, Main!");

}
-(NSString*)Echo:(NSString*)s
{
    return [s stringByAppendingString: @"echo from Main"];
}

@end
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        [Main start];
        [[NSRunLoop currentRunLoop]run];
//        usleep(1000000000);
        NSLog(@"Bye");
    }
    return 0;
}
