//
//  TYMProgressBarView.m
//  TYMProgressBarView
//
//  Created by Yiming Tang on 6/7/13.
//  Copyright (c) 2013 - 2016 Yiming Tang. All rights reserved.
//

#import "TYMProgressBarView.h"

void strokeRectInContext(CGContextRef context, CGRect rect, CGFloat lineWidth, CGFloat radius);
void fillRectInContext(CGContextRef context, CGRect rect, CGFloat radius);
void setRectPathInContext(CGContextRef context, CGRect rect, CGFloat radius);

@interface TYMProgressBarView()

@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation TYMProgressBarView

#pragma mark - Accessors

@synthesize progress = _progress;
@synthesize barBorderWidth = _barBorderWidth;
@synthesize barBorderColor = _barBorderColor;
@synthesize barInnerBorderWidth = _barInnerBorderWidth;
@synthesize barInnerBorderColor = _barInnerBorderColor;
@synthesize barInnerPadding = _barInnerPadding;
@synthesize barFillColor = _barFillColor;
@synthesize barBackgroundColor = _barBackgroundColor;
@synthesize usesRoundedCorners = _usesRoundedCorners;
@synthesize showLabel = _showLabel;
@synthesize labelFont = _labelFont;
@synthesize labelColor = _labelColor;



- (void)setProgress:(CGFloat)newProgress {
    _progress = fmaxf(0.0, fminf(1.0, newProgress));
    [self setNeedsDisplay];
}


- (void)setBarBorderWidth:(CGFloat)barBorderWidth {
    _barBorderWidth = barBorderWidth;
    [self setNeedsDisplay];
}



- (void)setBarBorderColor:(UIColor *)barBorderColor {
    _barBorderColor = barBorderColor;
    [self setNeedsDisplay];
}


- (void)setBarInnerBorderWidth:(CGFloat)barInnerBorderWidth {
    _barInnerBorderWidth = barInnerBorderWidth;
    [self setNeedsDisplay];
}


- (void)setBarInnerBorderColor:(UIColor *)barInnerBorderColor {
    _barInnerBorderColor = barInnerBorderColor;
    [self setNeedsDisplay];
}


- (void)setBarInnerPadding:(CGFloat)barInnerPadding {
    _barInnerPadding = barInnerPadding;
    [self setNeedsDisplay];
}


- (void)setBarFillColor:(UIColor *)barFillColor {
    _barFillColor = barFillColor;
    [self setNeedsDisplay];
}


- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    _barBackgroundColor = barBackgroundColor;
    [self setNeedsDisplay];
}


- (void)setUsesRoundedCorners:(NSInteger)usesRoundedCorners {
    _usesRoundedCorners = usesRoundedCorners;
    [self setNeedsDisplay];
}

- (void)setShowLabel:(NSInteger)showLabel {
    _showLabel = showLabel;
    [self setNeedsDisplay];
}

-(void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    if (_progressLabel) {
        _progressLabel.font = _labelFont;
    }
}

-(void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    if (_progressLabel) {
        _progressLabel.textColor = _labelColor;
    }
}

#pragma mark - Class Methods

+ (UIColor *)defaultBarColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)defaultLabelColor {
    return [UIColor blackColor];
}


+ (void)initialize {
    if (self == [TYMProgressBarView class]) {
        TYMProgressBarView *appearance = [TYMProgressBarView appearance];
        [appearance setShowLabel:YES];
        [appearance setLabelFont:[UIFont boldSystemFontOfSize:15.0]];
        [appearance setLabelColor:[self defaultLabelColor]];
        [appearance setUsesRoundedCorners:YES];
        [appearance setProgress:0];
        [appearance setBarBorderWidth:2.0];
        [appearance setBarBorderColor:[self defaultBarColor]];
        [appearance setBarInnerBorderWidth:0];
        [appearance setBarInnerBorderColor:nil];
        [appearance setBarInnerPadding:2.0];
        [appearance setBarFillColor:[self defaultBarColor]];
        [appearance setBarBackgroundColor:[UIColor whiteColor]];
    }
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = _labelColor ? _labelColor : [TYMProgressBarView defaultLabelColor];
        _progressLabel.font = _labelFont;
        _progressLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _progressLabel;
}

- (id)initWithFrame:(CGRect)aFrame {
    if ((self = [super initWithFrame:aFrame])) {
        [self initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAllowsAntialiasing(context, TRUE);
    
    CGRect currentRect = rect;
    CGFloat radius = 0;
    CGFloat halfLineWidth = 0;
    
    // Background
    if (self.backgroundColor) {
        if (self.usesRoundedCorners) radius = currentRect.size.height / 2.0;
        
        [self.barBackgroundColor setFill];
        fillRectInContext(context, currentRect, radius);
    }
    
    // Border
    if (self.barBorderColor && self.barBorderWidth > 0.0) {
        // Inset, because a stroke is centered on the path
        // See http://stackoverflow.com/questions/10557157/drawing-rounded-rect-in-core-graphics
        halfLineWidth = self.barBorderWidth / 2.0;
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
        if (self.usesRoundedCorners) radius = currentRect.size.height / 2.0;
        
        [self.barBorderColor setStroke];
        strokeRectInContext(context, currentRect, self.barBorderWidth, radius);
        
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
    }
    
    // Padding
    currentRect = CGRectInset(currentRect, self.barInnerPadding, self.barInnerPadding);
    
    BOOL hasInnerBorder = NO;
    // Inner border
    if (self.barInnerBorderColor && self.barInnerBorderWidth > 0.0) {
        hasInnerBorder = YES;
        halfLineWidth = self.barInnerBorderWidth / 2.0;
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
        if (self.usesRoundedCorners) radius = currentRect.size.height / 2.0;
        
        // progress
        currentRect.size.width *= self.progress;
        currentRect.size.width = fmaxf(currentRect.size.width, 2 * radius);
        
        [self.barInnerBorderColor setStroke];
        strokeRectInContext(context, currentRect, self.barInnerBorderWidth, radius);
        
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
    }
    
    // Fill
    if (self.barFillColor) {
        if (self.usesRoundedCorners) radius = currentRect.size.height / 2;
        
        // recalculate width
        if (!hasInnerBorder) {
            currentRect.size.width *= self.progress;
            currentRect.size.width = fmaxf(currentRect.size.width, 2 * radius);
        }
        
        [self.barFillColor setFill];
        fillRectInContext(context, currentRect, radius);
    }
    
    // Restore the context
    CGContextRestoreGState(context);
    
    if (!self.showLabel) {
        [self.progressLabel removeFromSuperview];
    } else {
        if (!self.progressLabel.superview) {
            [self addSubview:self.progressLabel];
        }
        CGFloat padding = 8;
        if (self.progress > 0.5) {
            // position label INSIDE fill bar
            self.progressLabel.frame = CGRectMake(0, 0, currentRect.size.width - padding, self.bounds.size.height);
            self.progressLabel.textAlignment = NSTextAlignmentRight;
            self.progressLabel.textColor = self.barBackgroundColor;
        } else {
            // position label OUTSIDE fill bar
            self.progressLabel.frame = CGRectMake(currentRect.size.width + padding, 0, rect.size.width - currentRect.size.width - padding, self.bounds.size.height);
            self.progressLabel.textAlignment = NSTextAlignmentLeft;
            self.progressLabel.textColor = self.barFillColor;
        }
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.progress*100];
    }
}


#pragma mark - Private

- (void)initialize {
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
}

@end

#pragma mark - Drawing Functions

void strokeRectInContext(CGContextRef context, CGRect rect, CGFloat lineWidth, CGFloat radius) {
    CGContextSetLineWidth(context, lineWidth);
    setRectPathInContext(context, rect, radius);
    CGContextStrokePath(context);
}


void fillRectInContext(CGContextRef context, CGRect rect, CGFloat radius) {
    setRectPathInContext(context, rect, radius);
    CGContextFillPath(context);
}


void setRectPathInContext(CGContextRef context, CGRect rect, CGFloat radius) {
    CGContextBeginPath(context);
    if (radius > 0.0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    } else {
        CGContextAddRect(context, rect);
    }
    CGContextClosePath(context);
}
