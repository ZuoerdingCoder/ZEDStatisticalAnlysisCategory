//
//  ViewController.m
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#import "ViewController.h"
#import "ZEDStatisticalAnlysisCategoryConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"APP响应事件数据统计";
    [self addObserver];
}

- (void)dealloc {
    NSLog(@"ViewController dealloc");
    [self removeObserver];
}

#pragma mark - Observer
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStatisticAnalysisData:) name:ZEDStatisticAnalysisNotificationName object:nil];
}

#pragma mark - Notification
- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZEDStatisticAnalysisNotificationName object:nil];
}

- (void)showStatisticAnalysisData:(NSNotification *)sender {
    NSDictionary *dict = (NSDictionary *)sender.object;
    NSLog(@"Statistic AnalysisData:%@",dict);
}

#pragma mark - Actions
- (IBAction)clickButtonAction:(UIButton *)sender {
    
}

- (IBAction)switchChanged:(UISwitch *)sender {
    
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    
}

- (IBAction)segumentValueChanged:(UISegmentedControl *)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
