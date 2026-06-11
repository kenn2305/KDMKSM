#import "OverImageOverlayView.h"

@interface OverImageOverlayView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) CGFloat initialDistance;

@end

@implementation OverImageOverlayView

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame {
    self = [super initWithImage:frame];
    if (self) {
        _displayImage = image;
        _isVisible = YES;
        _currentScale = 1.0;
        
        [self setupImageView];
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)setupImageView {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    self.imageView = [[UIImageView alloc] initWithImage:self.displayImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = NO;
    
    [self addSubview:self.imageView];
    
    [self updateImageContent];
}

- (void)updateImageContent {
    if (self.displayImage) {
        CGFloat imageWidth = self.displayImage.size.width;
        CGFloat imageHeight = self.displayImage.size.height;
        CGFloat aspectRatio = imageWidth / imageHeight;
        
        CGFloat maxWidth = 300;
        CGFloat maxHeight = 400;
        
        CGFloat width = imageWidth;
        CGFloat height = imageHeight;
        
        if (width > maxWidth) {
            width = maxWidth;
            height = width / aspectRatio;
        }
        
        if (height > maxHeight) {
            height = maxHeight;
            width = height * aspectRatio;
        }
        
        self.frame = CGRectMake(0, 0, width, height);
        self.imageView.frame = self.bounds;
    }
}

- (void)setupGestureRecognizers {
    // Pan gesture for moving
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:self.panGesture];
    
    // Pinch gesture for zooming
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:self.pinchGesture];
    
    // Tap gesture for toggling visibility
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.tapGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!self.isVisible) return;
    
    UIView *superview = self.superview;
    if (!superview) return;
    
    CGPoint translation = [gesture translationInView:superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.initialViewCenter = self.center;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = CGPointMake(
            self.initialViewCenter.x + translation.x,
            self.initialViewCenter.y + translation.y
        );
        
        // Constrain to superview bounds
        newCenter.x = MAX(self.frame.size.width / 2, MIN(newCenter.x, superview.bounds.size.width - self.frame.size.width / 2));
        newCenter.y = MAX(self.frame.size.height / 2, MIN(newCenter.y, superview.bounds.size.height - self.frame.size.height / 2));
        
        self.center = newCenter;
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    if (!self.isVisible) return;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.initialDistance = gesture.scale;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = gesture.scale / self.initialDistance * self.currentScale;
        
        // Limit zoom between 0.5x and 3x
        scale = MAX(0.5, MIN(scale, 3.0));
        
        self.currentScale = scale;
        
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        self.transform = transform;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    
    // Check if tap is outside the image bounds
    if (!CGRectContainsPoint(self.bounds, tapPoint)) {
        [self toggleVisibility];
    }
}

- (void)toggleVisibility {
    self.isVisible = !self.isVisible;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = self.isVisible ? 1.0 : 0.0;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    // If touch is outside bounds and view is visible, check for toggle
    if (!CGRectContainsPoint(self.bounds, touchPoint) && self.isVisible) {
        [self toggleVisibility];
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
