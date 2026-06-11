#ifndef OverImageManager_h
#define OverImageManager_h

#import <UIKit/UIKit.h>
#import "OverImageOverlayView.h"

@interface OverImageManager : NSObject

+ (instancetype)sharedManager;
- (void)addImageOverlayWithImage:(UIImage *)image;
- (void)removeImageOverlay;
- (OverImageOverlayView *)currentOverlayView;
- (void)presentImagePickerInViewController:(UIViewController *)viewController;

@end

#endif /* OverImageManager_h */
