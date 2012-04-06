#import "SobelEdgeXGradientFilter.h"
#import "GPUImageGrayscaleFilter.h"

// Override vertex shader to remove dependent texture reads 
NSString *const kSobelEdgeXGradientVertexShaderString = SHADER_STRING
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
NSString *const kSobelEdgeXGradientFragmentShaderString = SHADER_STRING
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
    float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
    float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
    
//    float mag = length(vec2(h, v));
    
    gl_FragColor = vec4(vec3(h) * computeEdgeFactor, 1.0);
 }
);

//   Code from "Graphics Shaders: Theory and Practice" by M. Bailey and S. Cunningham 
NSString *const kSobelEdgeYGradientFragmentShaderString = SHADER_STRING
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
 float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
 float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
 
 //    float mag = length(vec2(h, v));
 
 gl_FragColor = vec4(vec3(v) * computeEdgeFactor, 1.0);
 }
 );

//   Code from "Graphics Shaders: Theory and Practice" by M. Bailey and S. Cunningham 
NSString *const kSobelEdgeBothGradientFragmentShaderString = SHADER_STRING
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
 float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
 float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
 
 float mag = length(vec2(h, v));
 gl_FragColor = vec4(vec3(mag) * computeEdgeFactor,1);
// float i0000   = texture2D(inputImageTexture, textureCoordinate).r;
// float im1m1 = texture2D(inputImageTexture, bottomLeftTextureCoordinate).r;
// float ip1p1 = texture2D(inputImageTexture, topRightTextureCoordinate).r;
// float im1p1 = texture2D(inputImageTexture, topLeftTextureCoordinate).r;
// float ip1m1 = texture2D(inputImageTexture, bottomRightTextureCoordinate).r;
// float im100 = texture2D(inputImageTexture, leftTextureCoordinate).r;
// float ip100 = texture2D(inputImageTexture, rightTextureCoordinate).r;
// float i0m10 = texture2D(inputImageTexture, bottomTextureCoordinate).r;
// float i0p10 = texture2D(inputImageTexture, topTextureCoordinate).r;
// float h0000 = -im1p1 - 2.0 * i0p10 - ip1p1 + im1m1 + 2.0 * i0m10 + ip1m1;
// float v0000 = -im1m1 - 2.0 * im100 - im1p1 + ip1m1 + 2.0 * ip100 + ip1p1;
// 
// float magR = length(vec2(h0000, v0000));
// 
// float im1m1g = texture2D(inputImageTexture, bottomLeftTextureCoordinate).g;
// float ip1p1g = texture2D(inputImageTexture, topRightTextureCoordinate).g;
// float im1p1g = texture2D(inputImageTexture, topLeftTextureCoordinate).g;
// float ip1m1g = texture2D(inputImageTexture, bottomRightTextureCoordinate).g;
// float im100g = texture2D(inputImageTexture, leftTextureCoordinate).g;
// float ip100g = texture2D(inputImageTexture, rightTextureCoordinate).g;
// float i0m10g = texture2D(inputImageTexture, bottomTextureCoordinate).g;
// float i0p10g = texture2D(inputImageTexture, topTextureCoordinate).g;
// float h0000g = -im1p1g - 2.0 * i0p10g - ip1p1g + im1m1g + 2.0 * i0m10g + ip1m1g;
// float v0000g = -im1m1g - 2.0 * im100g - im1p1g + ip1m1g + 2.0 * ip100g + ip1p1g;
// 
// float magG = length(vec2(h0000, v0000));
// 
// 
// float im1m1b = texture2D(inputImageTexture, bottomLeftTextureCoordinate).b;
// float ip1p1b = texture2D(inputImageTexture, topRightTextureCoordinate).b;
// float im1p1b = texture2D(inputImageTexture, topLeftTextureCoordinate).b;
// float ip1m1b = texture2D(inputImageTexture, bottomRightTextureCoordinate).b;
// float im100b = texture2D(inputImageTexture, leftTextureCoordinate).b;
// float ip100b = texture2D(inputImageTexture, rightTextureCoordinate).b;
// float i0m10b = texture2D(inputImageTexture, bottomTextureCoordinate).b;
// float i0p10b = texture2D(inputImageTexture, topTextureCoordinate).b;
// float h0000b = -im1p1b - 2.0 * i0p10b - ip1p1b + im1m1b + 2.0 * i0m10b + ip1m1b;
// float v0000b = -im1m1b - 2.0 * im100b - im1p1b + ip1m1b + 2.0 * ip100b + ip1p1b;
// 
// float magB = length(vec2(h0000, v0000));
// 
// 
// gl_FragColor = vec4(vec3(magR,magG,magB), 1.0);
 }
 );


NSString *const kSobelEdgeAddGradientFragmentShaderString = SHADER_STRING
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
 float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
 float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
 
 float mag = length(vec2(h, v));
 color += vec4(vec3(mag) * computeEdgeFactor,1);
 gl_FragColor = color;
 }
 );

NSString *const kSobelEdgeInverseGradientFragmentShaderString = SHADER_STRING
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
 float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
 float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
 
 float mag = 1.0 - length(vec2(h, v));
 gl_FragColor = vec4(vec3(mag) * computeEdgeFactor,1);

 }
 );

NSString *const kSobelEdgeLaplacianFragmentShaderString = SHADER_STRING
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
 float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
 float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
 
 float mag = 1.0 - length(vec2(h, v));
 gl_FragColor = vec4(vec3(mag) * computeEdgeFactor,1);
 
 }
 );


@implementation SobelEdgeXGradientFilter

@synthesize imageWidthFactor = _imageWidthFactor; 
@synthesize imageHeightFactor = _imageHeightFactor; 
@synthesize edgeFactor = edgeFactor_;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [self initWithFragmentShaderFromString:kSobelEdgeXGradientFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

- (id)initY;
{
    if (!(self = [self initWithFragmentShaderFromString:kSobelEdgeYGradientFragmentShaderString]))
        {
		return nil;
        }
    
    return self;
}

- (id)initBoth;
{
    if (!(self = [self initWithFragmentShaderFromString:kSobelEdgeBothGradientFragmentShaderString]))
        {
		return nil;
        }
    
    return self;
}

- (id)initAdd;
{
    if (!(self = [self initWithFragmentShaderFromString:kSobelEdgeAddGradientFragmentShaderString]))
        {
		return nil;
        }
    
    return self;
}

- (id)initInverse;
{
    if (!(self = [self initWithFragmentShaderFromString:kSobelEdgeInverseGradientFragmentShaderString]))
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
    
    if (!(self = [super initWithFirstStageVertexShaderFromString:kGPUImageVertexShaderString 
                              firstStageFragmentShaderFromString:kGPUImageLuminanceFragmentShaderString 
                               secondStageVertexShaderFromString:kSobelEdgeXGradientVertexShaderString 
                             secondStageFragmentShaderFromString:fragmentShaderString]))
    {
		return nil;
    }
    

    hasOverriddenImageSizeFactor = NO;
    
    imageWidthFactorUniform = [secondFilterProgram uniformIndex:@"imageWidthFactor"];
    imageHeightFactorUniform = [secondFilterProgram uniformIndex:@"imageHeightFactor"];
    edgeUnifrom = [secondFilterProgram uniformIndex:@"edgeFactor"];
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
        [secondFilterProgram use];
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

- (void)setEdgeFactor:(CGFloat)edgeFactor {
    edgeFactor_ = edgeFactor;
    [GPUImageOpenGLESContext useImageProcessingContext];
    [secondFilterProgram use];
    glUniform1f(edgeUnifrom, edgeFactor_);
}
@end

