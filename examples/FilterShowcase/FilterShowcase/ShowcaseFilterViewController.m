#import "ShowcaseFilterViewController.h"
#import "SobelEdgeXGradientFilter.h"
#import "GPUGaussianFilter.h"
@implementation ShowcaseFilterViewController

@synthesize customKernel = customKernel_;

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
{
    self = [super initWithNibName:@"ShowcaseFilterViewController" bundle:nil];
    if (self) 
    {
        filterType = newFilterType;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFilter];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    [videoCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupFilter;
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRight];

    switch (filterType)
    {
        case GPUIMAGE_XSOBEL:
        {
        self.title = @"Sobel X";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[SobelEdgeXGradientFilter alloc] init];
        [(SobelEdgeXGradientFilter *)filter setKernel:customKernel_];
        }; break;
        
        case GPUIMAGE_YSOBEL:
        {
        self.title = @"Sobel Y";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[SobelEdgeXGradientFilter alloc] initY];
        [(SobelEdgeXGradientFilter *)filter setKernel:customKernel_];

        }; break;
        
        case GPUIMAGE_BOTHSOBEL:
        {
        self.title = @"Sobel Both";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[SobelEdgeXGradientFilter alloc] initBoth];
        [(SobelEdgeXGradientFilter *)filter setKernel:customKernel_];

        }; break;
        
        case GPUIMAGE_ADDSOBEL:
        {
        self.title = @"Sobel Add";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[SobelEdgeXGradientFilter alloc] initAdd];
        [(SobelEdgeXGradientFilter *)filter setKernel:customKernel_];

        }; break;
        
        case GPUIMAGE_Inverse:
        {
        self.title = @"Sobel Inverse";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[SobelEdgeXGradientFilter alloc] initInverse];
        [(SobelEdgeXGradientFilter *)filter setKernel:customKernel_];

        }; break;
        
        
        
        case GPUIMAGE_GAUSSIAN1:
        {
        self.title = @"Gaussian";
        self.filterSettingsSlider.hidden = YES;
        
        [self.filterSettingsSlider setValue:1.0];
        [self.filterSettingsSlider setMinimumValue:0.0];
        [self.filterSettingsSlider setMaximumValue:1.0];
        
        filter = [[GPUGaussianFilter alloc] init];

            [(GPUGaussianFilter *)filter setGaussianValues:customKernel_];

        }; break;
            /*
            
//        case GPUIMAGE_LAPLACIAN:
//        {
//            self.title = @"Laplacian";
//            self.filterSettingsSlider.hidden = NO;
//            
//            [self.filterSettingsSlider setValue:0.0];
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:1.0];
//            
//            filter = [[GPULapacianFilter alloc] initAdd];
//        }; break;
        
        
        
        
        
        case GPUIMAGE_SEPIA:
        {
            self.title = @"Sepia Tone";
            self.filterSettingsSlider.hidden = NO;

            [self.filterSettingsSlider setValue:1.0];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            
            filter = [[GPUImageSepiaFilter alloc] init];
        }; break;
        case GPUIMAGE_PIXELLATE:
        {
            self.title = @"Pixellate";
            self.filterSettingsSlider.hidden = NO;

            [self.filterSettingsSlider setValue:0.05];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:0.3];
            
            filter = [[GPUImagePixellateFilter alloc] init];
        }; break;
        case GPUIMAGE_POLARPIXELLATE:
        {
            self.title = @"Polar Pixellate";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:0.05];
            [self.filterSettingsSlider setMinimumValue:-0.1];
            [self.filterSettingsSlider setMaximumValue:0.1];
            
            filter = [[GPUImagePolarPixellateFilter alloc] init];
        }; break;
        case GPUIMAGE_CROSSHATCH:
        {
            self.title = @"Crosshatch";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageCrosshatchFilter alloc] init];
        }; break;
             */
        case GPUIMAGE_COLORINVERT:
        {
            self.title = @"Color Invert";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageColorInvertFilter alloc] init];
        }; break;
            /*
        case GPUIMAGE_GRAYSCALE:
        {
            self.title = @"Grayscale";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageGrayscaleFilter alloc] init];
        }; break;
             
             */
        case GPUIMAGE_SATURATION:
        {
            self.title = @"Saturation";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:1.0];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            
            filter = [[GPUImageSaturationFilter alloc] init];
        }; break;
        case GPUIMAGE_CONTRAST:
        {
            self.title = @"Contrast";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageContrastFilter alloc] init];
        }; break;
        case GPUIMAGE_BRIGHTNESS:
        {
            self.title = @"Brightness";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageBrightnessFilter alloc] init];
        }; break;
        case GPUIMAGE_EXPOSURE:
        {
            self.title = @"Exposure";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-4.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageExposureFilter alloc] init];
        }; break;
            /*
        case GPUIMAGE_SHARPEN:
        {
            self.title = @"Sharpen";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageSharpenFilter alloc] init];
        }; break;
             */
        case GPUIMAGE_UNSHARPMASK:
        {
            self.title = @"Unsharp Mask";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:5.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageUnsharpMaskFilter alloc] init];
            
//            [(GPUImageUnsharpMaskFilter *)filter setIntensity:3.0];
        }; break;
            
            /*
        case GPUIMAGE_GAMMA:
        {
            self.title = @"Gamma";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:3.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageGammaFilter alloc] init];
        }; break;
		case GPUIMAGE_HAZE:
        {
            self.title = @"Haze / UV";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-0.2];
            [self.filterSettingsSlider setMaximumValue:0.2];
            [self.filterSettingsSlider setValue:0.2];
            
            filter = [[GPUImageHazeFilter alloc] init];
        }; break;
		case GPUIMAGE_THRESHOLD:
        {
            self.title = @"Luminance Threshold";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageLuminanceThresholdFilter alloc] init];
        }; break;
		case GPUIMAGE_ADAPTIVETHRESHOLD:
        {
            self.title = @"Adaptive Threshold";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_CROP:
        {
            self.title = @"Crop";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.3];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 0.5, 0.5)];
        }; break;
        case GPUIMAGE_TRANSFORM:
        {
            self.title = @"Transform (2-D)";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:6.28];
            [self.filterSettingsSlider setValue:2.0];
            
            filter = [[GPUImageTransformFilter alloc] init];
            [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation(2.0)];
        }; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            self.title = @"Transform (3-D)";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:6.28];
            [self.filterSettingsSlider setValue:0.75];
            
            filter = [[GPUImageTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];
        }; break;
        case GPUIMAGE_SOBELEDGEDETECTION:
        {
            self.title = @"Edge Detection";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_SKETCH:
        {
            self.title = @"Sketch";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageSketchFilter alloc] init];
        }; break;
        case GPUIMAGE_TOON:
        {
            self.title = @"Toon";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageToonFilter alloc] init];
        }; break;            
        case GPUIMAGE_CGA:
        {
            self.title = @"CGA Colorspace";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageCGAColorspaceFilter alloc] init];
        }; break;

        case GPUIMAGE_POSTERIZE:
        {
            self.title = @"Posterize";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:20.0];
            [self.filterSettingsSlider setValue:10.0];
            
            filter = [[GPUImagePosterizeFilter alloc] init];
        }; break;
        case GPUIMAGE_SWIRL:
        {
            self.title = @"Swirl";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageSwirlFilter alloc] init];
        }; break;
        case GPUIMAGE_BULGE:
        {
            self.title = @"Bulge";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageBulgeDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_PINCH:
        {
            self.title = @"Pinch";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-2.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImagePinchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_STRETCH:
        {
            self.title = @"Stretch";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageStretchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_CHROMAKEY:
        {
            self.title = @"Chroma Key (Green)";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.4];
            
            filter = [[GPUImageChromaKeyBlendFilter alloc] init];
            [(GPUImageChromaKeyBlendFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }; break;
        case GPUIMAGE_MULTIPLY:
        {
            self.title = @"Multiply Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageMultiplyBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_OVERLAY:
        {
            self.title = @"Overlay Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageOverlayBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LIGHTEN:
        {
            self.title = @"Lighten Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageLightenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DARKEN:
        {
            self.title = @"Darken Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageDarkenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DISSOLVE:
        {
            self.title = @"Dissolve Blend";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageDissolveBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SCREENBLEND:
        {
            self.title = @"Screen Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageScreenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORBURN:
        {
            self.title = @"Color Burn Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageColorBurnBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORDODGE:
        {
            self.title = @"Color Dodge Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageColorDodgeBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_EXCLUSIONBLEND:
        {
            self.title = @"Exlusion Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageExclusionBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DIFFERENCEBLEND:
        {
            self.title = @"Difference Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageDifferenceBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_HARDLIGHTBLEND:
        {
            self.title = @"Hard Light Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageHardLightBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SOFTLIGHTBLEND:
        {
            self.title = @"Soft Light Blend";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageSoftLightBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_CUSTOM:
        {
            self.title = @"Custom";
            self.filterSettingsSlider.hidden = YES;

            filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
        }; break;
        case GPUIMAGE_KUWAHARA:
        {
            self.title = @"Kuwahara";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:3.0];
            [self.filterSettingsSlider setMaximumValue:8.0];
            [self.filterSettingsSlider setValue:3.0];
            
            filter = [[GPUImageKuwaharaFilter alloc] init];
        }; break;
            
        case GPUIMAGE_VIGNETTE:
        {
             self.title = @"Vignette";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:0.74];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageVignetteFilter alloc] init];
        }; break;

        case GPUIMAGE_GAUSSIAN:
        {
            self.title = @"Gaussian Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:10.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageGaussianBlurFilter alloc] init];
        }; break;

        case GPUIMAGE_FASTBLUR:
        {
            self.title = @"Fast Blur";
            self.filterSettingsSlider.hidden = NO;
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:10.0];
            [self.filterSettingsSlider setValue:1.0];

            filter = [[GPUImageFastBlurFilter alloc] init];
		}; break;
        case GPUIMAGE_BOXBLUR:
        {
            self.title = @"Box Blur";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageBoxBlurFilter alloc] init];
		}; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE:
        {
            self.title = @"Selective Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:.75f];
            [self.filterSettingsSlider setValue:40.0/320.0];
            
            filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
            [(GPUImageGaussianSelectiveBlurFilter*)filter setExcludeCircleRadius:40.0/320.0];
        }; break;
        case GPUIMAGE_FILTERGROUP:
        {
            self.title = @"Filter Group";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:0.05];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:0.3];
            
            filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:sepiaFilter];

            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(GPUImageFilterGroup *)filter setTerminalFilter:pixellateFilter];
        }; break;
             */

        default: filter = [[GPUImageSepiaFilter alloc] init]; break;
    }
    
//    if (filterType == GPUIMAGE_FILECONFIG) 
//    {
//        self.title = @"File Configuration";
//        pipeline = [[GPUImageFilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]
//                                                                                               input:videoCamera output:(GPUImageView*)self.view];
//        
//        [pipeline addFilter:rotationFilter atIndex:0];
//    } 
//    else 
//    {
        [videoCamera addTarget:rotationFilter];
        [rotationFilter addTarget:filter];
        videoCamera.runBenchmark = YES;
        
        if (filterType != GPUIMAGE_UNSHARPMASK)
        {
            // The picture is only used for two-image blend filters
            UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            [sourcePicture addTarget:filter];
        }

        GPUImageView *filterView = (GPUImageView *)self.view;
        [filter addTarget:filterView];
//    } 

    [videoCamera startCameraCapture];    
}

#pragma mark -
#pragma mark Filter adjustments

- (IBAction)updateFilterFromSlider:(id)sender;
{
    switch(filterType)
    {
//        case GPUIMAGE_BOTHSOBEL: [(SobelEdgeXGradientFilter *)filter setEdgeFactor:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_XSOBEL: [(SobelEdgeXGradientFilter *)filter setEdgeFactor:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_YSOBEL: [(SobelEdgeXGradientFilter *)filter setEdgeFactor:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_ADDSOBEL: [(SobelEdgeXGradientFilter *)filter setEdgeFactor:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_Inverse: [(SobelEdgeXGradientFilter *)filter setEdgeFactor:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_GAUSSIAN1: [(GPUGaussianFilter *)filter setBlurSize:[(UISlider *)sender value]]; break;


/*
        case GPUIMAGE_SEPIA: [(GPUImageSepiaFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PIXELLATE: [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POLARPIXELLATE: [(GPUImagePolarPixellateFilter *)filter setPixelSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
 */
        case GPUIMAGE_SATURATION: [(GPUImageSaturationFilter *)filter setSaturation:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CONTRAST: [(GPUImageContrastFilter *)filter setContrast:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BRIGHTNESS: [(GPUImageBrightnessFilter *)filter setBrightness:[(UISlider *)sender value]]; break;
        case GPUIMAGE_EXPOSURE: [(GPUImageExposureFilter *)filter setExposure:[(UISlider *)sender value]]; break;
            /*
        case GPUIMAGE_SHARPEN: [(GPUImageSharpenFilter *)filter setSharpness:[(UISlider *)sender value]]; break;
             */
        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setBlurSize:[(UISlider *)sender value]]; break;
            /*
        case GPUIMAGE_GAMMA: [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POSTERIZE: [(GPUImagePosterizeFilter *)filter setColorLevels:round([(UISlider*)sender value])]; break;
		case GPUIMAGE_HAZE: [(GPUImageHazeFilter *)filter setDistance:[(UISlider *)sender value]]; break;
		case GPUIMAGE_THRESHOLD: [(GPUImageLuminanceThresholdFilter *)filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_DISSOLVE: [(GPUImageDissolveBlendFilter *)filter setMix:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CHROMAKEY: [(GPUImageChromaKeyBlendFilter *)filter setThresholdSensitivity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_KUWAHARA: [(GPUImageKuwaharaFilter *)filter setRadius:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_SWIRL: [(GPUImageSwirlFilter *)filter setAngle:[(UISlider *)sender value]]; break;
//        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PINCH: [(GPUImagePinchDistortionFilter *)filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_VIGNETTE: [(GPUImageVignetteFilter *)filter setY:[(UISlider *)sender value]]; break;
        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_FASTBLUR: [(GPUImageFastBlurFilter *)filter setBlurPasses:round([(UISlider*)sender value])]; break;
//        case GPUIMAGE_FASTBLUR: [(GPUImageFastBlurFilter *)filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE: [(GPUImageGaussianSelectiveBlurFilter *)filter setExcludeCircleRadius:[(UISlider*)sender value]]; break;
        case GPUIMAGE_FILTERGROUP: [(GPUImagePixellateFilter *)[(GPUImageFilterGroup *)filter filterAtIndex:1] setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CROP: [(GPUImageCropFilter *)filter setCropRegion:CGRectMake(0.0, 0.0, [(UISlider*)sender value], [(UISlider*)sender value])]; break;
        case GPUIMAGE_TRANSFORM: [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation([(UISlider*)sender value])]; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, [(UISlider*)sender value], 0.0, 1.0, 0.0);

            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];            
        }; break;
             */
        default: break;
    }
}

#pragma mark -
#pragma mark Accessors

@synthesize filterSettingsSlider = _filterSettingsSlider;

@end
