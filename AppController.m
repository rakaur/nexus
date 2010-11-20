//
//  AppController.m
//  Nexus - a simple networking library for Cocoa
//
//  Created by Eric Will on 12/22/09.
//  Copyright 2009-2010 Malkier Networks. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (IBAction)testApp:(id)sender
{
    NXSocketTester *tester;
    
    [spinner startAnimation:sender];
    
    tester = [[NXSocketTester alloc] init];
    [tester autorelease];
}

@end
