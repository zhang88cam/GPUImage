//
//  KernelViewController.m
//  FilterShowcase
//
//  Created by Qiuhao Zhang on 4/26/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "KernelViewController.h"
#import "ShowcaseFilterViewController.h"

@interface KernelViewController ()
{
    NSArray *textFieldArray;
}

@end

@implementation KernelViewController
@synthesize leftTopTextField;
@synthesize middleTopTextField;
@synthesize rightTopTextField;
@synthesize leftMiddleTextField;
@synthesize middleMiddleTextField;
@synthesize rightMiddleTextField;
@synthesize leftBottomTextField;
@synthesize middleBottomTextField;
@synthesize rightBottomTextField;
@synthesize filterType;
@synthesize defaultFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Button Action
-(IBAction)done:(id)sender
{
    NSMutableArray *kernel = [[NSMutableArray alloc] initWithCapacity:9];
    for (UITextField *textField in textFieldArray) {
        float kernelNum = [textField.text floatValue];
        [kernel addObject:[NSNumber numberWithFloat:kernelNum]];
    }
//    NSLog(@"%@", kernel);
    ShowcaseFilterViewController *filterViewController = [[ShowcaseFilterViewController alloc] initWithFilterType:filterType];
    filterViewController.customKernel = kernel;
    [self.navigationController pushViewController:filterViewController animated:YES];
}

-(void)setupKeyboardType
{
    for (UITextField *textField in textFieldArray) {
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
}
-(void)setupDefaultFilter
{
    for (int i = 0; i < [textFieldArray count]; i ++) {
        UITextField *textField = [textFieldArray objectAtIndex:i];
        textField.text = [NSString stringWithFormat:@"%.1f", [[defaultFilter objectAtIndex:i] floatValue]];
    }
}

#pragma mark - Lift Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Kernel";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    textFieldArray = [[NSArray alloc] initWithObjects:leftTopTextField, middleTopTextField,rightTopTextField,
                      leftMiddleTextField, middleMiddleTextField, rightMiddleTextField,
                      leftBottomTextField, middleBottomTextField, rightBottomTextField,
                      nil];
    [self setupDefaultFilter];
    [self setupKeyboardType];
}

- (void)viewDidUnload
{
    [self setLeftTopTextField:nil];
    [self setMiddleTopTextField:nil];
    [self setRightTopTextField:nil];
    [self setLeftMiddleTextField:nil];
    [self setMiddleMiddleTextField:nil];
    [self setRightMiddleTextField:nil];
    [self setLeftBottomTextField:nil];
    [self setMiddleBottomTextField:nil];
    [self setRightBottomTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
