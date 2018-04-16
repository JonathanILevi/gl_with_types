module glwt.vertex_array;

import cst_	;

import derelict.opengl	;

import glwt.buffer;
public import glwt.types;


/**	Unittest to ensure Compiler works as expected*/
static this(){
	VertexArray	aa;
	uint	au = *(cast(uint*)cast(void*)&aa);
	assert(aa.id==au, "Error, byte data for Struct is not as expected.");
	uint	bu;
	ArrayBuffer	ba = *(cast(ArrayBuffer*)cast(void*)&bu);
	assert(ba.id==bu, "Error, byte data for Struct is not as expected.");
	ArrayBuffer	[2]	ca;
	uint	[2]	cu = cast(uint[])cast(void[])ca;
	assert(ca[0].id==cu[0], "Error, byte data for Struct is not as expected.");
	assert(ca[1].id==cu[1], "Error, byte data for Struct is not as expected.");
}


/**	A wrapper for VertexArrays.*/
struct VertexArray {
	uint id = 0;
}






/**	glGenBuffers() wrapper.
*/
void
gen(ref VertexArray vertexArray)
{
	import std.stdio;
	"ee".writeln;
	glGenVertexArrays(1, &vertexArray.id);
	vertexArray.id.writeln;
}
/**	glGenBuffers() wrapper.
*/
void
gen(ref VertexArray[] vertexArrays)
{
	// Works because a struct with a single var has the same byte data and size as its only var.
	glGenVertexArrays(vertexArrays.length, vertexArrays.ptr.cst!(uint*));
}


/**	glDeleteBuffers() wrapper.
*/
void
del(ref VertexArray vertexArray)
{
	glDeleteVertexArrays(1, &vertexArray.id);
}








enum string array_ensureGen_m = "version(assert){assert(vertexArray.id!=0, \"Vertex Array not generated.  Call `vertexArray.gen` before using this function.\");}";
enum string array_ensureBound_m = array_ensureGen_m~"version(assert){
uint ba;//bound array
glGetIntegerv(GL_VERTEX_ARRAY_BINDING, cast(int*)&ba);
assert(vertexArray.id==ba, \"Vertex Array not bound.  Call `vertexArray.bind` before using this function.\");
}";






/**	glBindBuffer wrapper.  
Binds buffer to be used by future calls.
*/
void 
bind(VertexArray vertexArray)
{
	mixin(array_ensureGen_m);
	glBindVertexArray(vertexArray.id);
}
/**ditto*/
alias use=bind;






/**	glEnableVertexAttribArray wrapper
*/
void
enableAttribute(VertexArray vertexArray, uint attribute) {
	mixin(array_ensureBound_m);
	glEnableVertexAttribArray(attribute);
}
///ditto
alias enableVertexArribArray = enableAttribute;
///ditto
alias enableAttrib = enableAttribute;

/**	glDisableVertexAttribArray wrapper
*/
void
disableAttribute(VertexArray vertexArray, uint attribute) {
	mixin(array_ensureBound_m);
	glDisableVertexAttribArray(attribute);
}
///ditto
alias disableVertexArribArray = disableAttribute;
///ditto
alias disableAttrib = disableAttribute;




/**	glVertexAttribPointer wrapper.
*/
void 
attributePointer(VertexArray vertexArray, uint attribute, ArrayBuffer buffer, uint count, DataType type, bool normalized=false, uint stride=0, int* offset=null) {
	mixin(buffer_ensureBound_m);
	vertexArray.attributePointer(attribute, count, type, normalized, stride, offset);
}
///ditto
void 
attributePointer(VertexArray vertexArray, uint attribute, uint count, DataType type, bool normalized=false, uint stride=0, int* offset=null) {
	mixin(array_ensureBound_m);
	version(assert){
		bool ae;//attribute enabled
		glGetVertexAttribiv(attribute, GL_VERTEX_ATTRIB_ARRAY_ENABLED, cast(int*)&ae);
		assert(ae, "Vertex Attribute not enabled.  Call `vertexArray.enableAttribute(attribute)` before assigning value.");
	}
	glVertexAttribPointer(attribute, count, type, normalized?GL_TRUE:GL_FALSE, stride, offset);
}
///ditto
alias bindAttribute = attributePointer;
///ditto
alias attribPointer = attributePointer;

////void bindElements(ref ArrayBuffer elements) {
////   bindContext;
////   glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elements.id);
////}