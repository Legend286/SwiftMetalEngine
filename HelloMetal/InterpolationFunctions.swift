import Foundation

func lerp(a: Float, b: Float, t: Float) -> Float
{
    return a + (b - a) * t
}

// This code was nice to come across, and provides a relatively okay smoothing
// function when you don't need to accurately reach the target values.
// https://www.construct.net/en/blogs/ashleys-blog-2/using-lerp-delta-time-924
func smoothLerp(a: Float, b: Float, t: Float, f: Float) -> Float
{
    return lerp(a: a, b: b, t: 1.0-pow(f,t))
}
