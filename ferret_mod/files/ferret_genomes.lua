dofile_once( "data/scripts/lib/utilities.lua" )

function split_string(inputstr, sep)
  sep = sep or "%s"
  local t= {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local content = ModTextFileGetContent("data/genome_relations.csv")

--The function works like this: genome_name is the name of your new genome/faction,
--default_relation_ab is the relation with all the horizontal genomes which relations weren't specified in the table,
--default_relation_ba is the relation with all the vertical genomes which relations weren't specified in the table,
--self relation is the genome's relation with itself,
--relations is a table which directly specifies the value of the genome relation with.

--- @param content string original content of the file
--- @param genome_name string the name of the genome we add
--- @param default_relation_ab integer how much this genome likes everyone else by default
--- @param default_relation_ba integer how much everyone else likes this genome by default
--- @param self_relation integer how much does this genome like itself
--- @param relations table specific relations to other genomes, use it to give specific relations to other genomes
--- @return string content changed content of the file
function add_new_genome(content, genome_name, default_relation_ab, default_relation_ba, self_relation, relations)
  local lines = split_string(content, "\r\n")
  local output = ""
  local genome_order = {}
  for i, line in ipairs(lines) do
    if i == 1 then
      output = output .. line .. "," .. genome_name .. "\r\n"
    else
      local herd = line:match("([%w_-]+),")
      output = output .. line .. ","..(relations[herd] or default_relation_ba).."\r\n"
      table.insert(genome_order, herd)
    end
  end

  local line = genome_name
  for i, v in ipairs(genome_order) do
    line = line .. "," .. (relations[v] or default_relation_ab)
  end
  output = output .. line .. "," .. self_relation

  return output
end

-- the game generates an agression value, and if that value is lower than the relationship with the other faction, that means no attack
-- e.g. if ferrets had a relation of 50 towards the player, that means if the game generates agression 10, the player is not attacked.
-- but if the game generates 60, that particular ferret will attack the player!
-- so 0 basically means "always attack this other faction"
-- and 100 basically means "never attack this other faction"
-- tldr: if angriness > like_other -> attack
--       if angriness < like_other -> no attack

-- you can basically think of the value as "how much do I like this other faction?" and if the game generates the mob with enough agression, it attacks because it doesn't actually like them that much

-- friendly ferret, attack no one and no one attacks you
content = add_new_genome(content, "friendly_ferret", 100, 100, 100, {
  rat = 40,
})

-- hostile ferret, attacks the player
content = add_new_genome(content, "hostile_ferret", 100, 100, 100, {
  player = 0,
  rat = 40,
  helpless = 80
})

-- soldier ferret, attack everything except the player and friendly ferrets (will attack hostile ferrets, and be attacked by hostile ferrets)
content = add_new_genome(content, "soldier_ferret", 0, 0, 100, {
  player = 100,
  friendly_ferret = 100,
  helpless = 100
})

ModTextFileSetContent("data/genome_relations.csv", content)
