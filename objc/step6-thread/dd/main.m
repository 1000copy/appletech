//
//  main.m
//  dd
//
//  Created by rita on 9/30/15.
//  Copyright (c) 2015 rita. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface th : NSObject
+(void)Dispather;
-(void)ServerThread:(id)obj;

@end
@implementation th
+(void)Dispather{
    
    th *h = [[th alloc] init];
    [NSThread detachNewThreadSelector:@selector(ServerThread:) toTarget:h withObject:@"argu"];
    NSNumber*n = [NSNumber numberWithInt:0];
    NSNumber*n1 = [NSNumber numberWithInt:1];
    NSArray *p = [NSArray arrayWithObjects:n,n1, nil];
    [NSThread detachNewThreadSelector:@selector(ServerThread:) toTarget:h withObject:p];
    NSLog(@"Hello, World!");
    usleep(1000000);
    //        NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"Thread %@ exit ",[NSThread currentThread] );

}
-(void)ServerThread:(id)obj{
    NSLog(@"argument:%@",obj);
    NSLog(@"Thread %@ exit ",[NSThread currentThread] );
}
@end
 int thread_count;
@interface Tickets : NSObject{
   
    int total;
    int current;
    NSThread *atm1;
    NSThread *atm2;
    NSCondition *lock;
}
+(BOOL)getOk;
+(void)Dispather;
-(void)ServerThread:(id)obj;

@end
@implementation Tickets


+(BOOL)getOk{
    return thread_count ==0;
}
+(void)Dispather{
    Tickets *h = [[Tickets alloc] init];
    thread_count = 2;
    h->total = 10;
    h->current =h->total;
    h->atm1 = [[NSThread alloc]initWithTarget:h selector:@selector(ServerThread:) object:nil];
    [h->atm1 setName:@"thread1"];
    h->atm2 = [[NSThread alloc]initWithTarget:h selector:@selector(ServerThread:) object:nil];
    [h->atm2 setName:@"thread2"];
    [h->atm1 start];
    [h->atm2 start];
    usleep(10000000);//10 seconds
    
}
-(void)ServerThread:(id)obj{
    while(TRUE){
        [lock lock];
        if(current>0){
             [NSThread sleepForTimeInterval:0.5];
            current--;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",current,total-current,[[NSThread currentThread] name]);
        }else break;
        [lock unlock];
    }
    thread_count--;
}


@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        [th Dispather];
        [Tickets Dispather];
        while(![Tickets getOk]);
    }
    return 0;
}
