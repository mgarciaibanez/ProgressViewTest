//
//  DownloadWithAFViewController.h
//  ProgressViewTest
//
//  Created by mgarciaibanez on 30/01/14.
//  Copyright (c) 2014 mgarciaibanez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadWithAFViewController : UIViewController <UIAlertViewDelegate>

//Caller view Controller
@property (nonatomic, readonly) UIViewController *callerViewController;

/*Function to add button, progressview and functionality to the caller*/
-(id)initWithRootViewControllerAndUrl:(UIViewController *)callerViewController url2Download:(NSString *)url2Download downloadMessage:(NSString *)downloadMessage downloadCancelMessage:(NSString *)downloadCancelMessage downloadOkMessage:(NSString *)downloadOkMessage cancelDownloadMessage:(NSString *)cancelDownloadMessage cancelDownloadOkMessage:(NSString *)cancelDownloadOkMessage cancelDownloadCancelMessage:(NSString *)cancelDownloadCancelMessage parametersDict:(NSDictionary *) parametersDict;
@end
