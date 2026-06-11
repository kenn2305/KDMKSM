#import "OverImageManager.h"

@interface OverImageManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) OverImageOverlayView *currentOverlay;
@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation OverImageManager

+ (instancetype)sharedManager {
    static OverImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)addImageOverlayWithImage:(UIImage *)image {
    // Remove existing overlay
    [self removeImageOverlay];
    
    // Create overlay window
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.userInteractionEnabled = YES;
    
    // Create and configure overlay view
    CGRect initialFrame = CGRectMake(50, 100, 300, 400);
    OverImageOverlayView *overlayView = [[OverImageOverlayView alloc] initWithImage:image frame:initialFrame];
    
    self.currentOverlay = overlayView;
    
    // Add to window
    [self.overlayWindow addSubview:overlayView];
    [self.overlayWindow makeKeyAndVisible];
}

- (void)removeImageOverlay {
    if (self.currentOverlay) {
        [self.currentOverlay removeFromSuperview];
        self.currentOverlay = nil;
    }
    
    if (self.overlayWindow) {
        self.overlayWindow.hidden = YES;
        self.overlayWindow = nil;
    }
}

- (OverImageOverlayView *)currentOverlayView {
    return self.currentOverlay;
}

- (void)presentImagePickerInViewController:(UIViewController *)viewController {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    
    [viewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    if (selectedImage) {
        [self addImageOverlayWithImage:selectedImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
