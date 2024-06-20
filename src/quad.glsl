@vs vs
in vec4 pos;
in vec2 uv;

out vec2 uv0;

void main()
{
    gl_Position = pos;
    uv0 = uv;
}
@end

@fs fs
uniform texture2D tex;
uniform sampler smp;

in vec2 uv0;
out vec4 frag_color;

void main()
{
    vec4 c = texture(sampler2D(tex, smp), uv0);
    frag_color = c;
}
@end

@program quad vs fs
