//
//  GPULapacianFilter.h
//  FilterShowcase
//
//  Created by Qiuhao Zhang on 4/24/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPUImageTwoPassFilter.h"

@interface GPULapacianFilter : GPUImageFilter
{
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
    BOOL hasOverriddenImageSizeFactor;
    CGFloat edgeFactor_;
    GLint edgeUnifrom;
}

@property(readwrite, nonatomic) CGFloat imageWidthFactor; 
@property(readwrite, nonatomic) CGFloat imageHeightFactor; 
@property (nonatomic, readwrite) CGFloat edgeFactor;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initAdd;
- (id)initInverse;


@end
