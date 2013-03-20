//
//  MGSetCard.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCard.h"

#define SetMinNumber 1
#define SetMaxNumber 3

typedef enum SetSymbol {
  SetSymbolSquiggle,
  SetSymbolDiamond,
	SetSymbolRacetrack
} SetSymbol;

typedef enum SetColor {
	SetColorRed,
	SetColorGreen,
	SetColorPurple
} SetColor;

typedef enum SetShading {
	SetShadingEmpty,
	SetShadingStriped,
	SetShadingFilled
} SetShading;

@interface MGSetCard : MGCard

@property (nonatomic) SetSymbol symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) SetColor color;
@property (nonatomic) SetShading shading;

-(id)initWithSymbol:(SetSymbol) symbol number:(NSUInteger)number color:(SetColor)color shading:(SetShading)shading;

@end
