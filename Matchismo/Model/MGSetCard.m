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
	else if (self.shading == SetShadingShaded)
		shadingChar = 'S';
	else
		shadingChar = 'F';
	
	char colorChar;
	if ([self.color isEqual:[UIColor redColor]])
		colorChar = 'R';
	else if ([self.color isEqual:[UIColor greenColor]])
		colorChar = 'G';
	else
		colorChar = 'P';
	
	NSMutableString *retVal = [NSMutableString stringWithFormat:@"%c%c",shadingChar,colorChar];
	for (int i=0; i<self.number; i++)
		[retVal appendString:self.symbol];
	
	return retVal.copy;
}

-(NSUInteger)match:(NSArray *)otherCards {
	if (otherCards.count != 2) return 0;
	MGSetCard* other1 = otherCards[0];
	MGSetCard* other2 = otherCards[1];
	
	BOOL symOK = FALSE, colorOK = FALSE, shadeOK = FALSE, numOK = FALSE;
	
	//Symbols all the same
	if ([self.symbol isEqualToString:other1.symbol] &&
			[self.symbol isEqualToString:other2.symbol])
		symOK = TRUE;
	//Symbols all different
	else if (![self.symbol isEqualToString:other1.symbol] &&
					 ![self.symbol isEqualToString:other2.symbol] &&
					 ![other1.symbol isEqualToString:other2.symbol])
		symOK = TRUE;
	
	//Colors all the same
	if ([self.color isEqual:other1.color] &&
			[self.color isEqual:other2.color])
		colorOK = TRUE;
	//Colors all different
	else if (![self.color isEqual:other1.color] &&
					 ![self.color isEqual:other2.color] &&
					 ![other1.color isEqual:other2.color])
		colorOK = TRUE;
	
	//Shading all the same
	if (self.shading == other1.shading && self.shading == other2.shading)
		shadeOK = TRUE;
	//Shading all different
	else if (self.shading != other1.shading && self.shading != other2.shading && other1.shading != other2.shading)
		shadeOK = TRUE;
	
	//Number all the same
	if (self.number == other1.number && self.number == other2.number)
		numOK = TRUE;
	//Number all different
	else if (self.number != other1.number && self.number != other2.number && other1.number != other2.number)
		numOK = TRUE;
	
	return (NSUInteger) symOK && colorOK && shadeOK && numOK;
}

//Designated initializer
-(id)initWithSymbol:(NSString *)symbol number:(NSInteger)number color:(UIColor*)color shading:(float)shading {
	if (self = [super init]) {
		self.symbol = symbol;
		self.number = number;
		self.color = color;
		self.shading = shading;
	}
	return self;
}

-(NSAttributedString *)attributedString {
	
	NSMutableString* baseStr = [NSMutableString new];
	for (int i=0; i<self.number; i++)
		[baseStr appendString:self.symbol];
	
	NSDictionary* attributes = @{
		NSStrokeWidthAttributeName: @-5,
		NSStrokeColorAttributeName: self.color,
		NSForegroundColorAttributeName: [self.color colorWithAlphaComponent:self.shading]
	};
	
	return [[NSAttributedString alloc] initWithString:baseStr attributes:attributes];
}

//GET/SET
@synthesize symbol = _symbol;

-(NSString *)symbol {
	if (!_symbol) return @"?";
	return _symbol;
}

-(void)setSymbol:(NSString *)symbol {
	if ([self.class.validSymbols containsObject:symbol])
		_symbol = symbol;
}

@synthesize color = _color;

-(UIColor *)color {
	if (!_color) return UIColor.blackColor;
	return _color;
}

-(void)setColor:(UIColor *)color {
	if ([self.class.validColors containsObject:color])
		_color = color;
}

-(void)setNumber:(NSInteger)number {
	if (number >= SetMinNumber && number <= SetMaxNumber)
		_number = number;
}

+(NSArray *)validSymbols {
	return @[@"▲",@"●",@"■"];
}

+(NSArray *)validColors {
	return @[UIColor.redColor,UIColor.greenColor,UIColor.purpleColor];
}

@end
