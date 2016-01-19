//
//  DataViewController.h
//  wcapi
//
//  Created by 吴忠信 on 16/1/7.
//  Copyright © 2016年 吴忠信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeCenterClientApi.h"

@interface DataViewController : UIViewController

@property (nonatomic, copy) WeCenterClientApi * api;

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
- (IBAction)myButtonClick:(id)sender;

@end

