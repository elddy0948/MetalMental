#import "ViewController.h"
#import "RendererAdapter.h"

@implementation ViewController
{
  MTKView* _view;
  RendererAdapter* _pRendererAdapter;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  _view = (MTKView *)self.view;
  _view.device = MTLCreateSystemDefaultDevice();
  _pRendererAdapter = [RendererAdapter alloc];
  [_pRendererAdapter draw:_view.currentDrawable device:_view.device];
}


- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
}
@end
