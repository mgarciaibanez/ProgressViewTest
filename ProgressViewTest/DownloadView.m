//
//  DownloadVC.m
//  ProgressViewTest
//
//  Created by mgarciaibanez on 27/11/13.
//  Copyright (c) 2013 mgarciaibanez. All rights reserved.
//

#import "DownloadView.h"
//#import "DownloadViewController.h"
#import "DownloadWithAFViewController.h"

@interface DownloadView()
//@property (strong,nonatomic) DownloadViewController *downloadViewController;
@property (strong,nonatomic) DownloadWithAFViewController *downloadViewController;
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@end

@implementation DownloadView
@synthesize url2Download = _url2Download;
@synthesize downloadViewController = _downloadViewController;
@synthesize operationQueue = _operationQueue;

//@synthesize downloadButton = _downloadButton;
//@synthesize originVC = _originVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization @"DownloadView"
    }
    return self;
     
}


-(id)initWithUrl:(NSString *) url2Download{
    _url2Download = url2Download;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.downloadViewController = [[DownloadViewController alloc] initWithRootViewControllerAndUrl:self ur2Download:_url2Download downloadMessage:@"" downloadCancelMessage:@"" downloadOkMessage:@"" cancelDownloadMessage:@"" cancelDownloadOkMessage:@"" cancelDownloadCancelMessage:@""];
    
    //self.downloadViewController =[[DownloadViewController alloc] initWithRootViewControllerAndUrl:self url2Download:_url2Download downloadMessage:@"" downloadCancelMessage:@"" downloadOkMessage:@"" cancelDownloadMessage:@"" cancelDownloadOkMessage:@"" cancelDownloadCancelMessage:@""];
    self.downloadViewController =[[DownloadWithAFViewController alloc] initWithRootViewControllerAndUrl:self url2Download:_url2Download downloadMessage:@"" downloadCancelMessage:@"" downloadOkMessage:@"" cancelDownloadMessage:@"" cancelDownloadOkMessage:@"" cancelDownloadCancelMessage:@"" parametersDict:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.}
}
@end
