import UIKit

@available(iOS 13.0, *)
class MySceneViewController: MetalViewController,MetalViewControllerDelegate
{
    var worldModelMatrix:Matrix4!
    var objectToDraw: Cube!
    let panSensitivity: Float = 40.0
    var lastPanLocation: CGPoint!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
    
        objectToDraw = Cube(device: device, commandQueue: commandQueue)
        
        self.metalViewControllerDelegate = self
        setupGestures()
    }
    
    //MARK: - MetalViewControllerDelegate
    func renderObjects(drawable:CAMetalDrawable)
    {
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
    var x: Float = 0.0
    var y: Float = 0.0
    var xDelta: Float = 0.0
    var yDelta: Float = 0.0
    var q: Float = 0.0
    var t: Float = 0.0
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    {
        objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)

        x = smoothLerp(a: x, b: x - yDelta, t: Float(timeSinceLastUpdate), f: 0.015)
        y = smoothLerp(a: y, b: y - xDelta, t: Float(timeSinceLastUpdate), f: 0.015)
        print(x)
        print(q)
        
        objectToDraw.rotationX = x;
        objectToDraw.rotationY = y;
        
        xDelta = smoothLerp(a: xDelta, b: 0.0, t: Float(timeSinceLastUpdate), f: 0.025)
        yDelta = smoothLerp(a: yDelta, b: 0.0, t: Float(timeSinceLastUpdate), f: 0.025)
    }
    
    func setupGestures()
    {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(MySceneViewController.pan))
        self.view.addGestureRecognizer(pan)
        
        x = objectToDraw.rotationX
        y = objectToDraw.rotationY
    }
    
    @objc func pan(panGesture: UIPanGestureRecognizer)
    {
        if panGesture.state == UIGestureRecognizer.State.changed
        {
            let pointInView = panGesture.location(in: self.view)
            xDelta = Float((lastPanLocation.x - pointInView.x)/self.view.bounds.width) * panSensitivity
            yDelta = Float((lastPanLocation.y - pointInView.y)/self.view.bounds.height) * panSensitivity
            lastPanLocation = panGesture.location(in: self.view)
        }
        else if panGesture.state == UIGestureRecognizer.State.began
        {
            lastPanLocation = panGesture.location(in: self.view)
        }
    }
}
