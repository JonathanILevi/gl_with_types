

module glwt.program;

import std.conv : to;

import cst_	;

import derelict.opengl	;

import glwt.shader;








/**	A wrapper for a program.*/
struct Program {
	uint id = 0;
}





/**	glCreateShader wrapper.
*/
void
create(ref Program program)
{
	import std.stdio;
	program.id = glCreateProgram();
}
/**	glDeleteProgram wrapper.
*/
void
del(ref Program program)
{
	glDeleteProgram(program.id);
}











enum string program_ensureGen_m = "version(assert){assert(program.id!=0, \"Program not created.  Call `program.create` before using this function.\");}";
enum string program_ensureBound_m = program_ensureGen_m~"version(assert){
	uint bp;//bound program
	glGetIntegerv(GL_CURRENT_PROGRAM, cast(int*)&bp);
	assert(program.id==bp, \"Program not in use (bound).  Call `program.use` before using this function.\");
}";





void checkError(T)(T id) {
	import std.stdio;
	auto glErr = glGetError();
	if (glErr != GL_NO_ERROR) {
		id.writeln;
		writeln(glErr);
		if (glErr==GL_INVALID_VALUE	) {writeln("glErrGL_INVALID_VALUE"	);}
		if (glErr==GL_INVALID_OPERATION	) {writeln("glErrGL_INVALID_OPERATION"	);}
		if (glErr==GL_INVALID_FRAMEBUFFER_OPERATION	) {writeln("glErrGL_INVALID_FRAMEBUFFER_OPERATION"	);}
		if (glErr==GL_OUT_OF_MEMORY	) {writeln("glErrGL_OUT_OF_MEMORY"	);}
		////if (glErr==GL_STACK_UNDERFLOW	) {writeln("glErrGL_STACK_UNDERFLOW	");}
		////if (glErr==GL_STACK_OVERFLOW	) {writeln("glErrGL_STACK_OVERFLOW	");}
	}
}



/**	glUseProgram wrapper.  
Binds program to be used by future calls.
*/
void 
use(Program program)
{
	"a".checkError;
	mixin(program_ensureGen_m);
	"b".checkError;
	glUseProgram(program.id);
	"c".checkError;
	uint bp;//bound program
	glGetIntegerv(GL_CURRENT_PROGRAM, cast(int*)&bp);
	"d".checkError;
}
/**ditto*/
alias bind=use;












/**	glAttachShader wrapper
*/
void
attach(ShaderType shaderType)(Program program, Shader!shaderType shader) 
{
	mixin(program_ensureGen_m);
	mixin(shader_ensureGen_m);
	glAttachShader(program.id, shader.id);
}


/**	glLinkProgram wrapper
*/
void
link(Program program)
{
	mixin(program_ensureGen_m);
	glLinkProgram(program.id);
}








/**	glGetAttribLocation wrapper
*/
int getAttribute(Program program, string name) {
	mixin(program_ensureGen_m);
	import std.string : toStringz;
	return glGetAttribLocation(program.id, name.toStringz);
}
///ditto
alias getAttributeLocation = getAttribute;
///ditto
alias getAttribLocation = getAttribute;
/**	glGetUniformLocation
*/
int getUniform(Program program, string name) {
	mixin(program_ensureBound_m);
	import std.string : toStringz;
	return glGetUniformLocation(program.id, name.toStringz);
}
///ditto
alias getUniformLocation = getUniform;






/**	glUniform wrapper
*/
void uniform	(Type)	(Program program, int uniform, Type value )	if (mixin(constrainTypeWBool_m))	{	mixin(program_ensureBound_m); mixin("glUniform1"~mixin(typeToLetterWBool_m))	(uniform, value);	}
void uniformVector	(Type, int size:1)	(Program program, int uniform, Type[size] value )	if (mixin(constrainTypeWBool_m) && size>0)	{	mixin(program_ensureBound_m); mixin("glUniform"~size.to!string~mixin(typeToLetterWBool_m))	(uniform, value[0]);	}
void uniformVector	(Type, int size:2)	(Program program, int uniform, Type[size] value )	if (mixin(constrainTypeWBool_m) && size>0)	{	mixin(program_ensureBound_m); mixin("glUniform"~size.to!string~mixin(typeToLetterWBool_m))	(uniform, value[0],value[1]);	}
void uniformVector	(Type, int size:3)	(Program program, int uniform, Type[size] value )	if (mixin(constrainTypeWBool_m) &&  size>0)	{	mixin(program_ensureBound_m); mixin("glUniform"~size.to!string~mixin(typeToLetterWBool_m))	(uniform, value[0],value[1],value[2]);	}
void uniformVector	(Type, int size:4)	(Program program, int uniform, Type[size] value )	if (mixin(constrainTypeWBool_m) &&  size>0)	{	mixin(program_ensureBound_m); mixin("glUniform"~size.to!string~mixin(typeToLetterWBool_m))	(uniform, value[0],value[1],value[2],value[3]);	}
void uniformArray	(Type, int size, int length)	(Program program, int uniform, Type[size][length] value )	if (mixin(constrainTypeWOBool_m) && size>0&&size<=4 && length>0)	{	mixin(program_ensureBound_m); mixin("glUniform"~size.to!string~mixin(typeToLetterWOBool_m)~"v")	(uniform, length, value.ptr.cst!(Type*));	}
void uniformMatrix	(Type, int width, int height)	(Program program, int uniform, Type[width][height] value, bool transpose=false )	if (mixin(constrainTypeWOBool_m) && width>1&&width<=4 && height>1&&height<=4)	{	static if (width==height) {
						mixin(program_ensureBound_m); mixin("glUniformMatrix"~width.to!string~mixin(typeToLetterWOBool_m)~"v")	(uniform, 1, transpose, value.ptr.cst!(Type*));
					} else {
						mixin(program_ensureBound_m); mixin("glUniformMatrix"~width.to!string~"x"~height.to!string~mixin(typeToLetterWOBool_m)~"v")	(uniform, 1, transpose, value.ptr.cst!(Type*));
					}
				}
void uniformMatrices	(int width, int height, int length, Type)	(Program program, int uniform, Type[width][height][amount] value, bool transpose=false )	if (mixin(constrainTypeWOBool_m) && width>1&&width<=4 && height>1&&height<=4  && amount>0)	{	static if (width==height) {
						mixin(program_ensureBound_m); mixin("glUniformMatrix"~width.to!string~mixin(typeToLetterWOBool_m)~"v")	(uniform, length, transpose, value.ptr.cst!(Type*));
					} else {
						mixin(program_ensureBound_m); mixin("glUniformMatrix"~width.to!string~"x"~height.to!string~mixin(typeToLetterWOBool_m)~"v")	(uniform, length, transpose, value.ptr.cst!(Type*));
					}
				}

alias setUniform	= uniform	;
alias setUniformVector	= uniformVector	;
alias setUniformArray	= uniformArray	;
alias setUniformMatrix	= uniformMatrix	;
alias setUniformMatrices	= uniformMatrices	;

private enum string typeToLetterWBool_m = "((is(Type:int)||is(Type:bool))?\"i\":(is(Type:float)?\"f\":\"ui\"))";
private enum string typeToLetterWOBool_m = "(is(Type:int)?\"i\":(is(Type:float)?\"f\":\"ui\"))";
private enum string constrainTypeWBool_m = "(is(Type:int)||is(Type:float)||is(Type:uint)||is(Type:bool))";
private enum string constrainTypeWOBool_m = "(is(Type:int)||is(Type:float)||is(Type:uint))";






