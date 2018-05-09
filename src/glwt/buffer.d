
module glwt.buffer;

import cst_	;

import derelict.opengl	;


/**	Unittest to ensure Compiler works as expected*/
unittest {
	ArrayBuffer	ab;
	uint	au = *(cast(uint*)cast(void*)&ab);
	assert(ab.id==au, "Error, byte data for Struct is not as expected.");
	uint	bu;
	ArrayBuffer	bb = *(cast(ArrayBuffer*)cast(void*)&bu);
	assert(bb.id==bu, "Error, byte data for Struct is not as expected.");
	ArrayBuffer	[2]	cb;
	uint	[2]	cu = cast(uint[])cast(void[])cb;
	assert(cb[0].id==cu[0], "Error, byte data for Struct is not as expected.");
	assert(cb[1].id==cu[1], "Error, byte data for Struct is not as expected.");
}


/**	A wrapper for buffers.*/
struct Buffer(BufferType bufferType) {
	uint id = 0;
}
alias ArrayBuffer	= Buffer!(BufferType.Array	) ;
alias AtomicCounterBuffer	= Buffer!(BufferType.AtomicCounter	) ;
alias CopyReadBuffer	= Buffer!(BufferType.CopyRead	) ;
alias CopyWriteBuffer	= Buffer!(BufferType.CopyWrite	) ;
alias DispatchIndirectBuffer	= Buffer!(BufferType.DispatchIndirect	) ;
alias DrawIndirectBuffer	= Buffer!(BufferType.DrawIndirect	) ;
alias ElementArrayBuffer	= Buffer!(BufferType.ElementArray	) ;
alias PixelPackBuffer	= Buffer!(BufferType.PixelPack	) ;
alias PixelUnpackBuffer	= Buffer!(BufferType.PixelUnpack	) ;
alias QueryBuffer	= Buffer!(BufferType.Query	) ;
alias ShaderStorageBuffer	= Buffer!(BufferType.ShaderStorage	) ;
alias TextureBuffer	= Buffer!(BufferType.Texture	) ;
alias TransformFeedbackBuffer	= Buffer!(BufferType.TransformFeedback	) ;
alias UniformBuffer	= Buffer!(BufferType.Uniform	) ;




enum BufferType {
	Array	= GL_ARRAY_BUFFER	,
	AtomicCounter	= GL_ATOMIC_COUNTER_BUFFER	,
	CopyRead	= GL_COPY_READ_BUFFER	,
	CopyWrite	= GL_COPY_WRITE_BUFFER	,
	DispatchIndirect	= GL_DISPATCH_INDIRECT_BUFFER	,
	DrawIndirect	= GL_DRAW_INDIRECT_BUFFER	,
	ElementArray	= GL_ELEMENT_ARRAY_BUFFER	,
	PixelPack	= GL_PIXEL_PACK_BUFFER	,
	PixelUnpack	= GL_PIXEL_UNPACK_BUFFER	,
	Query	= GL_QUERY_BUFFER	,
	ShaderStorage	= GL_SHADER_STORAGE_BUFFER	,
	Texture	= GL_TEXTURE_BUFFER	,
	TransformFeedback	= GL_TRANSFORM_FEEDBACK_BUFFER	,
	Uniform	= GL_UNIFORM_BUFFER	,
}


enum BufferUsage {
	StreamDraw	= GL_STREAM_DRAW	,
	StreamRead	= GL_STREAM_READ	,
	StreamCopy	= GL_STREAM_COPY	,
	StaticDraw	= GL_STATIC_DRAW	,
	StaticRead	= GL_STATIC_READ	,
	StaticCopy	= GL_STATIC_COPY	,
	DynamicDraw	= GL_DYNAMIC_DRAW	,
	DynamicRead	= GL_DYNAMIC_READ	,
	DynamicCopy	= GL_DYNAMIC_COPY	,
}




/**	glGenBuffers() wrapper.
*/
void
gen(BufferType bufferType)(ref Buffer!bufferType buffer)
{
	glGenBuffers(1, &buffer.id);
}
/**	glGenBuffers() wrapper.
*/
void
gen(BufferType bufferType)(ref Buffer!bufferType[] buffers)
{
	// Works because a struct with a single var has the same byte data and size as its only var.
	glGenBuffers(buffers.length, buffers.ptr);
}


/**	glDeleteBuffers() wrapper.
*/
void
del(BufferType bufferType)(ref Buffer!bufferType buffer)
{
	glDeleteBuffers(1, &buffer.id);
}








enum string buffer_ensureGen_m = "version(assert){assert(buffer.id!=0, \"Buffer not generated.  Call `buffer.gen` before using this function.\");}";
enum string buffer_ensureBound_m = buffer_ensureGen_m~"version(assert){
static if(is(typeof(buffer)==ArrayBuffer)) {
	uint bb;//bound buffer
	glGetIntegerv(GL_ARRAY_BUFFER_BINDING, cast(int*)&bb);
	assert(buffer.id==bb, \"Buffer not bound.  Call `buffer.bind` before using this function.\");
}
else {
	pragma(msg, \"No test for this buffer being bound (currently), be sure it is (to bind call `bind` method).\");
}}";






/**	glBindBuffer() wrapper.  
	Binds buffer to be used by future calls.
*/
void 
bind(BufferType bufferType)(Buffer!bufferType buffer)
{
	mixin(buffer_ensureGen_m);
	glBindBuffer(bufferType, buffer.id);
}
/**ditto*/
alias use=bind;






/**	glBufferData() wrapper.  
	Sets the buffer's data.
*/
void 
data(BufferType bufferType)(Buffer!bufferType buffer, void[] data, BufferUsage usage)
{
	mixin(buffer_ensureBound_m);
	glBufferData(bufferType, data.length, data.ptr, usage);
}



/**	body() wrapper.  
	Sets the buffer's sub data.
*/
void 
subData(BufferType bufferType)(Buffer!bufferType buffer, void[] data, size_t offset)
{
	mixin(buffer_ensureBound_m);
	glBufferSubData(bufferType, offset, data.length, data.ptr);
}



/**	glGetBufferSubData() wrapper.  
	Gets the buffer's sub data.
*/
void 
getSubData(BufferType bufferType)(Buffer!bufferType buffer, void* data, size_t offset, size_t length)
{
	mixin(buffer_ensureBound_m);
	glGetBufferSubData(bufferType, offset, length, data);
}