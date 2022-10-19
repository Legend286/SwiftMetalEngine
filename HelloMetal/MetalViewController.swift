import UIKit
import Metal

protocol MetalViewControllerDelegate : class
{
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(drawable: CAMetalDrawable)
}

@available(iOS 13.0, *)
class MetalViewController: UIViewController
{
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    var projectionMatrix: Matrix4!
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    var aspectRatio: Float = 1.0
  
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?
  
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if let window = view.window
        {
            let scale = window.screen.scale
            let layerSize = view.bounds.size
            
            view.contentScaleFactor = scale
            metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
            metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
        }
        updateAspect()
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad:85), aspectRatio: aspectRatio, nearZ: 1, farZ: 100.0)
    }
    
    func updateAspect()
    {
        aspectRatio = Float(self.view.bounds.size.width / self.view.bounds.size.height)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateAspect()

    
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: aspectRatio, nearZ: 0.01, farZ: 100.0)
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
    
        // makeDefaultLibrary
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    
        commandQueue = device.makeCommandQueue()
    
        timer = CADisplayLink(target: self, selector: #selector(MySceneViewController.newFrame(displayLink:)))
        timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
  
    func render()
    {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        self.metalViewControllerDelegate?.renderObjects(drawable: drawable)
    }
    
    @objc func newFrame(displayLink: CADisplayLink)
    {
        if lastFrameTimestamp == 0.0
        {
            lastFrameTimestamp = displayLink.timestamp
        }
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        gameloop(timeSinceLastUpdate: elapsed)
    }
  
    func gameloop(timeSinceLastUpdate: CFTimeInterval)
    {
        self.metalViewControllerDelegate?.updateLogic(timeSinceLastUpdate: timeSinceLastUpdate)
        autoreleasepool {
            self.render()
        }
    }
}

