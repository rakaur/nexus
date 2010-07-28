//
//  NXSocketTester.h
//  Nexus
//
//  Created by Eric Will on 7/28/10.
//  Copyright 2010 Malkier Networks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NXSocket.h"


@interface NXSocketTester : NSObject <NXSocketDelegate> {
    NXSocket *socket;
}

- (void)sendCmd:(NSString *)cmd;

- (void)readData:(NSMutableData *)data;
- (void)errorOccured;
- (void)fatalErrorOccured;

@end
