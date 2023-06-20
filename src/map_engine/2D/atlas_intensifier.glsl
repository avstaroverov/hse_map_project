vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    return color_table[int(Texel(tex, texture_coords).r*255)-1];
}