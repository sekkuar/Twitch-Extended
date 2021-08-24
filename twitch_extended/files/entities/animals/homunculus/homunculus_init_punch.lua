dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local types =
{
	{
		name="punch",
		AnimalAIComponent =
		{
			attack_ranged_enabled=false,
			attack_melee_enabled=true,
			attack_melee_damage_min=0.9,
			attack_melee_damage_max=1.4,
			attack_melee_action_frame=3,
		},
	},
}

local storages = EntityGetComponent( entity_id, "VariableStorageComponent" )
local style = ""
local data

if ( storages ~= nil ) then
	for i,comp in ipairs( storages ) do
		local name = ComponentGetValue2( comp, "name" )
		if ( name == "type" ) then
			style = ComponentGetValue2( comp, "value_string" )
			break
		end
	end
end

if ( #style > 0 ) then
	for i,v in ipairs(types) do
		if ( v.name == style ) then
			data = types[i]
		end
	end
end

if ( data == nil ) then
	SetRandomSeed( x, y * entity_id )
	local rnd = Random( 1, #types )
	data = types[rnd]
end

--edit_component( entity_id, "DamageModelComponent", function(comp,vars)
--	local max_hp = ( math.floor( y / 512 ) * 0.5 ) + 0.5
--	
--	ComponentSetValue2( comp, "max_hp", max_hp )
--	ComponentSetValue2( comp, "hp", max_hp )
--end)

for i,v in pairs(data) do
	if ( type( v ) == "table" ) then
		edit_component( entity_id, i, function(comp,vars)
			for a,b in pairs( v ) do
				ComponentSetValue2( comp, a, b )
			end
		end)
	end
end

if EntityHasTag( entity_id, "homing_target" ) then
	EntityRemoveTag( entity_id, "homing_target" )
end