include 'premake'

make_solution 'pugilua'

platforms { "native","x32", "x64" }

lua = assert(dofile 'premake/recipes/lua.lua')

lua.includedirs.macosx[#lua.includedirs.macosx] = '/usr/local/include/lua'

OS = os.get()

make_shared_lib('pugilua', {
			"./pugilua/*.h",
			"./pugilua/*.cpp",
			"./deps/pugixml/src/*.hpp",
			"./deps/pugixml/src/*.cpp"
})
includedirs {
    './deps/LuaBridge-1.0.2',
    './deps/pugixml/src',
    lua.includedirs[OS]
}
libdirs { lua.libdirs[OS] }
links( lua.links[OS] )

targetprefix ""
