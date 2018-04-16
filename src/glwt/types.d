module glwt.types;

import derelict.opengl;


enum DataType {
	Byte	= GL_BYTE	,
	UByte	= GL_UNSIGNED_BYTE	,
	Short	= GL_SHORT	,
	UShort	= GL_UNSIGNED_SHORT	,
	Int	= GL_INT	,
	UInt	= GL_UNSIGNED_INT	,
	Float	= GL_FLOAT	,
	Double	= GL_DOUBLE	,
}
alias type_t = DataType;