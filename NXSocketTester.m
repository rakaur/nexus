//
//  NXSocketTester.m
//  Nexus
//
//  Created by Eric Will on 7/28/10.
//  Copyright 2010 Malkier Networks. All rights reserved.
//

#import "NXSocketTester.h"


@implementation NXSocketTester

- (id)init
{
    if (![super init])
        return nil;
    
    socket = [[NXSocket alloc]
              initWithHost:[NSHost hostWithName:@"irc.malkier.net"]
              port:6667];
              
    [socket setDelegate:self];
    
    [socket connect];
    
    /* Send initial login info */
    [self sendCmd:@"NICK poop\r\n"];
    [self sendCmd:@"USER poop 2 3 :hello\r\n"];
        
    return self;
}

- (void)sendCmd:(NSString *)cmd
{
    NSMutableData *data = [NSMutableData dataWithData:
                           [cmd dataUsingEncoding:NSASCIIStringEncoding]];
    
    [socket writeData:data];
}

- (void)readData:(NSMutableData *)data
{
    NSString *s = [[NSString alloc] initWithData:data
                                        encoding:NSASCIIStringEncoding];
    
    NSLog(@"read data: %@", s);
    
    /* XXX - further processing */
}

- (void)errorOccured
{
    [socket release];
}

- (void)fatalErrorOccured
{
    // ...
}

@end
