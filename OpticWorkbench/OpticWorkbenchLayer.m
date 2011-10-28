//
//  OpticWorkbenchLayer.m
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticWorkbenchLayer.h"
#import "OpticRay.h"
#import "OpticTool.h"
#import "ToolEditor.h"

#import "OpticTools.h"

@interface OpticWorkbenchLayer ()
- (void)layoutOpticTool:(OpticTool *)tool;
@end

@implementation OpticWorkbenchLayer

@synthesize toolEditor = _toolEditor, toolsLayer = _toolsLayer, toolTemplatesLayer = _toolTemplatesLayer;

- (id)init {
    self = [super init];
    if (self) {
        _tools = [[NSMutableSet alloc] init];
        
        _rayLayer = [[CALayer alloc] init];
        [_rayLayer setFrame:self.bounds];
        _rayLayer.delegate = self;
        [_rayLayer setNeedsDisplayOnBoundsChange:YES];
        [self addSublayer:_rayLayer];
        
        _toolsLayer = [[CALayer alloc] init];
        [_toolsLayer setFrame:self.bounds];
        [self addSublayer:_toolsLayer];
        
        _toolTemplatesLayer = [[CALayer alloc] init];
        [_toolTemplatesLayer setFrame:self.bounds];
        [self addSublayer:_toolTemplatesLayer];
        
        _toolEditor = [[ToolEditor alloc] init];
        _toolEditor.workbench = self;
        for (CALayer *toolEditorLayer in [_toolEditor layers]) {
            [self addSublayer:toolEditorLayer];
        }
        
#define TEMPLATE_SPACING 0.05
#define TEMPLATE_SIZE 0.2
#define LIGHT_POINT_SIZE 0.05
        //Now set up the template tools
        Lens *testLens = [[[Lens alloc] init] autorelease];
        testLens.flatToolOrigin = CGPointMake(TEMPLATE_SPACING * 1, TEMPLATE_SPACING);
        testLens.angle = M_PI_2;
        testLens.length = TEMPLATE_SIZE;
        testLens.focalLength = 0.1;
        testLens.workbench = self;
        [_toolTemplatesLayer addSublayer:testLens];
        
        Mirror *testMirror = [[[Mirror alloc] init] autorelease];
        testMirror.flatToolOrigin = CGPointMake(TEMPLATE_SPACING * 2, TEMPLATE_SPACING);
        testMirror.angle = M_PI_2;
        testMirror.length = TEMPLATE_SIZE;
        testMirror.workbench = self;
        [_toolTemplatesLayer addSublayer:testMirror];
        
        BeamSplitter *testSplitter = [[[BeamSplitter alloc] init] autorelease];
        testSplitter.flatToolOrigin = CGPointMake(TEMPLATE_SPACING * 3, TEMPLATE_SPACING);
        testSplitter.angle = M_PI_2;
        testSplitter.length = TEMPLATE_SIZE;
        testSplitter.workbench = self;
        [_toolTemplatesLayer addSublayer:testSplitter];
        
        Obstacle *testObstacle = [[[Obstacle alloc] init] autorelease];
        testObstacle.flatToolOrigin = CGPointMake(TEMPLATE_SPACING * 4, TEMPLATE_SPACING);
        testObstacle.angle = M_PI_2;
        testObstacle.length = TEMPLATE_SIZE;
        testObstacle.workbench = self;
        [_toolTemplatesLayer addSublayer:testObstacle];
        
        
        ParabolicMirror *testParabola = [[[ParabolicMirror alloc] init] autorelease];
        testParabola.focalLength = 0.04;
        testParabola.length = 0.1;
        testParabola.angle = -M_PI_2;
        testParabola.gamePosition = CGPointMake(TEMPLATE_SPACING * 5 - 0.02, TEMPLATE_SPACING + 0.1);
        testParabola.workbench = self;
        [_toolTemplatesLayer addSublayer:testParabola];
        
        Beam *testBeam = [[[Beam alloc] init] autorelease];
        testBeam.flatToolOrigin = CGPointMake(TEMPLATE_SPACING * 6, TEMPLATE_SPACING);
        testBeam.angle = M_PI_2;
        testBeam.length = TEMPLATE_SIZE;
        testBeam.workbench = self;
        [_toolTemplatesLayer addSublayer:testBeam];
        
        LightPoint *testPoint = [[[LightPoint alloc] init] autorelease];
        testPoint.gameFrame = CGRectMake(TEMPLATE_SPACING * 7 - LIGHT_POINT_SIZE/2, 
                                         TEMPLATE_SPACING + TEMPLATE_SIZE / 2 - LIGHT_POINT_SIZE / 2, 
                                         LIGHT_POINT_SIZE, 
                                         LIGHT_POINT_SIZE);
        [_toolTemplatesLayer addSublayer:testPoint];
    }
    return self;
}

static inline CGPoint gameToPixelTransformPoint(CGPoint position, CGRect bounds) {
    return CGPointMake(position.x * bounds.size.width, 
                       position.y * bounds.size.height);
}

- (CGPoint)gameToPixelTransformPoint:(CGPoint)point {
    return gameToPixelTransformPoint(point, self.bounds);
}

static inline CGPoint pixelToGameTransformPoint(CGPoint position, CGRect bounds) {
    return CGPointMake(position.x / bounds.size.width, 
                       position.y / bounds.size.height);
}

- (CGPoint)pixelToGameTransformPoint:(CGPoint)point {
    return pixelToGameTransformPoint(point, self.bounds);
}

static inline CGRect gameToPixelTransformRect(CGRect rect, CGRect bounds) {
    return CGRectMake(rect.origin.x * bounds.size.width, 
                      rect.origin.y * bounds.size.height, 
                      rect.size.width * bounds.size.width, 
                      rect.size.height * bounds.size.height);
}

- (CGRect)gameToPixelTransformRect:(CGRect)rect {
    return gameToPixelTransformRect(rect, self.bounds);
}

static inline CGRect pixelToGameTransformRect(CGRect rect, CGRect bounds) {
    return CGRectMake(rect.origin.x / bounds.size.width, 
                      rect.origin.y / bounds.size.height, 
                      rect.size.width / bounds.size.width, 
                      rect.size.height / bounds.size.height);
}

- (CGRect)pixelToGameTransformRect:(CGRect)rect {
    return pixelToGameTransformRect(rect, self.bounds);
}



- (void)layoutSublayers {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _rayLayer.frame = self.bounds;
    _toolsLayer.frame = self.bounds;
    for (OpticTool *tool in _tools) {
        [self layoutOpticTool:tool];
    }
    for (OpticTool *tool in [_toolTemplatesLayer sublayers]) {
        [self layoutOpticTool:tool];
    }
    [CATransaction commit];
}

- (void)addOpticTool:(OpticTool *)tool {
    [_tools addObject:tool];
    tool.workbench = self;
    
    [_toolsLayer addSublayer:tool];
    [tool addObserver:self forKeyPath:@"gameFrame" options:NSKeyValueObservingOptionInitial context:nil];
    
    [_rayLayer setNeedsDisplay];
}

- (void)removeOpticTool:(OpticTool *)tool {
    [_tools removeObject:tool];
    tool.workbench = nil;
    
    [tool removeFromSuperlayer];
    [tool removeObserver:self forKeyPath:@"gameFrame"];
    
    [_rayLayer setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"gameFrame"]) {
        [self layoutOpticTool:(OpticTool *)object];
        
        [self opticToolAltered:(OpticTool *)object];
    }
}

- (void)opticToolAltered:(OpticTool *)tool {
    [_rayLayer setNeedsDisplay];
}

- (void)layoutOpticTool:(OpticTool *)tool {
    CGRect pixelFrame = gameToPixelTransformRect(tool.gameFrame, self.bounds);
    CGFloat inset = [tool drawingPixelInset];
    pixelFrame = CGRectInset(pixelFrame, inset, inset);
    pixelFrame.origin = CGPointZero;
    tool.bounds = pixelFrame;
    tool.position = gameToPixelTransformPoint(tool.gamePosition, self.bounds);
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == _rayLayer) {
        CGContextClearRect(ctx, self.bounds);
        
        CGContextSetLineWidth(ctx, 2.0);
        
        NSMutableSet *liveRays = [NSMutableSet set];
        for (OpticTool *tool in _tools) {
            [liveRays addObjectsFromArray:[tool startingRays]];
        }
        
        NSInteger iterations = 0;
#define MAX_ITERATIONS 500
        while ([liveRays count] > 0 && iterations < MAX_ITERATIONS) {
            iterations++;
            OpticRay *nextRay = [liveRays anyObject];
            [liveRays removeObject:nextRay];
            
            //Find the first tool that this ray intersects with
            CGFloat minIntersection = CGFLOAT_MAX;
            OpticTool *firstIntersection = NULL;
            for (OpticTool *tool in _tools) {
                CGFloat intersectionDistance = [tool rayIntersectionDistance:nextRay];
                if (intersectionDistance < minIntersection) {
                    minIntersection = intersectionDistance;
                    firstIntersection = tool;
                }
            }
            
            
            CGPoint rayStartPoint = gameToPixelTransformPoint(nextRay.position, self.bounds);
            CGPoint rayEndPoint;
            if (firstIntersection != NULL) {
                // Transform the ray. Add the results back into liveRays
                rayEndPoint = rayPointAfterDistance(nextRay, minIntersection);
                
                [liveRays addObjectsFromArray:[firstIntersection transformRay:nextRay atPoint:rayEndPoint afterDistance:minIntersection]];
                rayEndPoint = gameToPixelTransformPoint(rayEndPoint, [self bounds]);
                
            } else {
                // Draw the ray going off screen
                rayEndPoint = gameToPixelTransformPoint(rayIntersectionOutsideRect(nextRay, CGRectMake(-0.05, -0.05, 1.05, 1.05)), self.bounds);
            }
            
            
            //Draw the ray from
            CGContextMoveToPoint(ctx, rayStartPoint.x, rayStartPoint.y);
            CGContextAddLineToPoint(ctx, rayEndPoint.x, rayEndPoint.y);
            
            CGContextSetStrokeColorWithColor(ctx, nextRay.color);
            CGContextStrokePath(ctx);
        }
        
    } else {
        [super drawLayer:layer inContext:ctx];
    }
}


@end
