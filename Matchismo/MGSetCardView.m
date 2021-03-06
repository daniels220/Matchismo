//
//  MGSetCardView.m
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetCardView.h"

@implementation MGSetCardView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
		
	[self.strokeColor setStroke];
	[self.backgroundPattern setFill];
	for (int i=0; i<self.number; i++) {
		UIBezierPath* path = [self pathForSymbol:i];
		[path stroke];
		[path fill];
	}
}

-(UIColor*)strokeColor {
	return @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]][self.color];
}

-(UIColor*)backgroundPattern {
	switch (self.shading) {
		case SetShadingEmpty:
			return [UIColor clearColor];
		case SetShadingFilled:
			return self.strokeColor;
		case SetShadingStriped:
			//Create an image with 1px of color and 4px of clear
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 3), NO, 0);
			[self.strokeColor setFill];
			//Fill a 1x1 rectangle at the top to make the one colored pixel
			[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 1)] fill];
			UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			return [UIColor colorWithPatternImage:img];
	}
}

#define SYMBOL_SCALE 0.6
-(UIBezierPath*)pathForSymbol:(NSInteger)symNumber {
	switch (self.symbol) {
		case SetSymbolSquiggle:
			return [self squiggleInRect:[self boundsForSymbol:symNumber]];
		case SetSymbolDiamond:
			return [self diamondInRect:[self boundsForSymbol:symNumber]];
		case SetSymbolRacetrack:
			return [self racetrackInRect:[self boundsForSymbol:symNumber]];
		default:
			return nil;
	}
}

-(UIBezierPath*) diamondInRect:(CGRect)rect {
	UIBezierPath* diamond = [[UIBezierPath alloc] init];
	[diamond moveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y)];
	[self addCurveInRect:rect toBezierPath:diamond toPointX:1.0 y:0.5];
	[self addCurveInRect:rect toBezierPath:diamond toPointX:0.5 y:1.0];
	[self addCurveInRect:rect toBezierPath:diamond toPointX:0 y:0.5];
	[self addCurveInRect:rect toBezierPath:diamond toPointX:0.5 y:0];
	return diamond;
}

- (UIBezierPath*)squiggleInRect:(CGRect)rect {
	UIBezierPath *squiggle = [[UIBezierPath alloc] init];
	[squiggle moveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.6, rect.origin.y)];
	for (NSArray* pt in @[
			 @[@0.1,@0.25,@0.2,@0,@0.1,@0.12],
			 @[@0.3,@0.6,@0.1,@0.45,@0.3,@0.45],
			 @[@0,@0.9,@0.35,@0.72,@0.05,@0.8],
			 @[@0.32,@1,@0.05,@0.95,@0.2,@1],
			 @[@0.85,@0.7,@0.5,@1,@0.85,@0.85],
			 @[@0.75,@0.4,@0.85,@0.55,@0.75,@0.55],
			 @[@1,@0.13,@0.75,@0.26,@1.05,@0.19],
			 @[@0.6,@0,@1.05,@0.07,@0.8,@0]
			 ])
		[self addCurveInRect:rect
						toBezierPath:squiggle
								toPointX:[pt[0] doubleValue]
											 y:[pt[1] doubleValue]
							 controlX1:[pt[2] doubleValue]
							 controlY1:[pt[3] doubleValue]
							 controlX2:[pt[4] doubleValue]
							 controlY2:[pt[5] doubleValue]
		 ];
	return squiggle;
}

- (UIBezierPath*) racetrackInRect:(CGRect)rect {
	return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2];
}

-(void)addCurveInRect:(CGRect)rect toBezierPath:(UIBezierPath*)path toPointX:(CGFloat)x y:(CGFloat)y {
	[self addCurveInRect:rect toBezierPath:path toPointX:x y:y controlX1:x controlY1:y controlX2:x controlY2:y];
}

- (void)addCurveInRect:(CGRect)rect toBezierPath:(UIBezierPath *)path toPointX:(CGFloat)x y:(CGFloat)y controlX1:(CGFloat)x1 controlY1:(CGFloat)y1 controlX2:(CGFloat)x2 controlY2:(CGFloat)y2
{
	[path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * x, rect.origin.y + rect.size.height * y) controlPoint1:CGPointMake(rect.origin.x + rect.size.width * x1, rect.origin.y + rect.size.height * y1) controlPoint2:CGPointMake(rect.origin.x + rect.size.width * x2, rect.origin.y + rect.size.height * y2)];
}

-(CGRect) boundsForSymbol:(NSInteger)symNumber {
	CGFloat height = self.bounds.size.height * SYMBOL_SCALE;
	CGFloat width = height / 2;
	CGFloat y = (1.0-SYMBOL_SCALE)/2*self.bounds.size.height;
	//A sort of "default" x position, that of the center symbol when there are 1 or 3 symbols
	CGFloat x = self.bounds.size.width/2 - width/2;
	if (self.number == 1 || (self.number == 3 && symNumber == 2))
		; //X has already been set correctly
	else if (self.number == 3) {
		CGFloat offset = width * (1.0 + 1 - SYMBOL_SCALE);
		if (symNumber == 1)
			x -= offset;
		else
			x += offset;
	}
	else {
		CGFloat offset = width * (1.0 + 1 - SYMBOL_SCALE) / 2;
		if (symNumber == 1)
			x -= offset;
		else
			x += offset;
	}
	return CGRectMake(x, y, width, height);
}

-(void)setColor:(SetColor)color {
	_color = color;
	[self setNeedsDisplay];
}

-(void)setSymbol:(SetSymbol)symbol {
	_symbol = symbol;
	[self setNeedsDisplay];
}

-(void)setNumber:(NSUInteger)number {
	_number = number;
	[self setNeedsDisplay];
}

-(void)setShading:(SetShading)shading {
	_shading = shading;
	[self setNeedsDisplay];
}

@end
