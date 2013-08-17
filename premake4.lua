local OS=os.get()

local cmd = {
 dir = { linux = "ls", windows = "dir" }
}

local Commands={}

for i,v in pairs(cmd) do
 Commands[i]=cmd[i][OS]
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
		libdirs {	[[./Lua/lib]]
			} --check whether the correct lua library linked
		includedirs {  --check whether the correct lua headers are included
			[[./Lua/include]], 
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
		configuration "linux"
			links { "lua" }
		configuration "windows"
			links { "lua5.1" }
