#import "GPUImageTwoPassFilter.h"
extern NSString *const kSobelEdgeXGradientVertexShaderString;
extern NSString *const kSobelEdgeYGradientVertexShaderString;
extern NSString *const kSobelEdgeBothGradientVertexShaderString;


@interface SobelEdgeXGradientFilter : GPUImageTwoPassFilter
{
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
    BOOL hasOverriddenImageSizeFactor;
    CGFloat edgeFactor_;
    GLint edgeUnifrom;
}

// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
@property(readwrite, nonatomic) CGFloat imageWidthFactor; 
@property(readwrite, nonatomic) CGFloat imageHeightFactor; 
@property (nonatomic, readwrite) CGFloat edgeFactor;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initY;
- (id)initBoth;
- (id)initAdd;
- (id)initInverse;

@end
