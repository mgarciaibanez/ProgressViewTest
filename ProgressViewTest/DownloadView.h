//
//  DownloadVC.h
//  ProgressViewTest
//
//  Created by mgarciaibanez on 27/11/13.
//  Copyright (c) 2013 mgarciaibanez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadView : UIViewController <NSURLSessionDelegate,UIAlertViewDelegate>

@property (nonatomic,weak) NSString *url2Download;
@property (nonatomic,strong) UIViewController *originVC;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

-(id)initWithUrl:(NSString *) url2Download;
@end
