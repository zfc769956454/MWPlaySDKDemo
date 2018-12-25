//
//  YZPopover.h
//  
//
//  Created by yun on 13-3-26.
//
//

#import <UIKit/UIKit.h>

@interface BKPopover : UIView

- (void)startIndicatorAnimate;
- (void)hideIndicatorAnimate;
- (UIImage *)thumbnailImage;
- (void)setPopText:(NSString *)text;
- (void)loadThumbnailImage:(UIImage*)thumbnailImage;

@end
