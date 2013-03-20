//
//  MGSetDeck.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetDeck.h"
#import "MGSetCard.h"

@implementation MGSetDeck

-(id)init {
	if (self = [super init]) {
		for (NSInteger symbol = SetSymbolSquiggle; symbol <= SetSymbolRacetrack; symbol++)
			for (NSUInteger number = SetMinNumber; number <= SetMaxNumber; number++)
				for (NSInteger color = SetColorRed; color <= SetColorPurple; color++)
					for (NSInteger shading = SetShadingEmpty; shading <= SetShadingFilled; shading++)
						[self addCard:[[MGSetCard alloc] initWithSymbol:symbol number:number color:color shading:shading]];
	}
	return self;
}

@end
