//
//  GPULaplacianFilter.h
//  FilterShowcase
//
//  Created by Zitao Xiong on 4/6/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPUImageTwoPassFilter.h"

@interface GPUGaussianFilter : GPUImageTwoPassFilter
{
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
    BOOL hasOverriddenImageSizeFactor;
    CGFloat edgeFactor_;
    GLint edgeUnifrom;
    
    GLint horizontalGaussianArrayUniform, horizontalBlurSizeUniform, verticalGaussianArrayUniform, verticalBlurSizeUniform;
    GLint verticalPassTexelWidthOffsetUniform, verticalPassTexelHeightOffsetUniform, horizontalPassTexelWidthOffsetUniform, horizontalPassTexelHeightOffsetUniform, blurSizeUniform;
    CGFloat strength_;
    
    GLint kernelUniform;
    GLint horizontalKernelUniform;


}
@property (readwrite, nonatomic) CGFloat blurSize;
@property(readwrite, nonatomic) CGFloat imageWidthFactor; 
@property(readwrite, nonatomic) CGFloat imageHeightFactor; 
@property (nonatomic, assign) CGFloat strength;
- (void)setGaussianValues:(NSArray *)values;
// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
@end
