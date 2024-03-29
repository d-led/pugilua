local potential_paths = {
	'../bin/windows/vs2013/x32/Release/?.dll',
	'../bin/windows/vs2013/x32/Debug/?.dll',
	'../bin/windows/vs2013/x64/Release/?.dll',
	'../bin/windows/vs2013/x64/Debug/?.dll',
	'../bin/windows/vs2013/native/Release/?.dll',
	'../bin/windows/vs2013/native/Debug/?.dll',
	'../bin/linux/gmake/x32/Release/?.so',
	'../bin/linux/gmake/x32/Debug/?.so',
	'../bin/linux/gmake/x64/Release/?.so',
	'../bin/linux/gmake/?.so',
	'../bin/linux/gmake/x64/Debug/?.so',
	'../bin/macosx/gmake/x32/Debug/?.dylib',
	'../bin/macosx/gmake/x32/Release/?.dylib',
	'../bin/macosx/gmake/x64/Debug/?.dylib',
	'../bin/macosx/gmake/x64/Release/?.dylib'
}

local extra_cpath = table.concat(potential_paths, ";");
package.cpath = extra_cpath..';'..package.cpath

assert(require 'pugilua')

print(pugi.version)

local doc=pugi.xml_document()
os.execute("cd")
local res=doc:load_file [[../Build/windows/vs2013/pugilua.vcxproj]]
print(res.description)
assert(res.valid)

local node=doc:root():child('Project')
assert(node.valid)
print(node.valid)
print(node.name)
local query1=doc:root():select_nodes('Project/PropertyGroup')
local query2=node:select_nodes('PropertyGroup')
assert(query1)
assert(query2)
print(query1.type,pugi.xpath_node_set.type_sorted)
query1:sort(true)
print(query1.type,pugi.xpath_node_set.type_sorted)
print(query1.size,query2.size)
n=query1.size
for i=0,n-1 do
	local node=query1:get(i):node()
	local attribute=query1:get(i):attribute()
	print(node.valid,node.path,attribute.valid)
	local a=node:first_attribute()
	while a.valid do
		print(a.name)
		a=a:next_attribute()
	end
end

----
node=doc:root():child('Project')
--print(node.string)

----
doc:reset()
--- from the tutorial
-- add node with some name
local node = doc:root():append_child("node");

local t=node:append_child("test"):text():set(123)
print(node.string)

-- add description node with text child
local descr = node:append_child("description");
descr:append(pugi.node_pcdata):set_value("Simple node");

-- add param node before the description
local param = node:insert_child_before("param", descr);

-- add attributes to param node
param:append_attribute("name"):set_value("version");
param:append_attribute("value"):set_value(1.1);
param:insert_attribute_after("type", param:attribute("name")):set_value("float");

print(doc:save_file("tutorial.xml"));
