include 'premake'

make_solution 'pugilua'

platforms { "native","x32", "x64" }

includedirs { 
    './LuaBridge-1.0.2',
    './pugixml/src'
}

local OS = os.get()
local settings = {
    includedirs = {
        linux = {'/usr/include/lua5.1'},
        windows = { [[C:\\luarocks\\2.1\\include]] },
        macosx = { '/usr/local/include'}
    },
    libdirs = {
        linux = {},
        windows = { [[C:\\luarocks\\2.1]] },
        macosx = { '/usr/local/lib'}	
    },
    links = {
        linux = { 'lua5.1' },
        windows = { 'lua5.1' },
        macosx = { 'lua' }
    }
}

includedirs { settings.includedirs[OS] }
libdirs { settings.libdirs[OS] }

make_shared_lib('pugilua', {
			"./pugilua/*.h",
			"./pugilua/*.cpp",
			"./pugixml/src/*.hpp",
			"./pugixml/src/*.cpp"
})

links( settings.links[OS] )
