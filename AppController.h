//
//  AppController.h
//  Nexus - a simple networking library for Cocoa
//
//  Created by Eric Will on 12/22/09.
//  Copyright 2009-2010 Malkier Networks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NXSocketTester.h"


@interface AppController : NSObject {
    IBOutlet NSProgressIndicator *spinner;
}

- (IBAction)testApp:(id)sender;

@end
