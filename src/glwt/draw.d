
module glwt.draw;

import cst_	;

import derelict.opengl	;


import glwt.vertex_array	;





enum Primitive {
	Triangles = GL_TRIANGLES,
	Lines = GL_LINES,
	Points = GL_POINTS
}
alias primitive_t = Primitive;



/** glDrawArrays wrapper
*/
void
draw(VertexArray vertexArray, Primitive primitive, int first, uint count) {
	mixin(array_ensureBound_m);
	glDrawArrays(primitive, first, count);
}
///ditto
void
draw(VertexArray vertexArray, Primitive primitive, uint count) {
	vertexArray.draw(primitive, 0, count);
}
///ditto
alias drawArrays = draw;

















