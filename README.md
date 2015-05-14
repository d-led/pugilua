pugilua
=======

An almost one-to-one lua binding for [pugixml](http://pugixml.org/).

[![Build Status](https://travis-ci.org/d-led/pugilua.png?branch=master)](https://travis-ci.org/d-led/pugilua)

Usage
-----

````lua
require 'pugilua'


---- reading ----
local doc=pugi.xml_document()
local res=doc:load_file [[..\..\scripts\pugilua\pugilua.vcxproj]]

print(res.description)

local node1=doc:root():child('Project')
local query1=doc:root():select_nodes('Project/PropertyGroup')

local n=query1.size
for i=0,n-1 do
  local node=query1:get(i):node()
	local attribute=query1:get(i):attribute()
	print(node.valid,node.path)
	local a=node:first_attribute()
	while a.valid do
		print(a.name)
		a=a:next_attribute()
	end
end

---- creating ----
doc:reset()
--- from the tutorial
-- add node with some name
local node = doc:root():append_child("node")

-- add description node with text child
local descr = node:append_child("description")
descr:append(pugi.node_pcdata):set_value("Simple node")

-- add param node before the description
local param = node:insert_child_before("param", descr)

-- add attributes to param node
param:append_attribute("name"):set_value("version")
param:append_attribute("value"):set_value(1.1)
param:insert_attribute_after("type", param:attribute("name")):set_value("float")

doc:save_file("tutorial.xml")
````

See an [imperfect example](https://gist.github.com/3832071) of dumping an xml file in a less verbose format,
or a filter of [vcproj](https://gist.github.com/3832285) or [vcxproj](https://gist.github.com/3832290) source files into lua tables

### API differences

 * There's no explicit cast to boolean of the pugilua objects, hence the classes `xml_parse_result, xml_node and xml_document` have a boolean `property` valid
 * lua classes do not have inheritance as pugixml classes do
 * Getter methods are mapped to lua properties and not methods

In-detail API mapping from pugixml to pugilua can be viewed on [google docs](https://docs.google.com/spreadsheet/ccc?key=0AnZVgVA3E-DRdFY5eVp1ZUZHZW9GMzUwY0pfT0VuRVE)

### Building

A premake4 script and a couple of batch files reside in the top directory to generate makefiles into the Build directory. The generated Visual Studio 2013 solution is available in the repository.

Before generating or using the makefiles, check the include and linker paths, so that you compile with the correct lua headers and link to the correct library.

The output is always put into Lua/lib at the moment for convenience, but might be changed, so that different versions can coexist.

Dependencies
------------

 * [pugixml](https://github.com/zeux/pugixml) the original library
 * [lua](http://www.lua.org/)
 * [LuaBridge](https://github.com/vinniefalco/LuaBridge) for the declarative bindings to Lua
 * [premake4](http://industriousone.com/premake) for generating makefiles

License
-------

This library is distributed under the MIT License:

Copyright (c) 2012-2014 Dmitry Ledentsov

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
