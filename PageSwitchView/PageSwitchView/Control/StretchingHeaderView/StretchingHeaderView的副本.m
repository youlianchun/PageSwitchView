//
//  StretchingHeaderView.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/10/6.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "StretchingHeaderView.h"
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface StretchingHeaderView()
@property (nonatomic) UIView *contentBgView;
@property (nonatomic, strong) NSLayoutConstraint *contentBgView_CH;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *makeImageView;

@property (nonatomic, strong) NSLayoutConstraint *imageView_CHW;

@property (nonatomic, assign) BOOL didUpdateImage;
@property (nonatomic, assign) BOOL didUpdateMakeImage;

@property (nonatomic) UIColor *tintColor;

@end

@implementation StretchingHeaderView

#pragma mark - Get Set

-(UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = [UIColor colorWithWhite:0.6 alpha:0.2];
    }
    return _tintColor;
}


-(UIView *)contentBgView {
    if (!_contentBgView) {
        self.clipsToBounds = true;
        _contentBgView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_contentBgView];
        _contentBgView.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentBgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        self.contentBgView_CH = [NSLayoutConstraint constraintWithItem:_contentBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0];
        [self addConstraint:self.contentBgView_CH];
        _contentBgView.backgroundColor = [UIColor greenColor];
    }
    return _contentBgView;
}

-(void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    CGRect frame = contentView.bounds;
    frame.size.width = self.bounds.size.width;
    contentView.frame = frame;
    [self.contentBgView addSubview:contentView];
    self.contentBgView_CH.constant = CGRectGetHeight(frame);
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentBgView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentBgView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.contentBgView addConstraint: [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentBgView addConstraint: [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

        CGFloat m = self.contentBgView_CH.constant/self.bounds.size.width;
        self.imageView_CHW = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeWidth multiplier:m constant:0];

        [_imageView addConstraint:self.imageView_CHW];
    }
    return _imageView;
}

-(UIImageView *)makeImageView {
    if (!_makeImageView) {
        _makeImageView = [[UIImageView alloc]init];
        _makeImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_makeImageView];
        _makeImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_makeImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_makeImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_makeImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_makeImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _makeImageView;
}



-(void)setBounds:(CGRect)bounds{//上滑，下拉时候的视觉样式处理
    [super setBounds:bounds];
    self.contentView.userInteractionEnabled = CGRectGetHeight(bounds)==self.contentBgView_CH.constant;

    self.imageView.hidden = CGRectGetHeight(bounds)<=self.contentBgView_CH.constant;
    if (!self.imageView.hidden && !self.didUpdateImage) {//每次下啦时候更新一次image
        self.imageView.image = [self imageWithUIView:self.contentView];
        self.didUpdateImage = true;
    }else if (self.imageView.image){
        //didUpdateImage 在bounds初始化时候过滤
        self.didUpdateImage = !self.imageView.hidden;
    }
    
    self.makeImageView.hidden = CGRectGetHeight(bounds)>=self.contentBgView_CH.constant;
    if (!self.makeImageView.hidden && !self.didUpdateMakeImage) {//每次下啦时候更新一次makeImage
        UIImage *image = [self imageWithUIView:self.contentView];
//        self.makeImageView.image = image;
        __weak typeof(self) wself = self;
        [self applyBlurWithImage:image Radius:5 tintColor:self.tintColor saturationDeltaFactor:1.0  resImage:^(UIImage *image) {
            wself.makeImageView.image = image;
        }];
        self.didUpdateMakeImage = true;
    }else if (self.makeImageView.image){
        //didUpdateMakeImage 在bounds初始化时候过滤
        self.didUpdateMakeImage = !self.makeImageView.hidden;
    }
    
    if (!self.makeImageView.hidden) {
        self.makeImageView.alpha = 1-CGRectGetHeight(bounds)/CGRectGetHeight(self.contentView.bounds);
    }
}

#pragma mark -

-(UIImage*)imageWithUIView:(UIView*)view{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//获取高斯模糊图片
- (void)applyBlurWithImage:(UIImage*)image Radius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor resImage:(void(^)(UIImage*image))resImage{
    if (!resImage || !image.CGImage || image.size.width < 1 || image.size.height < 1) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGRect imageRect = { CGPointZero, image.size };
        UIImage *effectImage = image;
        
        BOOL hasBlur = blurRadius > __FLT_EPSILON__;
        BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
        if (hasBlur || hasSaturationChange) {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
            CGContextRef effectInContext = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(effectInContext, 1.0, -1.0);
            CGContextTranslateCTM(effectInContext, 0, -image.size.height);
            CGContextDrawImage(effectInContext, imageRect, image.CGImage);
            
            vImage_Buffer effectInBuffer;
            effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
            effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
            effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
            effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
            
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
            CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
            vImage_Buffer effectOutBuffer;
            effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
            effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
            effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
            effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
            
            if (hasBlur) {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
                unsigned int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
                if (radius % 2 != 1) {
                    radius += 1; // force radius to be odd so that the three box-blur methodology works.
                }
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            }
            if (hasSaturationChange) {
                CGFloat s = saturationDeltaFactor;
                CGFloat floatingPointSaturationMatrix[] = {
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1,
                };
                const int32_t divisor = 256;
                NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
                int16_t saturationMatrix[matrixSize];
                for (NSUInteger i = 0; i < matrixSize; ++i) {
                    saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
                }
                if (hasBlur) {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                }
            }
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIGraphicsEndImageContext();
            
        }
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef outputContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(outputContext, 1.0, -1.0);
        CGContextTranslateCTM(outputContext, 0, -image.size.height);
        
        // Draw base image.
        CGContextDrawImage(outputContext, imageRect, image.CGImage);
        
        // Draw effect image.
        if (hasBlur) {
            CGContextSaveGState(outputContext);
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
            CGContextRestoreGState(outputContext);
        }
        
        // Add in color tint.
        if (tintColor) {
            CGContextSaveGState(outputContext);
            CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
            CGContextFillRect(outputContext, imageRect);
            CGContextRestoreGState(outputContext);
        }
        
        // Output image is ready.
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            resImage(outputImage);
        });
    });
}
@end
