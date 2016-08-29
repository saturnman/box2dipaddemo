//
//  EINTViewController.h
//  Box2diPad
//
//

#import <UIKit/UIKit.h>
#import "EINTGraphicSceneView.h"
@interface EINTViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *_timer;
    NSMutableArray *_testItemList;
}

@property (retain, nonatomic) IBOutlet EINTGraphicSceneView *graphicSceneView;
@property (retain, nonatomic) IBOutlet UITableView *_demoList;
- (void)resizeWithWidth: (int)width Height:(int)height;
- (void)fireTimer;
- (void)addTestItemToList:(NSString*)itemName;
-(void)performPause;
-(void)performRestart;
-(void)performSingleStep;
- (IBAction)pauseAction:(id)sender;
- (IBAction)restartAction:(id)sender;
- (IBAction)singleStepAction:(id)sender;
@end
