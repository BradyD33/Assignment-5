#version 300 es

// CSCI 4611 Assignment 5: Artistic Rendering
// Normal mapping is a complex effect that will involve changing
// both the vertex and fragment shader. This implementation is
// based on the approach described below, and you are encouraged
// to read this tutorial writeup for a deeper understanding.
// https://learnopengl.com/Advanced-Lighting/Normal-Mapping

// Most of the structure of this vertex shader has been implemented,
// but you will need to complete the code that computes the TBN matrix.

// You should complete this vertex shader first, and then move on to
// the fragment shader only after you have verified that is correct.

precision mediump int;
precision mediump float;

const int MAX_LIGHTS = 8;

uniform int numLights;
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 eyePosition;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

in vec3 position;
in vec3 normal;
in vec3 tangent;
in vec4 color;
in vec2 texCoord;

out vec4 vertColor;
out vec2 uv;
out vec3 tangentVertPosition;
out vec3 tangentEyePosition;
out vec3 tangentLightPositions[MAX_LIGHTS];

void main() 
{
    // Assign the vertex color and uv
    vertColor = color;
    uv = texCoord.xy; 

    // Compute the world vertex position
    vec3 worldPosition = (modelMatrix * vec4(position, 1)).xyz;   
    vec3 newTan = (modelMatrix*vec4(tangent,1)).xyz;
    vec3 newNorm =(modelMatrix * vec4(normal, 1)).xyz;
    // TO BE ADDED
    //newTan = normalize(newTan-newNorm*dot(newNorm,newTan));
    newTan = normalize(newTan);
    newNorm = normalize(newNorm);
    vec3 bitTan = cross(newNorm, newTan);
    bitTan = normalize(bitTan);

    //bitTan = normalize(bitTan);
    
    
    //reorthoganalize normal/tan
    // This line of code sets the TBN to an identity matrix.
    // You will need to replace to compute the matrix that
    // converts vertices from world space to tangent space. 
    // When this part is completed correctly, it will produce
    // a result that looks identical to the Phong shader.
    // Then, you can move on to complete the fragment shader.
    //mat3 tbn = 
    

    // Compute the tangent space vertex and view positions
    //mat3 tbn= mat3(1.0f);
    //matrix columns [tbl] row major matrices not column major
    //mat3 tbn = transpose(mat3( tangent, bitTan, normal));
    mat3 tbn = transpose(mat3(newTan,bitTan,newNorm));
    // Compute the tangent space light positions

    tangentVertPosition = tbn * worldPosition;
    tangentEyePosition = tbn * eyePosition;
    for(int i=0; i < numLights; i++)
    {
        tangentLightPositions[i] = tbn * lightPositions[i];
    }
    
    // Compute the projected vertex position
    gl_Position = projectionMatrix * viewMatrix * vec4(worldPosition, 1);
}