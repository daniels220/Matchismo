//
//  MGGame_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame.h"

@interface MGGame ()

@property (strong,nonatomic) NSMutableArray* cards;
@property (nonatomic,readwrite) NSInteger score;

@end
