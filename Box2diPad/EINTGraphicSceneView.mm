//
//  EINTGraphicSceneView.m
//  Box2diPad
//

#import "EINTGraphicSceneView.h"
#include <vector>
#include <string>
#include <utility>
@implementation EINTGraphicSceneView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        xScale = 1.0;
        yScale = 1.0;
        xTranslate = 0.0;
        yTranslate = 0.0;
    }
    return self;
}
-(void)setXScale:(float)value
{
    xScale = value;
}
-(void)setYScale:(float)value
{
    yScale = value;
}
-(void)setXTranslate:(float)value
{
    xTranslate = value;
}
-(void)setYTranslate:(float)value
{
    yTranslate = value;
}
-(BOOL)clearsContextBeforeDrawing
{
    return NO;
}
- (void) DrawTransform:(const b2Transform&)xf
{
    
     b2Vec2 p1 = xf.p, p2;
     const float32 k_axisScale = 0.4f;
     //-glBegin(GL_LINES);
     b2Color color(1.0,0.0,0.0);
     
     _colorQueue.push(color);
     _pointQueue.push(p1);
     //- glColor3f(1.0f, 0.0f, 0.0f);
     //- glVertex2f(p1.x, p1.y);
     p2 = p1 + k_axisScale * xf.q.GetXAxis();
     _pointQueue.push(p2);
    
    
     //- glVertex2f(p2.x, p2.y);
     _colorQueue.push(color);
     //- glColor3f(0.0f, 1.0f, 0.0f);
     _pointQueue.push(p1);
     //- glVertex2f(p1.x, p1.y);
     p2 = p1 + k_axisScale * xf.q.GetYAxis();
     //- glVertex2f(p2.x, p2.y);
     _pointQueue.push(p2);
     //- glEnd();
    _drawCommandQueue.push(kDrawTransformCmd);
     
}
- (void) DrawPointPosition:(const b2Vec2& )position Size: (float32) size Color: (const b2Color&) color
{
    _pointQueue.push(position);
    _colorQueue.push(color);
    _floatParamQueue.push(size);
    _drawCommandQueue.push(kDrawPointCmd);
    
}
- (void)DrawAABB:(const b2AABB*)aabb Color:(const b2Color&)color
{
    
    _aabbQueue.push(*aabb);
    _colorQueue.push(color);
    _drawCommandQueue.push(kDrawAABBCmd);
    
}
- (void) DrawPolygonWithVertices : (const b2Vec2*) vertices Count:(int32) vertexCount Color: (const b2Color&) color

{
    std::vector<b2Vec2> vertexVector;
    for (int looper =0; looper<vertexCount; ++looper) {
        vertexVector.push_back(vertices[looper]);
    }
    _countQueue.push(vertexCount);
    _colorQueue.push(color);
    _verticesQueue.push(vertexVector);
    _drawCommandQueue.push(kDrawPolygonCmd);
    //[self setNeedsDisplay];
    /*
    float scale = 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    for(int idx = 0; idx < vertexCount; idx++)
    {
        const b2Vec2 &pointRef = vertices[idx];
        CGPoint point;
        point.x = pointRef.x*scale+200;
        point.y = pointRef.y*scale+200;
        //point = [self.points objectAtIndex:idx];//Edited
        if(idx == 0)
        {
            // move to the first point
            CGContextMoveToPoint(context, point.x, point.y);
        }
        else
        {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 10.0f, 10.0f);
    CGContextAddLineToPoint(context, 20.0f, 20.0f);
    CGContextStrokePath(context);
     */
}
- (void) DrawSolidPolygonWithVertices : (const b2Vec2*) vertices Count:(int32) vertexCount Color: (const b2Color&) color
{
    std::vector<b2Vec2> vertexVector;
    for (int looper =0; looper<vertexCount; ++looper) {
        vertexVector.push_back(vertices[looper]);
    }
    _countQueue.push(vertexCount);
    _colorQueue.push(color);
    _verticesQueue.push(vertexVector);
    _drawCommandQueue.push(kDrawSolidPolygonCmd);
}
- (void) DrawSolidCircleWithCenter:(const b2Vec2&)center Radius:(float32) radius Axis:(const b2Vec2&)axis Color:(const b2Color&)color
{
    _pointQueue.push(center);
    _pointQueue.push(axis);
    _floatParamQueue.push(radius);
    _colorQueue.push(color);
    _drawCommandQueue.push(kDrawSolidCircleCmd);
    //[self setNeedsDisplay];
}
- (void) DrawCircleWithCenter:(const b2Vec2&) center Radius:(float32) radius Color: (const b2Color&) color
{
    /*
    UIGraphicsBeginImageContextWithOptions(self.frame.size,NO,1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(center.x, center.y, radius*2, radius*2);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 10.0f, 10.0f);
    CGContextAddLineToPoint(context, 20.0f, 20.0f);
    CGContextStrokePath(context);
    UIGraphicsEndImageContext();
     */
    _pointQueue.push(center);
    _floatParamQueue.push(radius);
    _colorQueue.push(color);
    _drawCommandQueue.push(kDrawCircleCmd);
    //[self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect
{
    float xScaleFactor = (725.0/50.0)*2.0;
    float yScaleFactor = (535.0/50.0)*2.0;
    float xShift = 725.0/2.0;
    float yShift = 535.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextTranslateCTM(context, 0,-535);
    CGContextTranslateCTM(context,xShift,-yShift);
    while (_drawCommandQueue.size()!=0) {
        int drawCmd = _drawCommandQueue.front();
        _drawCommandQueue.pop();
        CGContextSetLineWidth(context, 2.0);
        /*
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextMoveToPoint(context, 10.0f, 10.0f);
        CGContextAddLineToPoint(context, 200.0f, 100.0f);
        CGContextStrokePath(context);
         */
        switch (drawCmd) {
            case kDrawCircleCmd:
            {
                b2Vec2 center = _pointQueue.front();
                _pointQueue.pop();
                float32 radius = _floatParamQueue.front();
                //radius *= scaleFactor;
                _floatParamQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                //CGRect rect = CGRectMake(center.x+xShift, center.y+yShift, radius*2, radius*2);
                CGRect rect = CGRectMake(center.x*xScaleFactor-radius*xScaleFactor, center.y*yScaleFactor-radius*yScaleFactor, radius*2*xScaleFactor, radius*2*yScaleFactor);
                CGContextAddEllipseInRect(context, rect);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
                break;
             case kDrawSolidCircleCmd:
            {
                b2Vec2 center  = _pointQueue.front();
                _pointQueue.pop();
                b2Vec2 axis = _pointQueue.front();
                _pointQueue.pop();
                float32 radius = _floatParamQueue.front();
                //radius *= scaleFactor;
                _floatParamQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                CGContextSetRGBFillColor(context,color.r,color.g,color.b,0.5);
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                //CGRect rect = CGRectMake(center.x+xShift, center.y+yShift, radius*2, radius*2);
                CGRect rect = CGRectMake(center.x*xScaleFactor-radius*xScaleFactor, center.y*yScaleFactor-radius*yScaleFactor, radius*2*xScaleFactor, radius*2*yScaleFactor);
                CGContextAddEllipseInRect(context, rect);
                CGContextDrawPath(context, kCGPathFillStroke);
                b2Vec2 p = center + radius * axis;
                //draw debug line
                //CGContextMoveToPoint(context, center.x*xScaleFactor, center.y*yScaleFactor);
                //CGContextAddLineToPoint(context, 300.0f, 200.0f);
                //CGContextStrokePath(context);
                //CGContextMoveToPoint(context, center.x+xShift,center.y+yShift);
                //CGContextAddLineToPoint(context, p.x+xShift, p.y+yShift);
                CGContextMoveToPoint(context, center.x*xScaleFactor,center.y*yScaleFactor);
                CGContextAddLineToPoint(context, p.x*xScaleFactor, p.y*yScaleFactor);
                //CGContextClosePath(context);
                CGContextStrokePath(context);
            }
                break;
            case kDrawPolygonCmd:
            {
                std::vector<b2Vec2> vertices =_verticesQueue.front();
                _verticesQueue.pop();
                int vertexCount = _countQueue.front();
                _countQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                //CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                //CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
                
                // Draw them with a 2.0 stroke width so they are a bit more visible.
                CGContextSetLineWidth(context, 2.0);
                const b2Vec2 &startPointRef = vertices[0];
                
                for(int idx = 0; idx < vertexCount; idx++)
                {
                    const b2Vec2 &pointRef = vertices[idx];
                    CGPoint point;
                    //b2Vec2 vertexPoint =
                    point.x = pointRef.x*xScaleFactor;
                    point.y = pointRef.y*yScaleFactor;
                    //point = [self.points objectAtIndex:idx];//Edited
                    if(idx == 0)
                    {
                        // move to the first point
                        CGContextMoveToPoint(context, point.x, point.y);
                    }
                    else
                    {
                        CGContextAddLineToPoint(context, point.x, point.y);
                    }
                    if (idx==vertexCount-1) {
                        CGContextAddLineToPoint(context,startPointRef.x*xScaleFactor,startPointRef.y*yScaleFactor);
                    }
                }
                CGContextStrokePath(context);
            }
                break;
            case kDrawSolidPolygonCmd:
            {
                std::vector<b2Vec2> vertices =_verticesQueue.front();
                _verticesQueue.pop();
                int vertexCount = _countQueue.front();
                _countQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                //CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                CGContextSetRGBFillColor(context,color.r,color.g,color.b,0.5);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                //CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                //CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
                
                // Draw them with a 2.0 stroke width so they are a bit more visible.
                CGContextSetLineWidth(context, 2.0);
                
                const b2Vec2 &startPointRef = vertices[0];
                for(int idx = 0; idx < vertexCount; idx++)
                {
                    const b2Vec2 &pointRef = vertices[idx];
                    CGPoint point;
                    //b2Vec2 vertexPoint =
                    point.x = pointRef.x*xScaleFactor;
                    point.y = pointRef.y*yScaleFactor;
                    //point = [self.points objectAtIndex:idx];//Edited
                    if(idx == 0)
                    {
                        // move to the first point
                        CGContextMoveToPoint(context, point.x, point.y);
                    }
                    else
                    {
                        CGContextAddLineToPoint(context, point.x, point.y);
                    }
                    if (idx==vertexCount-1) {
                        CGContextAddLineToPoint(context,startPointRef.x*xScaleFactor,startPointRef.y*yScaleFactor);
                    }
                }
                CGContextClosePath(context);
                CGContextFillPath(context);
                //CGContextStrokePath(context);
            }
                break;
            case kDrawStringCmd:
            {
                CGContextSelectFont(context,"Helvetica",20,kCGEncodingMacRoman);
                std::string contentString = _stringQueue.front();
                _stringQueue.pop();
                std::pair<int,int> position = _posQueue.front();
                _posQueue.pop();
                //[[NSString stringWithUTF8String:contentString.c_str()] drawAtPoint:CGPointMake(position.first+xShift, position.second+yShift) withFont:[UIFont fontWithName:@"Courier" size:15.0f]];
                CGContextShowTextAtPoint(context, position.first*xScaleFactor-535.0/2.0,position.second*yScaleFactor/15.0+380, contentString.c_str(), contentString.size());
            } 
                break;
            case kDrawSegmentCmd:
            {
                b2Vec2 p2 = _pointQueue.front();
                _pointQueue.pop();
                b2Vec2 p1 = _pointQueue.front();
                _pointQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                CGContextMoveToPoint(context, (p1).x*xScaleFactor, (p1).y*yScaleFactor);
                CGContextAddLineToPoint(context, (p2).x*xScaleFactor, (p2).y*yScaleFactor);
                CGContextStrokePath(context);
                
            }
                break;
            case kDrawTransformCmd:
            {
                b2Vec2 p2 = _pointQueue.front();
                _pointQueue.pop();
                b2Vec2 p1 = _pointQueue.front();
                _pointQueue.pop();
                b2Color color = _colorQueue.front();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                _colorQueue.pop();
                CGContextMoveToPoint(context, (xScaleFactor*p1).x, (yScaleFactor*p1).y);
                CGContextAddLineToPoint(context, (xScaleFactor*p2).x, (yScaleFactor*p2).y);
                CGContextStrokePath(context);
                p2 = _pointQueue.front();
                _pointQueue.pop();
                p1 = _pointQueue.front();
                _pointQueue.pop();
                color = _colorQueue.front();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                _colorQueue.pop();
                CGContextMoveToPoint(context, (xScaleFactor*p1).x, (yScaleFactor*p1).y);
                CGContextAddLineToPoint(context, (xScaleFactor*p2).x, (yScaleFactor*p2).y);
                CGContextStrokePath(context);
            }
                break;
            case kDrawPointCmd:
            {
                b2Vec2 position = _pointQueue.front();
                _pointQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                float32 radius = _floatParamQueue.front();
                _floatParamQueue.pop();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
        
                CGRect rect = CGRectMake(position.x*xScaleFactor-radius*xScaleFactor, position.y*yScaleFactor-radius*yScaleFactor, xScaleFactor*radius*2, yScaleFactor*radius*2);
                CGContextAddEllipseInRect(context, rect);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
                break;
            case kDrawAABBCmd:
            {
                /*
                 glColor3f(c.r, c.g, c.b);
                 glBegin(GL_LINE_LOOP);
                 glVertex2f(aabb->lowerBound.x, aabb->lowerBound.y);
                 glVertex2f(aabb->upperBound.x, aabb->lowerBound.y);
                 glVertex2f(aabb->upperBound.x, aabb->upperBound.y);
                 glVertex2f(aabb->lowerBound.x, aabb->upperBound.y);
                 glEnd();
                 */
                b2AABB aabb = _aabbQueue.front();
                _aabbQueue.pop();
                b2Color color = _colorQueue.front();
                _colorQueue.pop();
                CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0].CGColor);
                CGContextMoveToPoint(context, (xScaleFactor*aabb.lowerBound).x, (yScaleFactor*aabb.lowerBound).y);
                CGContextAddLineToPoint(context, (xScaleFactor*aabb.upperBound).x, (yScaleFactor*aabb.lowerBound).y);
                CGContextAddLineToPoint(context, (xScaleFactor*aabb.upperBound).x, (yScaleFactor*aabb.lowerBound).y);
                CGContextAddLineToPoint(context, (xScaleFactor*aabb.upperBound).x, (yScaleFactor*aabb.upperBound).y);
                CGContextAddLineToPoint(context, (xScaleFactor*aabb.lowerBound).x, (yScaleFactor*aabb.upperBound).y);
                CGContextStrokePath(context);
            }
                break;
            default:
                break;
        }
    }
    /*
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 10.0f, 10.0f);
    CGContextAddLineToPoint(context, 20.0f, 20.0f);
    CGContextStrokePath(context);
     */
    CGContextRestoreGState(context);
}
- (void) DrawSegmentP1:(const b2Vec2&)p1 P2:(const b2Vec2&)p2 Color:(const b2Color&)color
{
    
    _pointQueue.push(p1);
    _pointQueue.push(p2);
    _colorQueue.push(color);
    _drawCommandQueue.push(kDrawSegmentCmd);
    //[self setNeedsDisplay];
    
}
- (void)DrawString:(NSString*)content Positionx:(int)x Positiony:(int)y
{
    std::string contentString = [content UTF8String];
    _stringQueue.push(contentString);
    _posQueue.push(std::make_pair<int&,int&>(x,y));
    _drawCommandQueue.push(kDrawStringCmd);
    //[self setNeedsDisplay];
}
@end
