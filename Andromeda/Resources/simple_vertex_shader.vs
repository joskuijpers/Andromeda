#version 330 core
layout(location = 0) in vec3 vertexPosition_modelspace;

void main()
{
	gl_Position.xyz = 0.9*vertexPosition_modelspace;
	gl_Position.w = 1.0;
}