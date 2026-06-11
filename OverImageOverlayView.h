#ifndef OverImageOverlayView_h
#define OverImageOverlayView_h

#import <UIKit/UIKit.h>

@interface OverImageOverlayView : UIView

@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, assign) CGPoint initialTouchPoint;
@property (nonatomic, assign) CGPoint initialViewCenter;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) CGFloat currentScale;

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;
- (void)setupGestureRecognizers;
- (void)toggleVisibility;
- (void)updateImageContent;

@end

#endif /* OverImageOverlayView_h */
