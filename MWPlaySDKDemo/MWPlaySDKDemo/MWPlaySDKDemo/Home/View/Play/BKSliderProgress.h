//
//  YZSliderProgress.h
//  
//
//  Created by yun on 13-3-26.
//
//

#import <UIKit/UIKit.h>


@interface BKSlider : UISlider

@end


@interface BKSliderProgress : UIControl

@property (nonatomic, strong) BKSlider *slider;
@property (nonatomic, assign) CGFloat value;       /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue; /* From 0 to 1 */
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nonatomic, strong) UIColor *middleTrackTintColor;
@property (nonatomic, strong) UIColor *maximumTrackTintColor;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *minimumTrackImage;
@property (nonatomic, strong) UIImage *middleTrackImage;
@property (nonatomic, strong) UIImage *maximumTrackImage;


- (void)killTargetAndAction;
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
- (void)updatePopoverFrame;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopoverAnimated:(BOOL)animated;
- (void)hidePop:(BOOL)hide;
- (void)popWithText:(NSString *)text;
- (void)loadThumbnailImage:(UIImage*)thumbnailImage;

@end
