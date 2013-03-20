//
//  MGSetCardView.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardView.h"
#import "MGSetCard.h" //Just for the enums, I swear

@interface MGSetCardView : MGCardView

@property (nonatomic) SetColor color;
@property (nonatomic) SetSymbol symbol;
@property (nonatomic) SetShading shading;
@property (nonatomic) NSUInteger number;

@end
