//
//  MGMatchingGame_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/10/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGame.h"

@interface MGMatchingGame ()

@property (strong,nonatomic) NSMutableArray* cards;

@property (nonatomic,readwrite) NSUInteger numFlips;
@property (nonatomic,readwrite) NSInteger score;
@property (strong,nonatomic) NSMutableArray* pastMoves;

@end
