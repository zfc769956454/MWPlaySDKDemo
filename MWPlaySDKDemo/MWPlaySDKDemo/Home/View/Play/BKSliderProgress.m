//
//  YZSliderProgress.m
//
//
//  Created by yun on 13-3-26.
//
//


#import "BKSliderProgress.h"
#import "BKPopover.h"
#import <objc/message.h>

#define point_offset (4.0)

@interface UIImage (BKSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@implementation UIImage(BKSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *img = nil;
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end

@interface BKSliderProgress ()
{
    UIProgressView *progressView;
    id _targete;
    SEL _actionn;
  
}

@property (nonatomic,strong)  BKPopover *popover;


@end

@implementation BKSliderProgress
@synthesize slider;

#pragma mark - lifeCycle

- (void)loadSubView
{
    self.backgroundColor = [UIColor clearColor];
    
    slider = [[BKSlider alloc] initWithFrame:self.bounds];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:slider];
    
    CGRect rect = slider.bounds;
    rect.origin.x += point_offset;
    rect.size.width -= 2 * point_offset;
    rect.size.height = self.bounds.size.height;
    progressView = [[UIProgressView alloc] initWithFrame:rect];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    progressView.center = slider.center;
    progressView.userInteractionEnabled = NO;
    progressView.clipsToBounds = YES;
    [slider addSubview:progressView];
    [slider sendSubviewToBack:progressView];
    
    progressView.progressTintColor = [UIColor darkGrayColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    slider.frame = self.bounds;
    CGRect rect = slider.frame;
    rect.origin.x += point_offset;
    rect.size.width -= 2 * point_offset;
    progressView.frame = rect;
    progressView.center = slider.center;
  
    CGRect frame = CGRectMake(0, self.frame.origin.y - 116, 120, 100);
    self.popover.frame=frame;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        [self loadSubView];
        
        CGRect frame = CGRectMake(0, self.frame.origin.y - 116, 120, 100);
        self.popover = [[BKPopover alloc] initWithFrame:frame];
        self.popover.alpha = 0.f;
        [self addSubview:self.popover];
    }
    
    return self;
}


- (void)dealloc
{
    self.popover = nil;
}

- (void)killTargetAndAction
{
    _targete = nil;
    _actionn = nil;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _targete = target;
    _actionn = action;
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:controlEvents];
}

- (void)onSliderValueChanged:(id)sender
{
    //objc_msgSend(_targete, _actionn, self);
}

- (CGFloat)value
{
    return slider.value;
}

- (void)setValue:(CGFloat)value
{
    slider.value = value;
}

- (CGFloat)middleValue
{
    return progressView.progress;
}

- (void)setMiddleValue:(CGFloat)middleValue
{
    progressView.progress = middleValue;
}

- (CGFloat)maxValue
{
    return slider.maximumValue;
}

- (void)setMaxValue:(CGFloat)maxValue
{
    if (isnan(maxValue)) {
        return;
    }
    slider.maximumValue = maxValue;
}

- (UIColor *)thumbTintColor
{
    return slider.thumbTintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    [slider setThumbTintColor:thumbTintColor];
}

- (UIColor *)minimumTrackTintColor
{
    return slider.minimumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    [slider setMinimumTrackTintColor:minimumTrackTintColor];
}

- (UIColor *)middleTrackTintColor
{
    return progressView.progressTintColor;
}

- (void)setMiddleTrackTintColor:(UIColor *)middleTrackTintColor
{
    progressView.progressTintColor = middleTrackTintColor;
}

- (UIColor *)maximumTrackTintColor
{
    return progressView.trackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    progressView.trackTintColor = maximumTrackTintColor;
}

- (UIImage *)thumbImage
{
    return slider.currentThumbImage;
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    [slider setThumbImage:image forState:state];
}

- (UIImage* )minimumTrackImage
{
    return slider.currentMinimumTrackImage;
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage
{
    [slider setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
}

- (UIImage* )middleTrackImage
{
    return progressView.progressImage;
}

- (void)setMiddleTrackImage:(UIImage *)middleTrackImage
{
    progressView.progressImage = middleTrackImage;
}

- (UIImage* )maximumTrackImage
{
    return progressView.trackImage;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage
{
    [slider setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor] size:maximumTrackImage.size] forState:UIControlStateNormal];
    progressView.trackImage = maximumTrackImage;
}

#pragma mark - UIView(UIViewRendering)

#pragma mark - method

- (void)updatePopoverFrame
{
    NSLog(@"%f",slider.minimumValue);
    if (slider.maximumValue)
    {
        CGFloat minimumValue = slider.minimumValue;
        CGFloat maximumValue = slider.maximumValue;
        CGFloat different = slider.maximumValue - slider.minimumValue;
        CGFloat sliderValue = self.value;
        if (slider.minimumValue < 0.0)
        {
            sliderValue = slider.value - slider.minimumValue;
            maximumValue = slider.maximumValue - slider.minimumValue;
            minimumValue = 0.0;
        }
        
        CGFloat x = (((sliderValue - minimumValue) / different) * self.frame.size.width) - (self.popover.frame.size.width / 2.0);
        CGFloat halfMax = (maximumValue + minimumValue) / 2.0;
        if (sliderValue > halfMax)
        {
            sliderValue = (sliderValue - halfMax) + (minimumValue * 1.0);
            sliderValue = sliderValue / halfMax;
            sliderValue = sliderValue * 11.0;
            x = x - sliderValue;
        }
        else if (sliderValue < halfMax)
        {
            sliderValue = (halfMax - sliderValue) + (minimumValue * 1.0);
            sliderValue = sliderValue / halfMax;
            sliderValue = sliderValue * 11.0;
            x = x + sliderValue;
        }
        
        self.popover.frame = CGRectMake(x, self.popover.frame.origin.y, self.popover.frame.size.width, self.popover.frame.size.height);
    }
}

- (void)showPopoverAnimated:(BOOL)animated
{
    if ([self.popover thumbnailImage] == nil)
    {
        [self.popover startIndicatorAnimate];
    }

    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 1.0;
        }];
    }
    else
    {
        self.popover.alpha = 1.0;
    }
}

- (void)hidePopoverAnimated:(BOOL)animated
{
    [self.popover hideIndicatorAnimate];
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 0.0;
        }];
    }
    else
    {
        self.popover.alpha = 0.0;
    }
}

- (void)hidePop:(BOOL)hide
{
    self.popover.hidden = hide;
}

- (void)popWithText:(NSString *)text
{
    [self.popover setPopText:text];
}

- (void)loadThumbnailImage:(UIImage*)thumbnailImage
{
    [self.popover loadThumbnailImage:thumbnailImage];
}

@end


@implementation BKSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{//返回滑块大小
    
    rect.origin.x = rect.origin.x - 10;
    
    rect.size.width = rect.size.width +20;
    
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
    
}

@end

