#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

#define KERNEL_SIZE 25

// Gaussian kernel /273
// 1  4  7  4  1
// 4 16 26 16  4
// 7 26 41 26  7
// 4 16 26 16  4
// 1  4  7  4  1
float kernel[KERNEL_SIZE];

vec2 offset[KERNEL_SIZE];

void main(void) {
  int i = 0;
  vec4 sum = vec4(0.0);

  offset[0] = vec2(-texOffset.s, -texOffset.t);
  offset[1] = vec2(-texOffset.s / 2.0, -texOffset.t);
  offset[2] = vec2(0.0, -texOffset.t);
  offset[3] = vec2(texOffset.s / 2.0, -texOffset.t);
  offset[4] = vec2(texOffset.s, -texOffset.t);

  offset[5] = vec2(-texOffset.s, -texOffset.t / 2.0);
  offset[6] = vec2(-texOffset.s / 2.0, -texOffset.t / 2.0);
  offset[7] = vec2(0, -texOffset.t / 2.0);
  offset[8] = vec2(texOffset.s / 2.0, -texOffset.t / 2.0);
  offset[9] = vec2(texOffset.s, -texOffset.t / 2.0);

  offset[10] = vec2(-texOffset.s, 0.0);
  offset[11] = vec2(-texOffset.s / 2.0, 0.0);
  offset[12] = vec2(0.0, 0.0);
  offset[13] = vec2(texOffset.s / 2.0, 0.0);
  offset[14] = vec2(texOffset.s, 0.0);

  offset[15] = vec2(-texOffset.s, texOffset.t / 2.0);
  offset[16] = vec2(-texOffset.s / 2.0, texOffset.t / 2.0);
  offset[17] = vec2(0, texOffset.t / 2.0);
  offset[18] = vec2(texOffset.s / 2.0, texOffset.t / 2.0);
  offset[19] = vec2(texOffset.s, texOffset.t / 2.0);

  offset[20] = vec2(-texOffset.s, texOffset.t);
  offset[21] = vec2(-texOffset.s / 2.0, texOffset.t);
  offset[22] = vec2(0.0, texOffset.t);
  offset[23] = vec2(texOffset.s / 2.0, texOffset.t);
  offset[24] = vec2(texOffset.s, texOffset.t);

  kernel[0]  = 1.0/273.0;  kernel[1]  =  4.0/273.0;  kernel[2]  =  7.0/273.0;  kernel[3]  =  4.0/273.0;  kernel[4]  = 1.0/273.0;
  kernel[5]  = 4.0/273.0;  kernel[6]  = 16.0/273.0;  kernel[7]  = 26.0/273.0;  kernel[8]  = 16.0/273.0;  kernel[9]  = 4.0/273.0;
  kernel[10] = 7.0/273.0;  kernel[11] = 26.0/273.0;  kernel[12] = 41.0/273.0;  kernel[13] = 26.0/273.0;  kernel[14] = 7.0/273.0;
  kernel[15] = 4.0/273.0;  kernel[16] = 16.0/273.0;  kernel[17] = 26.0/273.0;  kernel[18] = 16.0/273.0;  kernel[19] = 4.0/273.0;
  kernel[20] = 1.0/273.0;  kernel[21] =  4.0/273.0;  kernel[22] =  7.0/273.0;  kernel[23] =  4.0/273.0;  kernel[24] = 1.0/273.0;

  for(i = 0; i < KERNEL_SIZE; i++) {
    vec4 tmp = texture2D(texture, vertTexCoord.st + offset[i]);
    sum += tmp * kernel[i];
  }

  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}