#version 330 core
//
// Adapted from:
// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
//

uniform sampler2D image;
uniform float width;
uniform float height;

uniform bool isVertical;

out vec4 fColor;

uniform float offset[3] = float[](0.0, 1.3846153846, 3.2307692308);
uniform float weight[3] = float[](0.2270270270, 0.3162162162, 0.0702702703);

void main(void) {
  vec2 texCoord = vec2(gl_FragCoord.x / width, gl_FragCoord.y / height);
  fColor = texture2D(image, texCoord) * weight[0];
  for (int i = 1; i < 3; ++i) {
    vec2 neighborOffset = isVertical ?
      vec2(0.0, offset[i] / height) : vec2(offset[i] / width, 0.0);

    fColor += texture2D(image, texCoord + neighborOffset) * weight[i];
    fColor += texture2D(image, texCoord - neighborOffset) * weight[i];
  }
}
