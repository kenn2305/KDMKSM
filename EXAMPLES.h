// Example: How to use OverImage Tweak in your app or tweak

#import "OverImage.h"
#import <UIKit/UIKit.h>

// Example 1: Add image from photo library
void ExampleAddImageFromPhotos() {
    // Get image
    UIImage *testImage = [UIImage imageNamed:@"test"];
    
    // Add to overlay
    [[OverImageManager sharedManager] addImageOverlayWithImage:testImage];
}

// Example 2: Add image from URL
void ExampleAddImageFromURL(NSURL *imageURL) {
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    [[OverImageManager sharedManager] addImageOverlayWithImage:image];
}

// Example 3: Add image from clipboard
void ExampleAddImageFromClipboard() {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.image) {
        [[OverImageManager sharedManager] addImageOverlayWithImage:pasteboard.image];
    }
}

// Example 4: Remove overlay
void ExampleRemoveOverlay() {
    [[OverImageManager sharedManager] removeImageOverlay];
}

// Example 5: Check current overlay
void ExampleCheckCurrentOverlay() {
    OverImageOverlayView *current = [[OverImageManager sharedManager] currentOverlayView];
    
    if (current) {
        NSLog(@"Current overlay: %@", current);
        NSLog(@"Is visible: %d", current.isVisible);
        NSLog(@"Current scale: %f", current.currentScale);
    }
}

// Example 6: Toggle visibility programmatically
void ExampleToggleVisibility() {
    OverImageOverlayView *overlay = [[OverImageManager sharedManager] currentOverlayView];
    if (overlay) {
        [overlay toggleVisibility];
    }
}

// Example 7: Integration with other tweaks
// In Tweak.xm or other places, you can call:
// AddImageOverlay([UIImage imageWithData:data]);
// RemoveImageOverlay();
// ToggleImageVisibility();

// Example 8: Gesture customization
// To modify gesture behavior, edit the handle* methods in OverImageOverlayView.mm
// Modify zoom limits:
//   scale = MAX(0.5, MIN(scale, 3.0));  // Change 0.5 and 3.0 to your preference
//
// Modify pan boundary constraints:
//   newCenter.x = MAX(self.frame.size.width / 2, MIN(newCenter.x, superview.bounds.size.width - self.frame.size.width / 2));
