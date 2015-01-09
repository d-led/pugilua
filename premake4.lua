include 'premake'

make_solution 'pugilua'

platforms { "native","x32", "x64" }

lua = assert(dofile 'premake/recipes/lua.lua')

OS = os.get()

make_shared_lib('pugilua', {
			"./pugilua/*.h",
			"./pugilua/*.cpp",
			"./pugixml/src/*.hpp",
			"./pugixml/src/*.cpp"
})
includedirs {
    './LuaBridge-1.0.2',
    './pugixml/src',
    lua.includedirs[OS]
}
libdirs { lua.libdirs[OS] }
links( lua.links[OS] )

targetprefix ""
