//
//  DownloadViewController.m
//  ProgressViewTest
//
//  Created by mgarciaibanez on 13/12/13.
//  Copyright (c) 2013 mgarciaibanez. All rights reserved.
//

#import "DownloadViewController.h"
#import "DAProgressOverlayView.h"


NSString *const kDownloadMessage = @"Download the file";
NSString *const kDownloadCancelMessage = @"Cancel";
NSString *const kDownloadOkMessage = @"OK";
NSString *const kCancelDownloadMessage = @"Cancel Download";
NSString *const kCancelDownloadOkMessage = @"OK";
NSString *const kCancelDownloadCancelMessage = @"Cancel";

@interface DownloadViewController ()
@property (weak,nonatomic) NSString *urlDownload;
@property (strong,nonatomic) NSURL *urlObject;
@property (nonatomic,strong) DAProgressOverlayView *progressOverlayView;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (weak,nonatomic) NSString *DownloadMessage, *CancelDownloadMessage, *DownloadOkMessage, *DownloadCancelMessage, *CancelDownloadOkMessage, *CancelDownloadCancelMessage;
@end

@implementation DownloadViewController

@synthesize callerViewController = _callerViewController;
@synthesize urlObject = _urlObject;
@synthesize DownloadMessage = _DownloadMessage; //Message to show when the user taps on download the book and download has not been started
@synthesize DownloadCancelMessage = _DownloadCancelMessage; //Text for Download Cancel Button
@synthesize DownloadOkMessage = _DownloadOkMessage; //Text for Download Ok button
@synthesize CancelDownloadMessage = _CancelDownloadMessage; //Message to show if download process is running and user taps on the image
@synthesize CancelDownloadOkMessage = _CancelDownloadOkMessage; //Text for Cancel Ok button
@synthesize CancelDownloadCancelMessage = _CancelDownloadCancelMessage; //Text for Cancel Download Cancel it will make the view controller keep downloading


-(UIViewController *)callerViewController{
    return _callerViewController;
}

/*Function to init the ViewController sending the requester viewController and the url2Download*/
-(id)initWithRootViewControllerAndUrl:(UIViewController *)callerViewController url2Download:(NSString *)url2Download downloadMessage:(NSString *)downloadMessage downloadCancelMessage:(NSString *)downloadCancelMessage downloadOkMessage:(NSString *)downloadOkMessage cancelDownloadMessage:(NSString *)cancelDownloadMessage cancelDownloadOkMessage:(NSString *)cancelDownloadOkMessage cancelDownloadCancelMessage:(NSString *)cancelDownloadCancelMessage{
    self = [super init];
    if (self){
        //Setting texts
        if (!downloadMessage || [downloadMessage isEqualToString:@""]) _DownloadMessage = kDownloadMessage;
        if (!downloadCancelMessage || [downloadCancelMessage isEqualToString:@""]) _DownloadCancelMessage = kDownloadCancelMessage;
        if (!downloadOkMessage || [downloadOkMessage isEqualToString:@""]) _DownloadOkMessage = kDownloadOkMessage;
        if (!cancelDownloadMessage || [cancelDownloadMessage isEqualToString:@""]) _CancelDownloadMessage = kCancelDownloadMessage;
        if (!cancelDownloadCancelMessage|| [cancelDownloadCancelMessage isEqualToString:@""]) _CancelDownloadCancelMessage = kCancelDownloadCancelMessage;
        if (!cancelDownloadOkMessage || [cancelDownloadOkMessage isEqualToString:@""]) _CancelDownloadOkMessage = kCancelDownloadOkMessage;
        //Mandatory to send viewControllers with views
        if (!callerViewController.view)
            return nil;
        //Mandatory to send url2Download
        if (!url2Download || [url2Download isEqualToString:@""])
            return nil;
        
        //Caller view controller staff
        _callerViewController = callerViewController;
        _callerViewController.view.layer.masksToBounds = YES;
        _callerViewController.view.layer.cornerRadius = 35.;
        _callerViewController.view.alpha = 0.5;
        
        //Adding button to handle user interaction
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(tapAction:)
         forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(0, 0, _callerViewController.view.frame.size.width, _callerViewController.view.frame.size.height);
        [_callerViewController.view addSubview:button];
        
        _urlDownload = url2Download;
        //Do initialization staff such as adding progressOverview
        //Session staff
        //Start with URLSession
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //Create session
        //Assign a delegate (NSURLDownloadDelegate we can track file download
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];
        _urlObject = [NSURL URLWithString:_urlDownload];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setting Button Behaviour
-(void) tapAction:(UIButton *)sender{
    /*
     This function handle button behaviour, it should use strings sent as parameters
     */
    if (self.progressOverlayView.progress == 0.){
        //Download still not started we have to start the download
        UIAlertView *alertDownload = [[UIAlertView alloc]initWithTitle:@"Download button" message:@"Download the file?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alertDownload setTag:1];
        [alertDownload show];
    }
    
}

#pragma mark - Tap Gesture recognizer
-(void) doSingleTap:(UITapGestureRecognizer *) sender{
    /*Function to handle download while the file is being downloaded*/
    if (_callerViewController.view.alpha < 1.0 || self.progressOverlayView.progress<1.0){
        //file stil downloading
        if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
            [self.downloadTask suspend];
        }
        UIAlertView *alertProgress = [[UIAlertView alloc]initWithTitle:@"Set Download" message:@"Cancel Download?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alertProgress setTag:2];
        [alertProgress show];
    }
}

#pragma mark - progressView management
- (void)updateProgress:(double) currentProgress
{
    CGFloat progress = (float) currentProgress;
    if (progress >= 1) {
        [self.progressOverlayView displayOperationDidFinishAnimation];
        self.progressOverlayView.progress = 0.;
        self.progressOverlayView.hidden = YES;
        _callerViewController.view.alpha = 1.0;
        UIView *progressViewToRemove = [_callerViewController.view viewWithTag:100];
        [progressViewToRemove removeFromSuperview]; //Remove progressView
        self.progressOverlayView = nil; //Remove progressOverview
        self.downloadTask = nil; //Remove DownloadTask
    } else {
        self.progressOverlayView.progress = progress;
    }
}

/*Add progressOverlay view to caller view and add a TapGestureRecognizer*/
- (void) createAndAddProgressView{
    if (!self.progressOverlayView){
        self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:_callerViewController.view.bounds];
        [self.progressOverlayView setTag:100];
        [_callerViewController.view addSubview:self.progressOverlayView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self.progressOverlayView addGestureRecognizer:singleTap];
    }
    
}

#pragma mark - Session Handler
/*Metod to update progress view while downloading*/
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    double currentProgress = (double) totalBytesWritten/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgress:currentProgress];
    });
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *path =[documentsDirectory stringByAppendingPathComponent:@"test.zip"];
    NSData *dataGet = [NSData dataWithContentsOfURL:location];
    [dataGet writeToFile:path atomically:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update
    });
}

#pragma mark - Alert View Delegate
/*Alert view delegate to show when the user taps on the view*/
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    if (alertView.tag == 1){
        //The first time the view is tapped to start download
        if (buttonIndex > 0) {
            //Create the progress view if it does not exists
            [self createAndAddProgressView];
            //Download task
            if (!self.downloadTask) {
                self.downloadTask = [self.session downloadTaskWithURL:_urlObject];
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    self.sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.EFL.downloadVC"];
                    self.sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
                    //NSURL *url = [NSURL URLWithString:_urlDownload];
                    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:_urlDownload]];
                    NSLog(@"Session task state: %d", self.downloadTask.state);
                    [self.downloadTask resume];
                });
                
                return;
            }
            //It should never happen
            if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
                [self.downloadTask resume];
            } else if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
                [self.downloadTask suspend];
            }
        }
    }else if (alertView.tag == 2){
        //Process while downloading
        if (buttonIndex == 0){
            if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
                [self.downloadTask resume];
            }
        }else{
            //User wants to stop the download
            if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
                [self.downloadTask cancel];//Cancel download
                //Set everything as if it has not been started
                UIView *progressViewToRemove = [_callerViewController.view viewWithTag:100];
                [progressViewToRemove removeFromSuperview]; //Remove progressView
                self.progressOverlayView = nil; //Remove progressOverview
                self.downloadTask = nil; //Remove DownloadTask
                [self.progressOverlayView removeFromSuperview];
                if (_callerViewController.view.alpha == 1.0) _callerViewController.view.alpha = 0.5; //ImageViewAlpha
            }
        }
    }
    
}

@end
