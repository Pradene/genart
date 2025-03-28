@group(0) @binding(0)
var output_texture: texture_storage_2d<rgba8unorm, write>;

@compute @workgroup_size(8, 8)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
    if (global_id.x >= textureDimensions(output_texture).x || global_id.y >= textureDimensions(output_texture).y) {
        return;
    }

    let tex_size = textureDimensions(output_texture);
    let aspect_ratio = f32(tex_size.x) / f32(tex_size.y);
    let uv = vec2<f32>(global_id.xy) / vec2<f32>(tex_size);
    
    var color = vec4<f32>(0.0, 0.0, 0.0, 1.0);

    let circles = array<vec3<f32>, 3>(
        vec3<f32>(0.5, 0.5, 0.2),   // Center (red)
        vec3<f32>(0.3, 0.7, 0.15),  // Top-left (green)
        vec3<f32>(0.7, 0.3, 0.15)   // Bottom-right (blue) - Increased radius
    );

    let colors = array<vec4<f32>, 3>(
        vec4<f32>(1.0, 0.0, 0.0, 1.0), // Red
        vec4<f32>(0.0, 1.0, 0.0, 1.0), // Green
        vec4<f32>(0.0, 0.0, 1.0, 1.0)  // Blue
    );

    for (var i = 0u; i < 3u; i++) {
        let circle = circles[i];
        let adjusted_uv = vec2<f32>(uv.x * aspect_ratio, uv.y);
        let dist = distance(adjusted_uv, vec2<f32>(circle.x * aspect_ratio, circle.y));
        
        if (dist < circle.z) {
            color = colors[i];
        }
    }

    textureStore(output_texture, global_id.xy, color);
}