//
//  NXSocket.m - an easy-to-use socket
//  Nexus - a simple networking library for Cocoa
//
//  Created by Eric Will on 12/22/09.
//  Copyright 2009-2010 Malkier Networks. All rights reserved.
//

#import "NXSocket.h"

@implementation NXSocket

@synthesize remoteHost, remotePort, delegate;

/* init
 *     Raise an exception explaining the desiginated initializer.
 *
 * inputs     - none
 * outputs    - exception
 */
- (id)init
{
    [self dealloc];

    @throw [NSException exceptionWithName:@"BNRBadInitCall"
                                   reason:@"Use initWithHost:port:"
                                 userInfo:nil];
}

/* initWithHost:port:
 *     Initialize the object with the given host and port.
 *
 * inputs     - remote host, remote port
 * outputs    - self
 */
- (id)initWithHost:(NSHost *)host port:(int)port
{
    if (![super init])
        return nil;

    remoteHost  = host;
    remotePort  = port;

    [remoteHost retain];

    NSLog(@"Initialized new NXSocket to %@:%d",
          [remoteHost name], remotePort);

    return self;
}

/* dealloc
 *     Cleans stuff up.
 *
 * inputs     - none
 * outputs    - none
 */
- (void)dealloc
{
    NSLog(@"NXSocket to %@:%d being deallocated",
          [remoteHost name], remotePort);

    [_inStream  setDelegate:nil];
    [_outStream setDelegate:nil];

    [_inStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                         forMode:NSDefaultRunLoopMode];

    [_outStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];

    [_inStream  close];
    [_outStream close];

    [_inStream  release];
    [_outStream release];
    [_sendQ     release];
    [remoteHost release];

    [super dealloc];
}

/* connect
 *     Attempt to connect to remoteHost.
 *
 * inputs     - none
 * outputs    - none, will call delegate's error method on failure.
 */
- (void)connect
{
    NSLog(@"Attempting to connect to %@:%d", [remoteHost name], remotePort);

    /* Attempt to connect to our remote host */
    [NSStream getStreamsToHost:remoteHost port:remotePort
                   inputStream:&_inStream outputStream:&_outStream];

    if (!_inStream || !_outStream)
    {
        NSLog(@"Connection to %@:%d failed", [remoteHost name], remotePort);

        [delegate errorOccured];
        return;
    }

    [_inStream retain];
    [_outStream retain];

    [_inStream setDelegate:self];
    [_outStream setDelegate:self];

    [_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                         forMode:NSDefaultRunLoopMode];

    [_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];

    [_inStream  open];
    [_outStream open];

    NSLog(@"Connection to %@:%d established", [remoteHost name], remotePort);
}

/* writeData:
 *     Writes data to the sendQ, which is written when possible.
 *
 * inputs     - data to write
 * outputs    - none
 */
- (void)writeData:(NSMutableData *)data
{
    if (!_sendQ)
        _sendQ = [data mutableCopy];
    else
        [_sendQ appendData:data];

    [self writeSendQ];
}

/* read
 *     Reads data from iStream for as long as possible.
 *
 * inputs     - none
 * outputs    - none, will call appropriate delegate methods
 */
- (void)read
{
    NSMutableData *data = [NSMutableData data];

    while ([_inStream hasBytesAvailable])
    {
        NSUInteger len = 1024;
        uint8_t buf[len];

        NSInteger read = [_inStream read:buf maxLength:len];

        if (read)
            [data appendBytes:buf length:read];
        else
            [self errorFromStream:_inStream];
    }

    /* Let our delegate know */
    [delegate readData:data];
}

/* writeSendQ:
 *     Writes data pending in sendQ.
 *
 * inputs     - none
 * outputs    - none
 */
- (void)writeSendQ
{
    while (([_sendQ length] > 0) && ([_outStream hasSpaceAvailable]))
    {
        uint8_t *buf = (uint8_t *)[_sendQ bytes];
        NSUInteger len = [_sendQ length];

        NSUInteger written = [_outStream write:buf maxLength:len];

        NSLog(@"wrote data: %s", [_sendQ mutableBytes]);

        /* Delete the bytes that were just written */
        [_sendQ replaceBytesInRange:NSMakeRange(0, written)
                          withBytes:NULL
                             length:0];
    }
}

/* errorFromStream:
 *     Processes an error from specified stream.
 *
 * inputs     - stream that produced the error
 * outputs    - none, will call appropriate delegate methods
 */
- (void)errorFromStream:(NSStream *)stream
{
    NSLog(@"Stream error, %@", [stream streamError]);
    [delegate errorOccured];
}

/* stream:handleEvent: <NSStreamDelegate>
 *     Handle events that the streams toss out.
 *
 * inputs     - stream throwing events, the event
 * outputs    - none, will call appropriate handler methods
 */

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    //NSLog(@"stream %@ - code %d", stream, eventCode);

    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            if (stream != _inStream)
                return;

            [self read];

            break;

        case NSStreamEventHasSpaceAvailable:
            if (stream != _outStream)
                return;

            [self writeSendQ];

            break;

        case NSStreamEventErrorOccurred:
            if (stream != _inStream || stream != _outStream)
                return;

            [self errorFromStream:stream];

            break;

        default:
            break;
    }
}

@end