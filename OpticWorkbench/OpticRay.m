//
//  OpticRay.m
//  OpticsWorkbench
//
//  Created by Bridger Maxwell on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpticRay.h"


void HSVtoRGB( CGFloat *r, CGFloat *g, CGFloat *b, CGFloat h, CGFloat s, CGFloat v );

CGPoint rayIntersectionOutsideRect(OpticRay *ray, NSRect rect) {
    //TODO: This doesn't work quite right with rays that start outside the rect use the line below to debug
    //rect = NSInsetRect(rect, 0.05, 0.05);
    
    BOOL intersects = CGRectContainsPoint(rect, ray.position);
    
    CGFloat xIntersection;
    CGFloat cosAngle = cos(ray.angle);
    if (cosAngle > 0) {
        //It will intersect on the right size
        xIntersection = (rect.origin.x + rect.size.width - ray.position.x) / cosAngle;
    } else if (cosAngle < 0) {
        //It will intersect on the left size
        xIntersection = (rect.origin.x - ray.position.x) / cosAngle;
    } else {
        //It will not intersect on the left or right
        xIntersection = CGFLOAT_MAX;
    }
    
    
    CGFloat yIntersection;
    CGFloat sinAngle = sin(ray.angle);
    if (sinAngle > 0) {
        //It will intersect on the top size
        yIntersection = (rect.origin.y + rect.size.width - ray.position.y) / sinAngle;
    } else if (sinAngle < 0) {
        //It will intersect on the bottom size
        yIntersection = (rect.origin.y - ray.position.y) / sinAngle;
    } else {
        //It will not intersect on the top or bottom
        yIntersection = CGFLOAT_MAX;
    }
    
    
    CGFloat minIntersectionDistance = MIN(xIntersection, yIntersection);
    
    if (intersects && minIntersectionDistance == CGFLOAT_MAX) {
        return ray.position;
    }
    
    return CGPointMake(ray.position.x + cos(ray.angle) * minIntersectionDistance, ray.position.y + sin(ray.angle) * minIntersectionDistance);
}

CGPoint rayPointAfterDistance(OpticRay *ray, CGFloat distance) {
    return CGPointMake(ray.position.x + cos(ray.angle) * distance, ray.position.y + sin(ray.angle) * distance);
}

void HSVtoRGB( CGFloat *r, CGFloat *g, CGFloat *b, CGFloat h, CGFloat s, CGFloat v )
{
	int i;
	float f, p, q, t;
	if( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	h /= 60;			// sector 0 to 5
	i = floor( h );
	f = h - i;			// factorial part of h
	p = v * ( 1 - s );
	q = v * ( 1 - s * f );
	t = v * ( 1 - s * ( 1 - f ) );
	switch( i ) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2:
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:		// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}

CGColorRef createRandomColor() {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    CGFloat brightness = 1.0;
    
    //Hue is random between 0 and 360
    CGFloat hue = (CGFloat)random() / RAND_MAX;
    hue *= 360.0;
    
    //Saturation is random between 0.7 and 1.0
    CGFloat saturation = (CGFloat)random() / RAND_MAX;
    saturation = saturation * 0.3 + 0.7;
    
    HSVtoRGB(&red, &green, &blue, hue, saturation, brightness);
    
    return CGColorCreateGenericRGB(red, green, blue, 1.0);
}

CGFloat normalizedAngle(CGFloat angle) {
    int timesOverPi = (int)floor((angle + M_PI) / (2 * M_PI));
    
    return angle - 2 * M_PI * timesOverPi;
}


@implementation OpticRay

@synthesize position = _position, angle = _angle, color = _color;

- (id)initWithPostion:(CGPoint)position angle:(CGFloat)angle color:(CGColorRef)color {
    self = [super init];
    if (self) {
        _position = position;
        _angle = angle;
        _color = CGColorRetain(color);
    }
    return self;
}

- (id)copyWithPosition:(CGPoint)position angle:(CGFloat)angle intensity:(CGFloat)intensity {  
    OpticRay *copy;
    if (intensity == 1) {
        copy = [[OpticRay alloc] initWithPostion:position angle:angle color:_color];
    } else {
        CGColorRef dimmedColor = CGColorCreateCopyWithAlpha(_color, CGColorGetAlpha(_color) * intensity);
        
        copy = [[OpticRay alloc] initWithPostion:position angle:angle color:dimmedColor];
        
        CGColorRelease(dimmedColor);
    }
    
    return copy;
}

- (void)dealloc {
    CGColorRelease(_color);
    
    [super dealloc];
}

+ (id)rayWithPositionPostion:(CGPoint)position angle:(CGFloat)angle color:(CGColorRef)color {
    return [[[OpticRay alloc] initWithPostion:position angle:angle color:color] autorelease];
}

@end




@implementation CapturedOpticRay

@synthesize position = _position, angle = _angle, color = _color;

- (id)initWithPostion:(CGFloat)position angle:(CGFloat)angle color:(CGColorRef)color {
    self = [super init];
    if (self) {
        _position = position;
        _angle = angle;
        _color = CGColorRetain(color);
    }
    return self;
}

- (void)dealloc {
    CGColorRelease(_color);
    
    [super dealloc];
}

@end
