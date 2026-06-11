#import <substrate.h>
#import <UIKit/UIKit.h>
#import "OverImageManager.h"

// Hook into SpringBoard to add overlay functionality
%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    
    // Initialize the overlay manager
    [OverImageManager sharedManager];
}

%end

// Add volume key handler to toggle or add image
%hook VolumeHUDController

- (void)volumeChanged:(NSNotification *)notification {
    %orig;
    
    // Double-tap volume up to show image picker
    // This can be customized based on preference
}

%end

// Inject into any app to allow overlay display
%hook UIViewController

- (void)viewDidLoad {
    %orig;
    
    // No direct action needed here, overlay displays globally
}

%end

// Allow touches to pass through properly for overlay interaction
%hook UIApplication

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = %orig;
    
    OverImageOverlayView *overlayView = [[OverImageManager sharedManager] currentOverlayView];
    
    if (overlayView && overlayView.isVisible) {
        CGPoint overlayPoint = [overlayView convertPoint:point fromView:nil];
        
        if (CGRectContainsPoint(overlayView.bounds, overlayPoint)) {
            return overlayView;
        }
    }
    
    return result;
}

%end

// Global function to add image from pasteboard
void AddImageFromPasteboard() {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.image) {
        [[OverImageManager sharedManager] addImageOverlayWithImage:pasteboard.image];
    }
}

// Global function to add specific image
void AddImageOverlay(UIImage *image) {
    if (image) {
        [[OverImageManager sharedManager] addImageOverlayWithImage:image];
    }
}

// Global function to remove overlay
void RemoveImageOverlay() {
    [[OverImageManager sharedManager] removeImageOverlay];
}

// Global function to toggle visibility
void ToggleImageVisibility() {
    OverImageOverlayView *overlay = [[OverImageManager sharedManager] currentOverlayView];
    if (overlay) {
        [overlay toggleVisibility];
    }
}
