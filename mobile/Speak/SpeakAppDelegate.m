//
//  SpeakAppDelegate.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakAppDelegate.h"

@implementation SpeakAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Wit sharedInstance].accessToken = @"RCYZL5GTVUWO66SKCGJSTIQLDGNNWA3A";
    return YES;
}

@end
