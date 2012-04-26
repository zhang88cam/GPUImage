//
//  GPULapacianFilter.m
//  FilterShowcase
//
//  Created by Qiuhao Zhang on 4/24/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPULapacianFilter.h"
#import "GPUImageGrayscaleFilter.h"


NSString *const kGPULaplacianVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 uniform highp float imageWidthFactor; 
 uniform highp float imageHeightFactor; 
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 uniform float edgeFactor;
 
 varying float computeEdgeFactor;
 
 void main()
 {
     gl_Position = position;
     
     vec2 widthStep = vec2(imageWidthFactor, 0.0);
     vec2 heightStep = vec2(0.0, imageHeightFactor);
     vec2 widthHeightStep = vec2(imageWidthFactor, imageHeightFactor);
     vec2 widthNegativeHeightStep = vec2(imageWidthFactor, -imageHeightFactor);
     
     textureCoordinate = inputTextureCoordinate.xy;
     leftTextureCoordinate = inputTextureCoordinate.xy - widthStep;
     rightTextureCoordinate = inputTextureCoordinate.xy + widthStep;
     
     topTextureCoordinate = inputTextureCoordinate.xy + heightStep;
     topLeftTextureCoordinate = inputTextureCoordinate.xy - widthNegativeHeightStep;
     topRightTextureCoordinate = inputTextureCoordinate.xy + widthHeightStep;
     
     bottomTextureCoordinate = inputTextureCoordinate.xy - heightStep;
     bottomLeftTextureCoordinate = inputTextureCoordinate.xy - widthHeightStep;
     bottomRightTextureCoordinate = inputTextureCoordinate.xy + widthNegativeHeightStep;
     
     computeEdgeFactor = edgeFactor;
 }
 );

//   Code from "Graphics Shaders: Theory and Practice" by M. Bailey and S. Cunningham 
NSString *const kGPULaplacianFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 varying float computeEdgeFactor;
 
 void main()
 {
     float i00   = texture2D(inputImageTexture, textureCoordinate).r;
     float im1m1 = texture2D(inputImageTexture, bottomLeftTextureCoordinate).r;
     float ip1p1 = texture2D(inputImageTexture, topRightTextureCoordinate).r;
     float im1p1 = texture2D(inputImageTexture, topLeftTextureCoordinate).r;
     float ip1m1 = texture2D(inputImageTexture, bottomRightTextureCoordinate).r;
     float im10 = texture2D(inputImageTexture, leftTextureCoordinate).r;
     float ip10 = texture2D(inputImageTexture, rightTextureCoordinate).r;
     float i0m1 = texture2D(inputImageTexture, bottomTextureCoordinate).r;
     float i0p1 = texture2D(inputImageTexture, topTextureCoordinate).r;
     float h =  - im10 + 2.0 * i00 - ip10;
     float v =  - i0p1 + 2.0 * i00 - i0m1;
          
     float mag = length(vec2(h, v));
     
     gl_FragColor = vec4(vec3(mag) * computeEdgeFactor, 1.0);
 }
 );


NSString *const kGPULaplacianAddFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 varying float computeEdgeFactor;
 void main()
 {
     vec4 color;
     color = texture2D(inputImageTexture, textureCoordinate);
     float i00   = texture2D(inputImageTexture, textureCoordinate).r;
     float im1m1 = texture2D(inputImageTexture, bottomLeftTextureCoordinate).r;
     float ip1p1 = texture2D(inputImageTexture, topRightTextureCoordinate).r;
     float im1p1 = texture2D(inputImageTexture, topLeftTextureCoordinate).r;
     float ip1m1 = texture2D(inputImageTexture, bottomRightTextureCoordinate).r;
     float im10 = texture2D(inputImageTexture, leftTextureCoordinate).r;
     float ip10 = texture2D(inputImageTexture, rightTextureCoordinate).r;
     float i0m1 = texture2D(inputImageTexture, bottomTextureCoordinate).r;
     float i0p1 = texture2D(inputImageTexture, topTextureCoordinate).r;
     float h =  - im10 + 2.0 * i00 - ip10;
     float v =  - i0p1 + 2.0 * i00 - i0m1;
     
     float mag = length(vec2(h, v));
     color += vec4(vec3(mag) * computeEdgeFactor,1);
     gl_FragColor = color;
 }
 );

NSString *const kGPULaplacianInverseFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 varying float computeEdgeFactor;
 void main()
 {
     vec4 color;
     color = texture2D(inputImageTexture, textureCoordinate);
     float i00   = texture2D(inputImageTexture, textureCoordinate).r;
     float im1m1 = texture2D(inputImageTexture, bottomLeftTextureCoordinate).r;
     float ip1p1 = texture2D(inputImageTexture, topRightTextureCoordinate).r;
     float im1p1 = texture2D(inputImageTexture, topLeftTextureCoordinate).r;
     float ip1m1 = texture2D(inputImageTexture, bottomRightTextureCoordinate).r;
     float im10 = texture2D(inputImageTexture, leftTextureCoordinate).r;
     float ip10 = texture2D(inputImageTexture, rightTextureCoordinate).r;
     float i0m1 = texture2D(inputImageTexture, bottomTextureCoordinate).r;
     float i0p1 = texture2D(inputImageTexture, topTextureCoordinate).r;
     float h =  - i0p1 - im10 + 4.0 * i00 - ip10  - i0m1;

     
//     float mag = 1.0 - length(vec2(h, v));
     float mag = 1.0 - length(vec3(h));

     gl_FragColor = vec4(vec3(mag) * computeEdgeFactor,1);
     
 }
 );



@implementation GPULapacianFilter
@synthesize imageWidthFactor = _imageWidthFactor; 
@synthesize imageHeightFactor = _imageHeightFactor; 
@synthesize edgeFactor = edgeFactor_;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [self initWithFragmentShaderFromString:kGPULaplacianFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}


- (id)initAdd;
{
    if (!(self = [self initWithFragmentShaderFromString:kGPULaplacianAddFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

- (id)initInverse;
{
    if (!(self = [self initWithFragmentShaderFromString:kGPULaplacianInverseFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}


- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
{
    // Do a luminance pass first to reduce the calculations performed at each fragment in the edge detection phase
    //    if (!(self = [super initWithVertexShaderFromString:kSobelEdgeXGradientVertexShaderString fragmentShaderFromString:fragmentShaderString])) {
    //        return nil;
    //    }
//    
//    if (!(self = [super initWithFirstStageVertexShaderFromString:kGPUImageVertexShaderString 
//                              firstStageFragmentShaderFromString:kGPUImageLuminanceFragmentShaderString 
//                               secondStageVertexShaderFromString:kGPULaplacianVertexShaderString 
//                             secondStageFragmentShaderFromString:fragmentShaderString]))
//    {
//		return nil;
//    }
    
    if (!(self = [super initWithVertexShaderFromString:kGPULaplacianVertexShaderString fragmentShaderFromString:fragmentShaderString])) {
        return nil;
    }
//    
    
    hasOverriddenImageSizeFactor = NO;
    
//    imageWidthFactorUniform = [secondFilterProgram uniformIndex:@"imageWidthFactor"];
//    imageHeightFactorUniform = [secondFilterProgram uniformIndex:@"imageHeightFactor"];
//    edgeUnifrom = [secondFilterProgram uniformIndex:@"edgeFactor"];
    
    
    imageWidthFactorUniform = [filterProgram uniformIndex:@"imageWidthFactor"];
    imageHeightFactorUniform = [filterProgram uniformIndex:@"imageHeightFactor"];
    edgeUnifrom = [filterProgram uniformIndex:@"edgeFactor"];

    self.edgeFactor = 0.0;
    
    return self;
}

- (void)setupFilterForSize:(CGSize)filterFrameSize;
{
    if (!hasOverriddenImageSizeFactor)
    {
        _imageWidthFactor = filterFrameSize.width;
        _imageHeightFactor = filterFrameSize.height;
        
        [GPUImageOpenGLESContext useImageProcessingContext];
        [filterProgram use];
        glUniform1f(imageWidthFactorUniform, 1.0 / _imageWidthFactor);
        glUniform1f(imageHeightFactorUniform, 1.0 / _imageHeightFactor);
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setImageWidthFactor:(CGFloat)newValue;
{
    hasOverriddenImageSizeFactor = YES;
    _imageWidthFactor = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(imageWidthFactorUniform, 1.0 / _imageWidthFactor);
}

- (void)setImageHeightFactor:(CGFloat)newValue;
{
    hasOverriddenImageSizeFactor = YES;
    _imageHeightFactor = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(imageHeightFactorUniform, 1.0 / _imageHeightFactor);
}

- (void)setEdgeFactor:(CGFloat)edgeFactor {
    edgeFactor_ = edgeFactor;
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(edgeUnifrom, edgeFactor_);
}


@end
