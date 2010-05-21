//
//  NXSocket.h - an easy-to-use socket
//  Nexus - a simple networking library for Cocoa
//
//  Created by Eric Will on 12/22/09.
//  Copyright 2009-2010 Malkier Networks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NXSocketDelegate
- (void)readData:(NSMutableData *)data;
- (void)errorOccured;
- (void)fatalErrorOccured;
@end

@interface NXSocket : NSObject <NSStreamDelegate> {
    NSHost *remoteHost;
        int remotePort;

    id <NXSocketDelegate> delegate;

    NSInputStream  *_inStream;
    NSOutputStream *_outStream;
    NSMutableData  *_sendQ;
}

@property(nonatomic, readonly,  retain) NSHost *remoteHost;
@property(nonatomic, readonly,  assign)     int remotePort;
@property(nonatomic, readwrite, assign) id <NXSocketDelegate> delegate;

- (id)init;
- (id)initWithHost:(NSHost *)host port:(int) port;
- (void)dealloc;
- (void)connect;
- (void)writeData:(NSMutableData *)data;
- (void)read;
- (void)writeSendQ;
- (void)errorFromStream:(NSStream *)stream;
@end
