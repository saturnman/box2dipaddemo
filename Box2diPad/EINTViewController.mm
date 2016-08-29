//
//  EINTViewController.m
//  Box2diPad
//
//

#import "EINTViewController.h"
#import "EINTGraphicSceneView.h"
#import "Init.h"
@interface EINTViewController ()
@end

@implementation EINTViewController
@synthesize graphicSceneView;
@synthesize _demoList;
extern void SimulationLoop();
extern void SingleStep(int);
extern void Restart(int);
extern void Pause(int);
extern void setTestSelection(int index);
extern void Mouse(int32 button, int32 state, int32 x, int32 y);
extern void MouseMotion(int32 x, int32 y);
- (void)viewDidLoad
{
    [super viewDidLoad];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector: @selector(timerEventTriggered) userInfo:nil repeats:YES];
    _testItemList = [[NSMutableArray alloc]init];
    //[_testItemList addObject:@"abc"];
    //do physics & callback init
    Init::doInit();
    [_demoList reloadData];
    [_timer fire];
    //graphicSceneView drawText
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)performPause
{
    Pause(0);
}
-(void)performRestart
{
    Restart(0);
}
-(void)performSingleStep
{
    SingleStep(0);
}

- (IBAction)pauseAction:(id)sender {
    [self performPause];
}

- (IBAction)restartAction:(id)sender {
    [self performRestart];
}

- (IBAction)singleStepAction:(id)sender {
    [self performSingleStep];
}
- (void)timerEventTriggered
{
    SimulationLoop();
    [[self graphicSceneView] setNeedsDisplay];
}
- (void)addTestItemToList:(NSString*)itemName
{
    [_testItemList addObject:itemName];
}
- (void)viewDidUnload
{
    [self setGraphicSceneView:nil];
    [self set_demoList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)resizeWithWidth: (int)width Height:(int)height
{
    [graphicSceneView setFrame:CGRectMake(graphicSceneView.frame.origin.x, graphicSceneView.frame.origin.y, width, height)];
}
- (void)fireTimer
{
    [_timer fire];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc {
    [graphicSceneView release];
    [_testItemList release];
    [_demoList release];
    [super dealloc];
}
#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    setTestSelection([indexPath row]);
}
#pragma mark - TableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell) {
        cell.textLabel.text = [_testItemList objectAtIndex:[indexPath row]];
    }
    return [cell autorelease];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_testItemList count];
}
#pragma mark - touchs
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    int yAxis  = int(([touch locationInView:self.graphicSceneView].y));
    yAxis = 415+(yAxis-415)/2;
    int xAxis = int(([touch locationInView:self.graphicSceneView].x-103));
    xAxis = 443+(xAxis-443)/2;
    //NSLog(@"Begin touch at position %f,%f",[touch locationInView:self.graphicSceneView].x,[touch locationInView:self.graphicSceneView].y );
    Mouse(LEFT_BUTTON, BUTTON_DOWN, xAxis, yAxis);
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    int yAxis  = int(([touch locationInView:self.graphicSceneView].y));
    yAxis = 415+(yAxis-415)/2;
    int xAxis = int(([touch locationInView:self.graphicSceneView].x-103));
    xAxis = 443+(xAxis-443)/2;
    //NSLog(@"End touch at position %f,%f",[touch locationInView:self.graphicSceneView].x,[touch locationInView:self.graphicSceneView].y );
    Mouse(LEFT_BUTTON, BUTTON_UP, xAxis, yAxis);
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    int yAxis  = int(([touch locationInView:self.graphicSceneView].y));
    yAxis = 415+(yAxis-415)/2;
    int xAxis = int(([touch locationInView:self.graphicSceneView].x-103));
    xAxis = 421+(xAxis-421)/2;
    //xAxis =
    //NSLog(@"Move touch at position %f,%f",[touch locationInView:self.graphicSceneView].x,[touch locationInView:self.graphicSceneView].y );
    b2Vec2 position(([touch locationInView:self.graphicSceneView].x-725/2)*25.0/725.0,(535-[touch locationInView:self.graphicSceneView].y)*25.0/535.0);
    b2Color color(1.0,0.0,0.0);
    [self.graphicSceneView DrawPointPosition:position Size:0.2 Color:color];
    Mouse(LEFT_BUTTON, BUTTON_DOWN, xAxis, yAxis);
    MouseMotion(xAxis,yAxis);
    //NSLog(@"xAxis=%d",xAxis);
}
@end
