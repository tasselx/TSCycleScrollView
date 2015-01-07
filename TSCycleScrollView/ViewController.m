//
//  ViewController.m
//  TSCycleScrollView
//
//  Created by Tassel on 15/1/6.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import "ViewController.h"
#import "TSCycleScrollView.h"

@interface ViewController ()<TSCycleScrollViewDelegate,TSCycleScrollViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
     
     TSCycleScrollView *csView = [[TSCycleScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 350)];
     csView.delegate = self;
     csView.dataSource = self;
     csView.animationDuration = 1.0f;
     [self.view addSubview:csView];
    
    
   
}

-(NSInteger)numberOfPages
{
    return 5;
}


- (UIView *)pageAtIndex:(NSInteger)index size:(CGSize)size
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width-20, size.height)];
    label.backgroundColor = [UIColor brownColor];
    label.font = [UIFont systemFontOfSize:100.f];
    label.text = [NSString stringWithFormat:@"%li",(long)index];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    view.tag = index;
    return view;
}

- (void)scrollView:(TSCycleScrollView *)scrollView didClickPage:(UIView *)view atIndex:(NSInteger)index
{
    NSLog(@"tag:%li",(long)view.tag);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"%li",(long)index]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
