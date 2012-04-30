//
//  KernelViewController.h
//  FilterShowcase
//
//  Created by Qiuhao Zhang on 4/26/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KernelViewController : UIViewController
{
    NSInteger filterType;
    NSArray *defaultFilter;
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *leftTopTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *middleTopTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *rightTopTextField;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *leftMiddleTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *middleMiddleTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *rightMiddleTextField;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *leftBottomTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *middleBottomTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *rightBottomTextField;
@property (nonatomic, readwrite) NSInteger filterType; 
@property (nonatomic, retain) NSArray *defaultFilter;

@end
