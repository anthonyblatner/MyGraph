//
//  MGGraphView.h
//  MyGraph
//
//  Created by Anthony Blatner on 10/23/12.
//  Copyright (c) 2012 AMB Software. All rights reserved.
//

#import <UIKit/UIKit.h>

// Graph Dimensions
#define kGraphHeight 300
#define kDefaultGraphWidth 900

// Graph Locations
#define kGraphBottom 300
#define kGraphTop 0

// X
#define kOffsetX 00
#define kStepX 50

// Y
#define kStepY 50
#define kOffsetY 10

// Bar
#define kBarTop 10
#define kBarWidth 40
#define kNumberOfBars 12

// Line
#define kCircleRadius 3


@interface MGGraphView : UIView

@property (nonatomic, strong) UIView *pointerView;

@end