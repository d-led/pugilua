local OS=os.get()

local cmd = {
 dir =     { linux = "ls", windows = "dir", macosx = "ls" },
 libdirs = { linux = { "" }, windows = { "./Lua/lib" }, macosx = { "" } },
 includedirs = { linux = { "/usr/include/lua5.1"}, windows = { "./Lua/include", os.getenv("BOOST") }, macosx = { "" } },
 links = { linux = { "lua5.1-c++" }, windows = { "lua5.1" }, macosx = { "lua","c++" } },
 location = { linux = "Build", windows = "Build", macosx = "BuildClang" },
 buildoptions = { linux = "-v -std=gnu++0x -fPIC", windows = "-v -std=c++11 -fPIC", macosx = "-v -stdlib=libc++ -std=c++11 -fPIC" }
}

local cfg={}

for i,v in pairs(cmd) do
 cfg[i]=cmd[i][OS]
end

-- Apply to current "filter" (solution/project)
function DefaultConfig()
	location "Build"
	configuration "Debug"
		defines { "DEBUG", "_DEBUG" }
		objdir "Build/obj"
		targetdir "./Lua/lib"
		targetprefix ""
		flags { "Symbols" }
	configuration "Release"
		defines { "RELEASE" }
		objdir "Build/obj"
		targetdir "./Lua/lib"
		targetprefix ""
		flags { "Optimize" }
	configuration "*" -- to reset configuration filter
end

function CompilerSpecificConfiguration()
	configuration {"xcode*" }
		postbuildcommands {"$TARGET_BUILD_DIR/$TARGET_NAME"}

	configuration {"gmake"}
		postbuildcommands  { "$(TARGET)" }
		buildoptions { "-v -std=gnu++0x -fPIC" }

	configuration {"codeblocks" }
		postbuildcommands { "$(TARGET_OUTPUT_FILE)"}

	configuration { "vs*"}
		postbuildcommands { "\"$(TargetPath)\"" }
end

----------------------------------------------------------------------------------------------------------------

newaction {
   trigger     = "run",
   description = "run lua",
   execute     = function ()
      os.execute("lua -l pugilua")
   end
}

----------------------------------------------------------------------------------------------------------------

-- A solution contains projects, and defines the available configurations
local sln=solution "pugilua"
	location "Build"
		sln.absbasedir=path.getabsolute(sln.basedir)
		configurations { "Debug", "Release" }
		platforms { "native","x32", "x64" }
		libdirs ( cfg.libdirs )
		includedirs ( cfg.includedirs )
		includedirs {
			[[./LuaBridge/Source/LuaBridge]],
			[[./pugixml/src]]
		}
		vpaths {
			["Headers"] = {"**.h","**.hpp"},
			["Sources"] = {"**.c", "**.cpp"},
		}

----------------------------------------------------------------------------------------------------------------
   local dll=project "pugilua"
   location "Build"
		kind "SharedLib"
		DefaultConfig()
		language "C++"
		files {
			"./pugilua/*.h",
			"./pugilua/*.cpp",
			"./pugixml/src/*.hpp",
			"./pugixml/src/*.cpp"
		}
		links(cfg.links)
