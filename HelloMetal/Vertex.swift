struct Vertex
{
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    var u,v: Float
  
    func floatBuffer() -> [Float]
    {
        return [x,y,z,r,g,b,a,u,v]
    }
}
