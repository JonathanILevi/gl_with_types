
module glwt.shader;

import cst_	;

import derelict.opengl	;





enum ShaderType {
	Vertex	= GL_VERTEX_SHADER	,
	Fragment	= GL_FRAGMENT_SHADER	,
	Geometry	= GL_GEOMETRY_SHADER	,
}
alias shader_type_t = ShaderType;



/**	A wrapper for a shader.*/
struct Shader(ShaderType shaderType) {
	uint id = 0;
}
alias VertexShader	= Shader!(ShaderType.Vertex	) ;
alias FragmentShader	= Shader!(ShaderType.Fragment	) ;
alias GeometryShader	= Shader!(ShaderType.Geometry	) ;






/**	glCreateShader wrapper.
*/
void
create(ShaderType shaderType)(ref Shader!shaderType shader)
{
	import std.stdio;
	"ad".writeln;
	shader.id = glCreateShader(shaderType);
	shader.id.writeln;
}
/**	glDeleteShader wrapper.
*/
void
del(ShaderType shaderType)(ref Shader!shaderType shader)
{
	glDeleteShader(shader.id);
}






enum string shader_ensureGen_m = "version(assert){assert(shader.id!=0, \"Shader not created.  Call `shader.create` before using this function.\");}";





/**	glShaderSource wraper
*/
void
source(ShaderType shaderType)(ref Shader!shaderType shader, string code)
{
	mixin(shader_ensureGen_m);
	import std.string : toStringz;
	char* stringzCode = code.toStringz.cst!(char*);
	glShaderSource(shader.id, 1, &stringzCode, null);
}

/**	glCompileShader wraper
*/
void
compile(ShaderType shaderType)(ref Shader!shaderType shader)
{
	mixin(shader_ensureGen_m);
	glCompileShader(shader.id);
}
