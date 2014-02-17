//
//  SpeakLoginViewController.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakLoginViewController.h"

@interface SpeakLoginViewController ()
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *rdioButton;
@property (strong, nonatomic) IBOutlet UIButton *instagramButton;
@end

@implementation SpeakLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.descriptionLabel.textColor = [UIColor whiteColor];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"])
    {
        self.instagramButton.enabled = NO;
        self.instagramButton.hidden = YES;
    }
}


@end
