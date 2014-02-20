//
//  SpeakViewController.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakViewController.h"

@interface SpeakViewController () <WitDelegate, SocketIODelegate, NSURLConnectionDelegate>
@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) SocketIO *witSocket;
@property (strong, nonatomic) SocketIO *instaSocket;
@property (strong, nonatomic) NSDictionary *entities;
@property (strong, nonatomic) NSString *intent;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation SpeakViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Wit sharedInstance].delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"])
    {
        [self sendInstagramData];
    }
    
    
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)setUp
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(32.0f/255.0f) green:(36.0f/255.0f) blue:(57.0f/255.0f) alpha:1.0f];

    self.bottomView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.17];
    
    
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 75;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 470, 75, 75);
    
    WITMicButton *witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:@"VoiceButton"];
    [self.view addSubview:imageView];
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
    [self.witSocket connectToHost:@"107.170.21.35" onPort:4000];
    
    if (intent && entities)
    {
        self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:intent, entities, nil] forKeys:[[NSArray alloc] initWithObjects:@"intent", @"entities", nil]];
    }
    
    self.intent = intent;
    self.entities = entities;
    
    if (intent && entities)
    {
        if ([intent isEqualToString:@"play_youtube"])
        {
            [self makeYouTubeAPIRequest];
            
        }
        if ([intent isEqualToString:@"resume"])
        {
            self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:intent, nil] forKeys: [[NSArray alloc] initWithObjects:@"intent", nil]];
        }
        if ([intent isEqualToString:@"stop"])
        {
            self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:intent, nil] forKeys: [[NSArray alloc] initWithObjects:@"intent", nil]];
        }
        if ([intent isEqualToString:@"play_music"])
        {
            self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:intent, entities, nil] forKeys:[[NSArray alloc] initWithObjects:@"intent", @"entities", nil]];
        }
    }
    

}

#pragma mark - SocketIODelegate methods

- (void)socketIODidConnect:(SocketIO *)socket
{
    if ([socket isEqual:self.witSocket])
    {
        [self.witSocket sendJSON:self.dictionary];
    }
    else if ([socket isEqual:self.instaSocket])
    {
        [self.instaSocket sendJSON:self.dictionary];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    
}


- (void)makeYouTubeAPIRequest
{
    NSString *query = [[self.entities objectForKey:@"video"] objectForKey:@"value"];
    NSString *modifiedQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if (modifiedQuery)
    {
        self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:modifiedQuery, self.intent, nil] forKeys: [[NSArray alloc] initWithObjects:@"query", @"intent", nil]];
    }
}

- (void)sendInstagramData
{
    self.instaSocket = [[SocketIO alloc] initWithDelegate:self];
    [self.instaSocket connectToHost:@"107.170.21.35" onPort:4000];
    
    self.dictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"], @"insta", nil] forKeys:[[NSArray alloc] initWithObjects:@"access_token", @"intent", nil]];
}


- (void)getInstagramID
{
    
}






@end
