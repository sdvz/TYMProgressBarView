//
//  ViewController.m
//  TYMProgressBarViewDemo
//
//  Created by Sage De Vaz on 2017-08-18.
//  Copyright © 2017 Morph Media. All rights reserved.
//

#import "ViewController.h"
#import "TYMProgressBarView.h"

@interface ViewController ()
@property (strong, nonatomic) TYMProgressBarView *pb;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pb = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(16, 100, 300, 50)];
    self.pb.barFillColor = [UIColor whiteColor];
    self.pb.barBackgroundColor = [UIColor blackColor];
    self.pb.progress = 0.0;
    self.pb.showLabel = YES;
    [self.view addSubview:self.pb];
    
    [self performSelector:@selector(changeProgress) withObject:nil afterDelay:3];
}

- (void)changeProgress {
    self.pb.progress = 0.75;
    self.pb.labelColor = [UIColor grayColor];
    self.pb.labelFont = [UIFont systemFontOfSize:8.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
