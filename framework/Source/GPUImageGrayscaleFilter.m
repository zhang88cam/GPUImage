#import "GPUImageGrayscaleFilter.h"

@implementation GPUImageGrayscaleFilter

NSString *const kGPUImageLuminanceFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     float luminance = dot(texture2D(inputImageTexture, textureCoordinate).rgb, W);
     
//     gl_FragColor = vec4(vec3(luminance), 1.0);
    vec4 color = texture2D(inputImageTexture, textureCoordinate);
//    gl_FragColor = vec4(texture2D(inputImageTexture, textureCoordinate).rgb, 1.0);
 gl_FragColor  = color;

 }
);

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLuminanceFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}


@end
