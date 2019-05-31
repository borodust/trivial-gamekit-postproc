#version 330 core
#pragma bodge: import gamekit/postproc

//
// Adapted from:
// https://www.shadertoy.com/view/4sf3W8
//

void mainPostproc(out vec4 fragColor, in sampler2D image, in vec2 viewportSize) {
  vec3 c[9];
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      c[3*i+j] = texture(image,
                         (gl_FragCoord.xy + vec2(i-1,j-1)) / viewportSize).rgb;
    }
  }

  vec3 Lx = 2.0*(c[7]-c[1]) + c[6] + c[8] - c[2] - c[0];
  vec3 Ly = 2.0*(c[3]-c[5]) + c[6] + c[0] - c[2] - c[8];
  vec3 G = sqrt(Lx*Lx+Ly*Ly);

  fragColor = vec4(G, 1.0);
}
