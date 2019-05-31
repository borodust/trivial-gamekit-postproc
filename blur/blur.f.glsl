#version 330 core
#pragma bodge: import gamekit/postproc

//
// Adapted from:
// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
//

uniform bool isVertical;
uniform float offsetCoef = 1.0;

const float offset[3] = float[](0.0, 1.3846153846, 3.2307692308);
const float weight[3] = float[](0.2270270270, 0.3162162162, 0.0702702703);

void mainPostproc(out vec4 fragColor, in sampler2D image, in vec2 viewportSize) {
  vec2 texCoord = vec2(gl_FragCoord.x / viewportSize.x, gl_FragCoord.y / viewportSize.y);
  fragColor = texture2D(image, texCoord) * weight[0];
  for (int i = 1; i < 3; ++i) {
    vec2 neighborOffset = isVertical ?
      vec2(0.0, offset[i] * offsetCoef / viewportSize.y) :
      vec2(offset[i] * offsetCoef / viewportSize.x, 0.0);
    fragColor += texture2D(image, texCoord + neighborOffset) * weight[i];
    fragColor += texture2D(image, texCoord - neighborOffset) * weight[i];
  }
}
