//
//  GPULaplacianFilter.m
//  FilterShowcase
//
//  Created by Zitao Xiong on 4/6/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//
#define KERNEL_SIZE 3
#define KERNEL_LENGTH (KERNEL_SIZE * KERNEL_SIZE)

#import "GPUGaussianFilter.h"

NSString *const kGPUImageGaussianVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 const lowp int GAUSSIAN_SAMPLES = KERNEL_LENGTH;
 
 uniform highp float texelWidthOffset; 
 uniform highp float texelHeightOffset;
 uniform highp float blurSize;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
 uniform highp float kernelValues[GAUSSIAN_SAMPLES];
 
 varying highp float kernelValuesOutput[GAUSSIAN_SAMPLES];

 varying float strength;
 void main() {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
     
     // Calculate the positions for the blur
     int multiplier = 0;
     highp vec2 blurStep;
//     highp vec2 singleStepOffset = vec2(texelHeightOffset, texelWidthOffset) * blurSize;
     highp vec2 singleStepOffset = vec2(texelHeightOffset, texelWidthOffset) * 1.0;

     
     for (lowp int i = 0; i < GAUSSIAN_SAMPLES; i++) {
         multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
         // Blur in x (horizontal)
         blurStep = float(multiplier) * singleStepOffset;
         blurCoordinates[i] = inputTextureCoordinate.xy + blurStep;
     }
     
     strength = blurSize;
     
     for (lowp int i = 0; i < GAUSSIAN_SAMPLES; i++) {
         kernelValuesOutput[i] = kernelValues[i];
     }
 }
 );

NSString *const kGPUImageGaussianFragmentShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 
 const lowp int GAUSSIAN_SAMPLES = KERNEL_LENGTH;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
 varying lowp float strength;
 
 varying highp float kernelValuesOutput[GAUSSIAN_SAMPLES];

 
 void main() {
     lowp vec4 sum = vec4(0.0);
     
     for (int i = 0; i < GAUSSIAN_SAMPLES; i ++)
     {
         sum += texture2D(inputImageTexture, blurCoordinates[i]) * kernelValuesOutput[i];
     }

     int median = (GAUSSIAN_SAMPLES - 1) / 2;
     lowp vec4 color = texture2D(inputImageTexture, blurCoordinates[median]);

     color = color * (1.0 - strength) + sum * strength;
     gl_FragColor = color;
 }
 );


@implementation GPUGaussianFilter
@synthesize blurSize = _blurSize;
@synthesize imageWidthFactor = _imageWidthFactor; 
@synthesize imageHeightFactor = _imageHeightFactor; 
@synthesize strength = strength_;


- (id) initWithFirstStageVertexShaderFromString:(NSString *)firstStageVertexShaderString 
             firstStageFragmentShaderFromString:(NSString *)firstStageFragmentShaderString 
              secondStageVertexShaderFromString:(NSString *)secondStageVertexShaderString
            secondStageFragmentShaderFromString:(NSString *)secondStageFragmentShaderString {
    
    if (!(self = [super initWithFirstStageVertexShaderFromString:firstStageVertexShaderString ? firstStageVertexShaderString : kGPUImageGaussianVertexShaderString
                              firstStageFragmentShaderFromString:firstStageFragmentShaderString ? firstStageFragmentShaderString : kGPUImageGaussianFragmentShaderString
                               secondStageVertexShaderFromString:secondStageVertexShaderString ? secondStageVertexShaderString : kGPUImageGaussianVertexShaderString
                             secondStageFragmentShaderFromString:secondStageFragmentShaderString ? secondStageFragmentShaderString : kGPUImageGaussianFragmentShaderString])) {
        return nil;
    }
    
    horizontalBlurSizeUniform = [filterProgram uniformIndex:@"blurSize"];
    horizontalGaussianArrayUniform = [filterProgram uniformIndex:@"gaussianValues"];
    horizontalPassTexelWidthOffsetUniform = [filterProgram uniformIndex:@"texelWidthOffset"];
    horizontalPassTexelHeightOffsetUniform = [filterProgram uniformIndex:@"texelHeightOffset"];
    
    verticalBlurSizeUniform = [secondFilterProgram uniformIndex:@"blurSize"];
    verticalGaussianArrayUniform = [secondFilterProgram uniformIndex:@"gaussianValues"];
    verticalPassTexelWidthOffsetUniform = [secondFilterProgram uniformIndex:@"texelWidthOffset"];
    verticalPassTexelHeightOffsetUniform = [secondFilterProgram uniformIndex:@"texelHeightOffset"];
    horizontalKernelUniform = [filterProgram uniformIndex:@"kernelValues"];
    kernelUniform = [secondFilterProgram uniformIndex:@"kernelValues"];
    self.blurSize = 1.0;
    [self setGaussianValues:nil];
    
    return self;
}

- (id)init;
{
    return [self initWithFirstStageVertexShaderFromString:nil
                       firstStageFragmentShaderFromString:nil
                        secondStageVertexShaderFromString:nil
                      secondStageFragmentShaderFromString:nil];
}

- (void)setupFilterForSize:(CGSize)filterFrameSize;
{
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(horizontalPassTexelWidthOffsetUniform, 1.0 / filterFrameSize.width);
    glUniform1f(horizontalPassTexelHeightOffsetUniform, 0.0);
    
    [secondFilterProgram use];
    glUniform1f(verticalPassTexelWidthOffsetUniform, 0.0);
    glUniform1f(verticalPassTexelHeightOffsetUniform, 1.0 / filterFrameSize.height);
}


#pragma mark Getters and Setters

- (void) setKernel:(GLfloat[]) kernels {
    GLsizei gaussianLength = KERNEL_LENGTH;
//    GLfloat gaussians[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };

    GLfloat gaussians[] = { 0.05, 0.09, 0.12, 0.15, 0.18, 0.15, 0.12, 0.09, 0.05 };

    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
//    glUniform1fv(horizontalGaussianArrayUniform, gaussianLength, gaussians);
    glUniform1fv(horizontalKernelUniform, gaussianLength, kernels);
    
    [secondFilterProgram use];
//    glUniform1fv(verticalGaussianArrayUniform, gaussianLength, gaussians);
    glUniform1fv(kernelUniform, gaussianLength, kernels);
}

- (void)setGaussianValues:(NSArray *)values{
    //    GLfloat kernel[]  = { 0.05, 0.09, 0.12, 0.15, 0.18, 0.15, 0.12, 0.09, 0.05 };
    GLfloat *kernel = malloc(sizeof(GLfloat) * KERNEL_LENGTH);
    if (!values) {
        //    int vector[5] = {1.0, 4.0, 6.0, 4.0, 1.0};
        int vector[KERNEL_SIZE] = {1.0, 2.0, 1.0};
        for (int i = 0 ; i < KERNEL_SIZE; i++) {
            for (int j = 0; j < KERNEL_SIZE; j++) {
                kernel[i * KERNEL_SIZE + j] = vector[i] * vector [j] / 16.0;
            }
        }
    }
    else {
        float sum = 0.0;
        for (int i = 0; i < KERNEL_LENGTH; i++) {
            kernel[i] = [[values objectAtIndex:i] floatValue];
            sum += kernel[i];
            
        }
        for (int i = 0; i < KERNEL_LENGTH; i++) {
            kernel[i] = kernel[i] / sum;
//            NSLog(@"%f", kernel[i]);
        }
    }
    [self setKernel: kernel];
}

- (void) setBlurSize:(CGFloat)blurSize {
    _blurSize = blurSize;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(horizontalBlurSizeUniform, _blurSize);
    
    [secondFilterProgram use];
    glUniform1f(verticalBlurSizeUniform, _blurSize);
}
#pragma mark -
#pragma mark Accessors

- (void)setImageWidthFactor:(CGFloat)newValue;
{
    hasOverriddenImageSizeFactor = YES;
    _imageWidthFactor = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [secondFilterProgram use];
    glUniform1f(imageWidthFactorUniform, 1.0 / _imageWidthFactor);
}

- (void)setImageHeightFactor:(CGFloat)newValue;
{
    hasOverriddenImageSizeFactor = YES;
    _imageHeightFactor = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [secondFilterProgram use];
    glUniform1f(imageHeightFactorUniform, 1.0 / _imageHeightFactor);
}

-(void)setStrength:(CGFloat)strength {
    strength_ = strength;
    
}
@end
