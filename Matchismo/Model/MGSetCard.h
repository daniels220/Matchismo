//
//  MGSetCard.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCard.h"

#define SetShadingEmpty 0.0f
#define SetShadingShaded 0.25f
#define SetShadingFilled 1.0f

#define SetMinNumber 1
#define SetMaxNumber 3

@interface MGSetCard : MGCard

@property (strong,nonatomic) NSString* symbol;
@property (nonatomic) NSInteger number;
@property (strong,nonatomic) UIColor* color;
@property (nonatomic) float shading;

-(id)initWithSymbol:(NSString*)symbol number:(NSInteger)number color:(UIColor*)color shading:(float)shading;

-(NSAttributedString*) attributedString;

+(NSArray*) validSymbols;
+(NSArray*) validColors;

@end
