#version 300 es
#extension GL_OES_EGL_image_external_essl3 : require
precision mediump float;
in vec2 vTextureCoord;
out vec4 vFragColor;
uniform samplerExternalOES playerTexture;
uniform samplerExternalOES coachTexture;//教练视频
uniform sampler2D playerMaskTexture;
uniform mat3 playerMaskMat;
uniform vec3 bgColor;

vec4 filterTexture2D(sampler2D targetTexture, vec2 coord){
    if (coord.x < 0.0||coord.x>1.0||coord.y<0.0||coord.y>1.0) {
        return vec4(0.0);
    }
    return texture(targetTexture, coord);
}

void main(){
    vec3 tranCoord = playerMaskMat*vec3(vTextureCoord, 1.0);
    tranCoord.y = 1.0-tranCoord.y;
    float alpha = filterTexture2D(playerMaskTexture, tranCoord.xy).r;
    vec4 playerColor = texture(playerTexture, vec2(vTextureCoord.x, 1.0-vTextureCoord.y));//用户画面
    vec4 coachColor = texture(coachTexture, vec2(vTextureCoord.x, 1.0-vTextureCoord.y));//教练画面
    vec3 dstColor = mix(coachColor.rgb, playerColor.rgb, alpha);//合并
    vFragColor = vec4(dstColor, 1.0);
}