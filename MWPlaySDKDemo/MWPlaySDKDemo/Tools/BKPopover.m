//
//  YZPopover.m
//  
//
//  Created by yun on 13-3-26.
//
//

#import "BKPopover.h"

@interface BKPopover ()
{
    UILabel *textLabel;
    UIImageView *thumbnailView;
    UIActivityIndicatorView *loadIndicator;
}


@end

@implementation BKPopover

#pragma mark - lifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.layer.opaque = YES;
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, frame.size.width, 16)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setFont:[UIFont systemFontOfSize:12]];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [textLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:textLabel];
        
        thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(4, textLabel.frame.size.height + 4, frame.size.width - 8, frame.size.height - textLabel.frame.size.height - 14)];
        [thumbnailView setBackgroundColor:[UIColor clearColor]];
        thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:thumbnailView];
        
        loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadIndicator setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
        [self addSubview:loadIndicator];
    }
    
    return self;
}

- (void)dealloc
{
    [self hideIndicatorAnimate];
    textLabel = nil;
    thumbnailView = nil;
    loadIndicator = nil;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect
{
    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Color Declarations
    UIColor *gradientColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:0.5];
    UIColor *gradientColor2 = [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:0.5];
    
    // Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:(id)gradientColor.CGColor, (id)gradientColor2.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    // Frames
    CGRect frame = self.bounds;
    CGRect frame2 = CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 11) * 0.51724 + 0.5), CGRectGetMinY(frame) + CGRectGetHeight(frame) , 11, 9);
    
    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 4.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 11.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 4.5, CGRectGetMaxY(frame) - 7.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 9.29) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 2.29, CGRectGetMaxY(frame) - 7.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 10.64, CGRectGetMinY(frame2) + 1.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 5.5, CGRectGetMinY(frame2) + 8)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 0.36, CGRectGetMinY(frame2) + 1.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 4.5, CGRectGetMaxY(frame) - 7.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 11.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.29, CGRectGetMaxY(frame) - 7.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 9.29)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 4.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.5, CGRectGetMinY(frame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.29, CGRectGetMinY(frame) + 0.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 4.5, CGRectGetMinY(frame) + 0.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 4.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 2.29, CGRectGetMinY(frame) + 0.5) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 2.29)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    [bezierPath addClip];
    CGRect bezierBounds = bezierPath.bounds;
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMinY(bezierBounds)),
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                0);
    CGContextRestoreGState(context);
    
    // Bezier Inner Shadow
    UIColor* innerShadow = [UIColor colorWithRed:0.524 green:0.553 blue:0.581 alpha:1.0];
    CGSize innerShadowOffset = CGSizeMake(0, 1.5);
    CGFloat innerShadowBlurRadius = 0.5;
    
    CGRect bezierBorderRect = CGRectInset([bezierPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
    bezierBorderRect = CGRectOffset(bezierBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
    bezierBorderRect = CGRectInset(CGRectUnion(bezierBorderRect, [bezierPath bounds]), -1, -1);
    
    UIBezierPath* bezierNegativePath = [UIBezierPath bezierPathWithRect: bezierBorderRect];
    [bezierNegativePath appendPath: bezierPath];
    bezierNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = innerShadowOffset.width + round(bezierBorderRect.size.width);
        CGFloat yOffset = innerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    innerShadowBlurRadius,
                                    innerShadow.CGColor);
        
        [bezierPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezierBorderRect.size.width), 0);
        [bezierNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [bezierNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - animation

- (void)startIndicatorAnimate
{
    if (loadIndicator && ![loadIndicator isAnimating])
    {
        [loadIndicator setHidden:NO];
        [loadIndicator startAnimating];
    }
}

- (void)hideIndicatorAnimate
{
    if (loadIndicator && [loadIndicator isAnimating])
    {
        [loadIndicator stopAnimating];
    }
}

- (void)loadThumbnailImage:(UIImage*)thumbnailImage
{
    if (thumbnailImage)
    {
        [self hideIndicatorAnimate];
        thumbnailView.image = thumbnailImage;
    }
    else
    {
        [self startIndicatorAnimate];
    }
}

- (void)setPopText:(NSString *)text
{
    textLabel.text = text;
}

- (UIImage *)thumbnailImage
{
    return thumbnailView.image;
}

@end
