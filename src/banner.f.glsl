#version 330 core

out vec4 fColor;

uniform sampler2D banner;
uniform float width;
uniform float height;

void main() {
  fColor = texture(banner, vec2(gl_FragCoord.x / width, gl_FragCoord.y / height));
}
