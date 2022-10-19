## SwiftMetalEngine
#### This is a small part-time project of mine to enable me to learn the modern metal3 api, along with Swift programming language, to hopefully make something that runs on ipad / macOS / iOS. The end goal for this is to make some sort of app for iOS and iPadOS that can make some money.

## Features

### Renderer which supports modern features, such as... 

- Diffuse and specular lighting
  * Support multiple pbr BRDFs - OrenNayar, Lambert, etc.
  * Specular would be typical GGX with the usual occlusion and fresnel functions.

- Shadows whether raytraced or shadowmapped
  * Switch using console command to toggle between raytraced and shadowmapped, rebuild shadowmaps render targets when you switch because raytraced can discard them.

- Global illumination (raytraced hopefully will be the only option)
  * Surfels, signed distance fields, both? No idea cos I'm not thinking about this just yet... Super late to be developed feature! Probably last.

- Spatial queries using an octree as an acceleration structure, this would allow for raycasting to be super fast and efficient
  * This tracing would be sped up greatly by this as there would be no need to test for all objects in the scene, but only the ones that are within cells that overlap the path of the trace. The octree may be able to be used to build fast ray accel structures but I don't know about that yet.

- Light types such as point, spot, directional plus area lights such as tubular, spherical, disc, quad, box.

# Will add more soon..
