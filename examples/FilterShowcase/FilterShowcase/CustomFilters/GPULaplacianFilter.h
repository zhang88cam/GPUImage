//
//  GPULaplacianFilter.h
//  FilterShowcase
//
//  Created by Zitao Xiong on 4/6/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPUImageTwoPassFilter.h"

@interface GPULaplacianFilter : GPUImageTwoPassFilter
{
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
    BOOL hasOverriddenImageSizeFactor;
    CGFloat edgeFactor_;
    GLint edgeUnifrom;
    
    GLint horizontalGaussianArrayUniform, horizontalBlurSizeUniform, verticalGaussianArrayUniform, verticalBlurSizeUniform;
    GLint verticalPassTexelWidthOffsetUniform, verticalPassTexelHeightOffsetUniform, horizontalPassTexelWidthOffsetUniform, horizontalPassTexelHeightOffsetUniform, blurSizeUniform;
    CGFloat strength_;
    
    GLint kernelUniform;

}
@property (readwrite, nonatomic) CGFloat blurSize;
@property(readwrite, nonatomic) CGFloat imageWidthFactor; 
@property(readwrite, nonatomic) CGFloat imageHeightFactor; 
@property (nonatomic, assign) CGFloat strength;
- (void)setGaussianValues;
// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
@end
