//
//  MGSetCard.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetCard.h"

@implementation MGSetCard

//OVERRIDES
-(NSString *)contents {
	char shadingChar;
	if (self.shading == SetShadingEmpty)
		shadingChar = 'E';
	else if (self.shading == SetShadingStriped)
		shadingChar = 'S';
	else
		shadingChar = 'F';
	
	char colorChar;
	if (self.color == SetColorRed)
		colorChar = 'R';
	else if (self.color == SetColorGreen)
		colorChar = 'G';
	else
		colorChar = 'P';
	
	NSString* symbol;
	if (self.symbol == SetSymbolSquiggle)
		symbol = @"~";
	else if (self.symbol == SetSymbolDiamond)
		symbol = @"♢";
	else
		symbol = @"0";
	
	NSMutableString *retVal = [NSMutableString stringWithFormat:@"%c%c",shadingChar,colorChar];
	for (int i=0; i<self.number; i++)
		[retVal appendString:symbol];
	
	return retVal.copy;
}

-(NSUInteger)match:(NSArray *)otherCards {
	if (otherCards.count != 2) return 0;
	MGSetCard* other1 = otherCards[0];
	MGSetCard* other2 = otherCards[1];
	
	SEL props[] = {
		@selector(symbol),
		@selector(color),
		@selector(shading),
		@selector(number)
	};
	for (int i=0; i<4; i++) {
		//XCode thinks this won't work, but it will, I know what selectors I'm using
		NSInteger propSelf = (NSInteger) [self performSelector:props[i]];
		NSInteger prop1 = (NSInteger) [other1 performSelector:props[i]];
		NSInteger prop2 = (NSInteger) [other2 performSelector:props[i]];
		if ((propSelf == prop1 && propSelf == prop2) ||
				(propSelf != prop1 && propSelf != prop2 && prop1 != prop2))
			; //We're good
		else
			return 0;
	}
	return 1;
}

//Designated initializer
-(id)initWithSymbol:(SetSymbol)symbol number:(NSUInteger)number color:(SetColor)color shading:(SetShading)shading {
	if (self = [super init]) {
		self.symbol = symbol;
		self.number = number;
		self.color = color;
		self.shading = shading;
	}
	return self;
}

//GET/SET
-(void)setSymbol:(SetSymbol)symbol {
	if (symbol >= SetSymbolSquiggle && symbol <= SetSymbolRacetrack)
		_symbol = symbol;
}

-(void)setColor:(SetColor)color {
	if (color >= SetColorRed && color <= SetColorPurple)
		_color = color;
}

-(void)setNumber:(NSUInteger)number {
	if (number >= SetMinNumber && number <= SetMaxNumber)
		_number = number;
}

-(void)setShading:(SetShading)shading {
	if (shading >= SetShadingEmpty && shading <= SetShadingFilled)
		_shading = shading;
}

@end
