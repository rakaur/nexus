//
//  NexusAppDelegate.h
//  Nexus
//
//  Created by Eric Will on 12/22/09.
//  Copyright 2009 Malkier Networks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NexusAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
