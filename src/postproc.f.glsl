#version 330 core

#pragma bodge: import gamekit/postproc

uniform sampler2D _bodge_image;
uniform float _bodge_width;
uniform float _bodge_height;

out vec4 _bodge_fColor;

void main(void) {
  mainPostproc(_bodge_fColor, _bodge_image, vec2(_bodge_width, _bodge_height));
}
