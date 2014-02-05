//
//  DownloadWithAFViewController.m
//  ProgressViewTest
//
//  Created by mgarciaibanez on 30/01/14.
//  Copyright (c) 2014 mgarciaibanez. All rights reserved.
//

#import "DownloadWithAFViewController.h"
#import "DAProgressOverlayView.h"
#import "AFNetworking.h"



NSString *DownloadMessage = @"Download the file";
NSString *DownloadCancelMessage = @"Cancel";
NSString *DownloadOkMessage = @"OK";
NSString *CancelDownloadMessage = @"Cancel Download";
NSString *CancelDownloadOkMessage = @"OK";
NSString *CancelDownloadCancelMessage = @"Cancel";

@interface DownloadWithAFViewController ()
@property (weak,nonatomic) NSString *urlDownload;
@property (strong,nonatomic) NSURL *urlObject;
@property (nonatomic,strong) DAProgressOverlayView *progressOverlayView;
@property (nonatomic,strong) AFHTTPRequestOperation *downloadOperation;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (weak,nonatomic) NSString *DownloadMessage, *CancelDownloadMessage, *DownloadOkMessage, *DownloadCancelMessage, *CancelDownloadOkMessage, *CancelDownloadCancelMessage;
@end

@implementation DownloadWithAFViewController

@synthesize callerViewController = _callerViewController;
@synthesize urlObject = _urlObject;
@synthesize DownloadMessage = _DownloadMessage; //Message to show when the user taps on download the book and download has not been started
@synthesize DownloadCancelMessage = _DownloadCancelMessage; //Text for Download Cancel Button
@synthesize DownloadOkMessage = _DownloadOkMessage; //Text for Download Ok button
@synthesize CancelDownloadMessage = _CancelDownloadMessage; //Message to show if download process is running and user taps on the image
@synthesize CancelDownloadOkMessage = _CancelDownloadOkMessage; //Text for Cancel Ok button
@synthesize CancelDownloadCancelMessage = _CancelDownloadCancelMessage; //Text for Cancel Download Cancel it will make the view controller keep downloading
@synthesize downloadOperation = _downloadOperation;

-(UIViewController *)callerViewController{
    return _callerViewController;
}

/*Function to init the ViewController sending the requester viewController and the url2Download*/
-(id)initWithRootViewControllerAndUrl:(UIViewController *)callerViewController url2Download:(NSString *)url2Download downloadMessage:(NSString *)downloadMessage downloadCancelMessage:(NSString *)downloadCancelMessage downloadOkMessage:(NSString *)downloadOkMessage cancelDownloadMessage:(NSString *)cancelDownloadMessage cancelDownloadOkMessage:(NSString *)cancelDownloadOkMessage cancelDownloadCancelMessage:(NSString *)cancelDownloadCancelMessage parametersDict:(NSDictionary *) parametersDict{
    self = [super init];
    if (self){
        //Setting texts
        if (!downloadMessage || [downloadMessage isEqualToString:@""]) _DownloadMessage = DownloadMessage;
        if (!downloadCancelMessage || [downloadCancelMessage isEqualToString:@""]) _DownloadCancelMessage = DownloadCancelMessage;
        if (!downloadOkMessage || [downloadOkMessage isEqualToString:@""]) _DownloadOkMessage = DownloadOkMessage;
        if (!cancelDownloadMessage || [cancelDownloadMessage isEqualToString:@""]) _CancelDownloadMessage = CancelDownloadMessage;
        if (!cancelDownloadCancelMessage|| [cancelDownloadCancelMessage isEqualToString:@""]) _CancelDownloadCancelMessage = CancelDownloadCancelMessage;
        if (!cancelDownloadOkMessage || [cancelDownloadOkMessage isEqualToString:@""]) _CancelDownloadOkMessage = CancelDownloadOkMessage;
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
        //Assign a delegate (NSURLDownloadDelegate we can track file download
        _urlObject = [NSURL URLWithString:_urlDownload];
        NSURLRequest *request = [NSURLRequest requestWithURL:_urlObject];
        _downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    }
    //NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //[operationQueue addOperation:operation]; It will start just after it goes
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
        if (self.downloadOperation.isExecuting){
            [self.downloadOperation pause];
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

#pragma mark - Alert View Delegate
/*Alert view delegate to show when the user taps on the view*/
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    if (alertView.tag == 1){
        //The first time the view is tapped to start download
        if (buttonIndex > 0) {
            //Create the progress view if it does not exists
            [self createAndAddProgressView];
            if (!_downloadOperation){
                NSURLRequest *request = [NSURLRequest requestWithURL:_urlObject];
                _downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            }
            __weak typeof(self) weakSelf = self;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory =[paths objectAtIndex:0];
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"test.zip"];
            [_downloadOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
            
            [_downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                //NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
                dispatch_async(dispatch_get_main_queue(), ^{
                    float currentProgress = (float) totalBytesRead/totalBytesExpectedToRead;
                    CGFloat progress = currentProgress;
                    if (progress >= 1) {
                        [weakSelf.progressOverlayView displayOperationDidFinishAnimation];
                        weakSelf.progressOverlayView.progress = 0.;
                        weakSelf.progressOverlayView.hidden = YES;
                        weakSelf.callerViewController.view.alpha = 1.0;
                        UIView *progressViewToRemove = [weakSelf.callerViewController.view viewWithTag:100];
                        [progressViewToRemove removeFromSuperview]; //Remove progressView
                        weakSelf.progressOverlayView = nil; //Remove progressOverview
                        weakSelf.downloadOperation = nil; //Remove DownloadTask
                    } else {
                        weakSelf.progressOverlayView.progress = progress;
                    }
                });
            }];
            [_downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
                NSError *error;
                NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
                if (error) {
                    NSLog(@"ERR: %@", [error description]);
                } else {
                    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    long long fileSize = [fileSizeNumber longLongValue];
                    NSLog(@"File downloaded with %lld bytes",fileSize);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERR: %@", [error description]);
            }];
            [_downloadOperation start];
            //Download task
        }
    }else if (alertView.tag == 2){
        //Process while downloading
        if (buttonIndex == 0){
            if (self.downloadOperation.isPaused){
                [self.downloadOperation resume];
            }
        }else{
            //User wants to stop the download
            //if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
            if (self.downloadOperation.isPaused) {
                [self.downloadOperation cancel];
                UIView *progressViewToRemove = [_callerViewController.view viewWithTag:100];
                [progressViewToRemove removeFromSuperview]; //Remove progressView
                self.progressOverlayView = nil; //Remove progressOverview
                self.downloadOperation = nil; //Remove DownloadTask
                [self.progressOverlayView removeFromSuperview];
                if (_callerViewController.view.alpha == 1.0) _callerViewController.view.alpha = 0.5; //ImageViewAlpha
            }
        }
    }
    
}



@end
