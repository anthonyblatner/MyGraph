//
//  MGViewController.m
//  MyGraph
//
//  Created by Anthony Blatner on 10/23/12.
//  Copyright (c) 2012 AMB Software. All rights reserved.
//

#import "MGViewController.h"

@interface MGViewController () <UIScrollViewDelegate>

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    MGGraphView *myGraphView = [[MGGraphView alloc] initWithFrame:CGRectMake(0, 0, 900, 300)];
    
    [myScrollView addSubview:myGraphView];
    [self.view addSubview:myScrollView];
    
    myScrollView.userInteractionEnabled = YES;
    myScrollView.scrollEnabled = YES;
    myGraphView.userInteractionEnabled = YES;
    myScrollView.contentSize = CGSizeMake(900, 300);
    
    myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
//    DLog(@"\n self.scrollView: %@\n self.graphView: %@", self.scrollView, self.graphView);
//    self.scrollView.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight);
//    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{    
    DLog(@"");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DLog(@"");
}

@end
