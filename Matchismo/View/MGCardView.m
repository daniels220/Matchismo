//
//  MGCardView.m
//  Matchismo
//
//  Created by Daniel Slomovits on 3/20/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardView.h"

@implementation MGCardView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#define CORNER_FRACTION 0.1
- (void)drawRect:(CGRect)rect
{
	UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width*CORNER_FRACTION];
	[roundedRect addClip];
	
	UIColor* backgroundColor = (self.selected) ? [UIColor colorWithWhite:0.8 alpha:1] : [UIColor whiteColor];
	[backgroundColor setFill];
	UIRectFill(self.bounds);
	
	[[UIColor blackColor] setStroke];
	[roundedRect stroke];
	
	if (self.starred) {
		CGFloat fontSize = self.bounds.size.width * CORNER_FRACTION;
		NSAttributedString* str = [[NSAttributedString alloc] initWithString:@"★" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor blueColor]}];
		[str drawAtPoint:CGPointMake(fontSize/2, fontSize/2)];
	}
}

-(void)setFaceUp:(BOOL)faceUp {
	_faceUp = faceUp;
	[self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
	_selected = selected;
	[self setNeedsDisplay];
}

-(void)setStarred:(BOOL)starred {
	_starred = starred;
	[self setNeedsDisplay];
}

@end
