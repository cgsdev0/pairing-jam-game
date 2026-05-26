shader_type canvas_item;

// Uniforms
uniform float line_width: hint_range(1.0, 10.0, 1.0) = 1.0;
uniform float cell_size = 32.0;
uniform vec4 color1: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color2: source_color = vec4(1.0);
uniform vec2 grid_offset = vec2(0.0, 0.0);

// Variables
varying vec2 pixel_coordinate;
varying float screen_line_width;

// Calculate vertex coordinates
void vertex() {
	// Convert from local to world space coordinates
	pixel_coordinate = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	
	// Adjust line width via screen
	float world_scale = length(vec2(CANVAS_MATRIX[0][0], CANVAS_MATRIX[1][0]));
	screen_line_width = line_width / world_scale;
}

// Check if pixel falls on a grid line
float falls_on_grid(vec2 world_position) {
	// Calculate offset position
    float width_offset = screen_line_width * 0.5;
    float x_frag = world_position.x + width_offset - grid_offset.x;
    float y_frag = world_position.y + width_offset - grid_offset.y;
  
	// Wrap coordinates
    float x_mod = mod(x_frag, cell_size);
    float y_mod = mod(y_frag, cell_size);
    
	// Calculate distance from axis lines
    float l_mod = min(x_mod, y_mod);
    
	// Return value
    return step(l_mod, screen_line_width);
}

// Calculate pixel color
void fragment() {
	// Check if falls on grid or discard
    float a = falls_on_grid(pixel_coordinate);
    COLOR = mix(color1, color2, a);
}