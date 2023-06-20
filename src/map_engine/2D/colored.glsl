//Simple shader to color the country based on predefined set of colors

uniform Image color_lib;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    return Texel(color_lib, vec2(Texel(tex, texture_coords).b, 1));
}