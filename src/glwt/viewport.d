module glwt.viewport;

import derelict.opengl;

void setGlViewport(int[2] pos, ptrdiff_t[2] size) {
	glViewport(pos[0],pos[1],size[0],size[1]);
}

