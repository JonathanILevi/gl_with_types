module glwt.clear;

import derelict.opengl;

enum ClearType {
	color	= GL_COLOR_BUFFER_BIT	,
	depth	= GL_DEPTH_BUFFER_BIT	,
	stencil	= GL_STENCIL_BUFFER_BIT	,
}

void clear(ClearType clearType = ClearType.color|ClearType.depth) {
	glClear(clearType);
}






