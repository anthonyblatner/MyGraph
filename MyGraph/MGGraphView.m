//
//  MGGraphView.m
//  MyGraph
//
//  Created by Anthony Blatner on 10/23/12.
//  Copyright (c) 2012 AMB Software. All rights reserved.
//

#import "MGGraphView.h"

@implementation MGGraphView

float data_bar[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77};
float data_line[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};

CGRect touchAreas[kNumberOfBars];


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    DLog(@"rect: (%.02f,%.02f), width: %.02f, height: %.02f",
         rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw background image
    UIImage *image = [UIImage imageNamed:@"graph-background.png"];
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, imageRect, image.CGImage);
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // How many lines?
    int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash

    [self drawBarGraphWithContext:context];
    [self drawLineGraphWithContext:context];

    // Invert the matrix
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    
    // Drawing text
    CGContextSelectFont(context, "Helvetica", 44, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    NSString *theText = @"Hi there!";
    CGContextShowTextAtPoint(context, 100, 100, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    
//    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for (int i = 1; i < sizeof(data_line); i++)
    {
        NSString *theText = [NSString stringWithFormat:@"%d", i];
        CGSize labelSize = [theText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX - labelSize.width/2, kGraphBottom - 5, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
}

- (void)drawBarGraphWithContext:(CGContextRef)context
{
    // Draw the bars
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    for (int i = 0; i < kNumberOfBars; i++){
       float barX = kOffsetX + kStepX + i * kStepX - kBarWidth / 2;
       float barY = kBarTop + maxBarHeight - maxBarHeight * data_bar[i];
       float barHeight = maxBarHeight * data_bar[i];
       CGRect barRect = CGRectMake(barX, barY, kBarWidth, barHeight);
       [self drawBar:barRect context:context];
        touchAreas[i] = barRect;
    }
   
}

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    DLog(@"rect: (%.02f %.02f; %.02f %.02f)",
         rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGContextBeginPath(ctx);

    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextClosePath(ctx);
    
    // Save the current state before clipping, for later restoration
    CGContextSaveGState(ctx);
    // Clip all future drawing to the already drawn area
    CGContextClip(ctx);

    // Fill the initial rectangle
//    CGContextFillPath(ctx);
    
    // Prepare the resources
    CGFloat components[12] = {  0.2314, 0.5686, 0.4000, 1.0,  // Start color
                                0.4727, 1.0000, 0.8157, 1.0, // Second color
                                0.2392, 0.5686, 0.4118, 1.0}; // End color
    
    CGFloat locations[3] = {0.0, 0.33, 1.0};
    size_t num_locations = 3;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint = rect.origin;
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    // Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    // Restore state to remove clipping restriction
    CGContextRestoreGState(ctx);

    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    DLog(@"");
    
    // Draw gradient
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.5, 0.0, 0.2,  // Start color
        1.0, 0.5, 0.0, 1.0}; // End color
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint, endPoint;
    startPoint.x = kOffsetX;
    startPoint.y = kGraphHeight;
    endPoint.x = kOffsetX;
    endPoint.y = kOffsetY;
    
    // Draw graph
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    // Set graph fill color
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);

    // Draw line graph
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data_line[0]);
    for (int i = 1; i < sizeof(data_line); i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data_line[i]);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (sizeof(data_line) - 1) * kStepX, kGraphHeight);
//    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);

    // Draw gradient
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data_line[0]);
    for (int i = 1; i < sizeof(data_line); i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data_line[i]);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (sizeof(data_line) - 1) * kStepX, kGraphHeight);
    CGContextClosePath(ctx);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    // Restore state and cleanup
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    // Draw larger circles over the data points
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
    for (int i = 1; i < sizeof(data_line) - 1; i++)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data_line[i];
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
    }
    CGContextDrawPath(ctx, kCGPathFill);

}

- (UIView *)pointerView
{
    if (!_pointerView) {
        _pointerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.0, self.frame.size.height)];
        _pointerView.backgroundColor = [UIColor redColor];
    }
    
    return _pointerView;
}

- (void)setPointerViewToPoint:(CGPoint)point
{
    if (self.pointerView.superview != self) {
        [self.pointerView removeFromSuperview];
        [self addSubview:self.pointerView];
    }
    
    DLog(@"point: (%.02f %.02f)", point.x, point.y);
    CGRect frame = self.pointerView.frame;
    frame.origin.x = point.x;
    self.pointerView.frame = frame;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    DLog(@"touch (%.02f %.02f)", point.x, point.y);
    
    for (int i = 0; i < kNumberOfBars; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            DLog(@"tapped a bar with index %d, value %f", i, data_bar[i]);
            break;
        }
    }
    
    [self setPointerViewToPoint:point];
}


// We don't see the effects of this method because
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    DLog(@"touch (%.02f %.02f)", point.x, point.y);
    [self setPointerViewToPoint:point];
}

@end
