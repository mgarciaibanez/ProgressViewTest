//
//  ViewController.m
//  ProgressViewTest
//
//  Created by mgarciaibanez on 21/11/13.
//  Copyright (c) 2013 mgarciaibanez. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DAProgressOverlayView.h"
#import "DownloadView.h"
#import "AFNetworking.h"
@interface ViewController ()
@property (strong,nonatomic) DownloadView *viewTest1;
@property (strong,nonatomic) DownloadView *viewTest2;
@property (strong,nonatomic) NSOperationQueue *myQueue;
@property (strong,nonatomic) UIProgressView *myProgressView;
@property (nonatomic) NSUInteger totalOperations;
@end

@implementation ViewController

@synthesize viewTest1 = _viewTest1;
@synthesize viewTest2 = _viewTest2;
@synthesize myQueue = _myQueue;
@synthesize myProgressView = _myProgressView;
@synthesize totalOperations = _totalOperations;
//downloadView setNeedsDisplay...

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalOperations = 0;
    //http://srvmov03:8080/Aim20/getBookMetaData?login=desa&pwd=desar&countryId=ES&mementoId=IMF
    
    //ProgressView
    self.myProgressView = [[UIProgressView alloc] init];
    self.myProgressView.frame = CGRectMake(100,100,400,20);
    [self.view addSubview:self.myProgressView];

    
    
    NSURLRequest *request4Operation = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://srvmov03:8080/Aim20/getBookMetaData?login=desa&pwd=desar&countryId=ES&mementoId=IMF"]];
    
    
    //NSURLRequest *request4Operation = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://srvmov03:8080/Aim20/getBook.action?login=desa&pwd=desar&udid=a3fae45d4219f86a177f1ff58b05564439a9a58b&countryId=fr&codMemento=mf&lastUpdate=2012-11-26"]];
    
    
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request4Operation];
    request4Operation = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://srvmov03:8080/Aim20/getBookMetaData?login=desa&pwd=desar&countryId=ES&mementoId=IMIV"]];
    //request4Operation = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://srvmov03:8080/Aim20/getBook.action?login=desa&pwd=desar&udid=a3fae45d4219f86a177f1ff58b05564439a9a58b&countryId=fr&codMemento=mf&lastUpdate=2012-11-26"]];
    
    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request4Operation];
    AFHTTPRequestOperation *operation3 = [[AFHTTPRequestOperation alloc] initWithRequest:request4Operation];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *fullPath1 = [documentsDirectory stringByAppendingPathComponent:@"test1.zip"];
    NSString *fullPath2 = [documentsDirectory stringByAppendingPathComponent:@"test2.zip"];
    NSString *fullPath3 = [documentsDirectory stringByAppendingPathComponent:@"test3.zip"];

    [operation1 setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath1 append:NO]];
    [operation2 setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath2 append:NO]];
    [operation3 setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath3 append:NO]];
    //Set the whole download progress view for each operation
    self.myQueue = [[NSOperationQueue alloc] init];
    
    [self.myQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    // This creates basically a serial queue, since there is just on operation running at any time.
    [self.myQueue setMaxConcurrentOperationCount:1];
    self.totalOperations++;
    self.totalOperations++;
    self.totalOperations++;
    [self.myQueue addOperation:operation1];
    [self.myQueue addOperation:operation2];
    [self.myQueue addOperation:operation3];
    //Here set it up to download metadata
}

//To update everything

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"It comes");
    if (object == self.myQueue && [keyPath isEqualToString:@"operations"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float currentProgress = (float)self.totalOperations - self.myQueue.operationCount;
            self.myProgressView.progress = (float)currentProgress / self.totalOperations;
        });
        if (self.myQueue.operationCount == 0) {
            //NSLog(@"queue has completed");
            [self addViews2SuperView];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark adding books to view

-(void) addViews2SuperView{
    self.viewTest1 = [[DownloadView alloc] initWithUrl:@"http://srvmov03:8080/Aim20/getBook.action?login=desa&pwd=desar&udid=a3fae45d4219f86a177f1ff58b05564439a9a58b&countryId=fr&codMemento=mf&lastUpdate=2012-11-26"];
    self.viewTest1.view.frame = CGRectMake(0,0,200,200);
    self.viewTest1.view.userInteractionEnabled = YES;
    self.viewTest1.view.tag = 1;
    [self.view addSubview:self.viewTest1.view];
    
    
    self.viewTest2 = [[DownloadView alloc] initWithUrl:@"http://srvmov03:8080/Aim20/getBook.action?login=desa&pwd=desar&udid=a3fae45d4219f86a177f1ff58b05564439a9a58b&countryId=fr&codMemento=mf&lastUpdate=2012-11-26"];
    self.viewTest2.view.frame = CGRectMake(0,210,200,200);
    self.viewTest2.view.userInteractionEnabled = YES;
    self.viewTest2.view.tag = 2;
    [self.view addSubview:self.viewTest2.view];
    
    
    [UIView animateWithDuration:0.9
                     animations:^{self.myProgressView.alpha = 0.0;}
                     completion:^(BOOL finished){ [self.myProgressView removeFromSuperview]; }];

}

@end
