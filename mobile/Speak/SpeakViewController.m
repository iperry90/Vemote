//
//  SpeakViewController.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakViewController.h"

@interface SpeakViewController () <WitDelegate, SocketIODelegate>
@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) SocketIO *witSocket;
@end

@implementation SpeakViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Wit sharedInstance].delegate = self;
 
    [self setUp];
}

- (void)setUp
{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    WITMicButton *witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
}


#pragma mark - WitDelegate methods

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e
{
    if (e)
    {
        NSLog(@"error: %@", [e localizedDescription]);
    }

    
    // send intent to socket
    self.witSocket = [[SocketIO alloc] initWithDelegate:self];
    [self.witSocket connectToHost:@"107.170.21.35" onPort:3000];
    self.dictionary = entities;

}

#pragma mark - SocketIODelegate methods

- (void)socketIODidConnect:(SocketIO *)socket
{
    [self.witSocket sendJSON:self.dictionary];
}

@end
