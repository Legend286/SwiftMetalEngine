import Foundation

func lerp(a: Float, b: Float, t: Float) -> Float
{
    return a + (b - a) * t
}

func smoothLerp(a: Float, b: Float, t: Float, f: Float) -> Float
{
    return lerp(a: a, b: b, t: 1.0-pow(f,t))
}
