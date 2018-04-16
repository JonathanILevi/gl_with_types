

module glwt;



import derelict.opengl;


GLVersion delegate() reloadGl;

static this() {
	DerelictGL3.load;
	reloadGl = &DerelictGL3.reload;
}
static ~this() {

}


