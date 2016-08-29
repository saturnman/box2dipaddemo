//
//  EINTGraphicSceneView.h
//  Box2diPad
//
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#include <vector>
#include <queue>
#include <string>
#include <utility>
#define kDrawPolygonCmd 0
#define kDrawSolidPolygonCmd 1
#define kDrawCircleCmd 2
#define kDrawSolidCircleCmd 3
#define kDrawSegmentCmd 4
#define kDrawTransformCmd 5
#define kDrawPointCmd 6
#define kDrawStringCmd 7
#define kDrawAABBCmd 8
@interface EINTGraphicSceneView : UIView
{
    std::queue<std::vector<b2Vec2> > _verticesQueue;
    //for different draw command
    std::queue<int> _drawCommandQueue;
    //for color parameter
    std::queue<b2Color> _colorQueue;
    //for different count parameter
    std::queue<int> _countQueue;
    //for draw string position
    std::queue<std::pair<int,int> > _posQueue;
    //for different b2Vec2 type point parameter
    std::queue<b2Vec2> _pointQueue;
    //for different different float type parameter
    std::queue<float32> _floatParamQueue;
    //for aabb parameter
    std::queue<b2AABB> _aabbQueue;
    //for various strings
    std::queue<std::string> _stringQueue;
    float xScale;
    float yScale;
    float xTranslate;
    float yTranslate;
}
- (BOOL) clearsContextBeforeDrawing;
- (void) DrawPolygonWithVertices : (const b2Vec2*) vertices Count:(int32) vertexCount Color: (const b2Color&) color;
- (void) DrawSolidPolygonWithVertices : (const b2Vec2*) vertices Count:(int32) vertexCount Color: (const b2Color&) color;
- (void) DrawCircleWithCenter:(const b2Vec2&) center Radius:(float32) radius Color: (const b2Color&) color;
- (void) DrawSolidCircleWithCenter:(const b2Vec2&)center Radius:(float32) radius Axis:(const b2Vec2&)axis Color:(const b2Color&)color;
- (void) DrawString:(NSString*)content Positionx:(int)x Positiony:(int)y;
- (void) DrawSegmentP1:(const b2Vec2&)p1 P2:(const b2Vec2&)p2 Color:(const b2Color&)color;
- (void) DrawTransform:(const b2Transform&)xf;
- (void) DrawPointPosition:(const b2Vec2& )position Size: (float32) size Color: (const b2Color&) color;
- (void)DrawAABB:(const b2AABB*)aabb Color:(const b2Color&)color;

//set
-(void)setXScale:(float)value;
-(void)setYScale:(float)value;
-(void)setXTranslate:(float)value;
-(void)setYTranslate:(float)value;
@end
