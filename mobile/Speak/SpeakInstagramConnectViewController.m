//
//  InstagramLoginViewController.m
//  vmote
//
//  Created by pavey nganpi on 2/16/14.
//  Copyright (c) 2014 pavey nganpi. All rights reserved.
//

#import "SpeakInstagramConnectViewController.h"

@interface SpeakInstagramConnectViewController ()
@end

@implementation SpeakInstagramConnectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView* mywebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *fullURL = @"https://instagram.com/oauth/authorize/?client_id=1f1810dd1d3d44ca9ed21d0567f615d4&redirect_uri=http://instagram.com&response_type=token";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mywebview loadRequest:requestObj];
    mywebview.delegate = self;
    [self.view addSubview:mywebview];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    NSLog(@"URL STRING : %@ ",urlString);
    NSArray *UrlParts = [urlString componentsSeparatedByString:[NSString stringWithFormat:@"%@/",@"http://instagram.com"]];
    if ([UrlParts count] > 1) {
        // do any of the following here
        urlString = [UrlParts objectAtIndex:1];
        NSRange accessToken = [urlString rangeOfString: @"#access_token="];
        if (accessToken.location != NSNotFound) {
            NSString* strAccessToken = [urlString substringFromIndex: NSMaxRange(accessToken)];
           #define KACCESS_TOKEN ”access_token” in contant
           [[NSUserDefaults standardUserDefaults] setValue:strAccessToken forKey: @"access_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"AccessToken = %@ ",strAccessToken);
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self loadRequestForMediaData];
        }
        return NO;
    }
    return YES;
}

-(void)loadRequestForMediaData {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/3/media/recent/?access_token=%@",@"https://api.instagram.com/v1/users/",[[ NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]]];
    // Here you can handle response as well
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"Response : %@",dictResponse);
}


@end
