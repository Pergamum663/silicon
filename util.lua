local util = {}

-- Add a prerequisite to a given technology
function util.add_prerequisite(technology_name, prerequisite)
  technology = data.raw.technology[technology_name]
	table.insert(technology.prerequisites, prerequisite)
end

-- Add a given quantity of ingredient to a given recipe
function util.add_ingredient(recipe_name, ingredient, quantity)
  add_ingredient(data.raw.recipe[recipe_name], ingredient, quantity)
  add_ingredient(data.raw.recipe[recipe_name].normal, ingredient, quantity)
  add_ingredient(data.raw.recipe[recipe_name].expensive, ingredient, quantity)
end

function add_ingredient(recipe, ingredient, quantity)
  if recipe ~= nil and recipe.ingredients ~= nil then
    table.insert(recipe.ingredients, {ingredient, quantity})
  end
end

-- Replace one ingredien with another in a recipe
function util.replace_ingredient(recipe_name, old, new)
   replace_ingredient(data.raw.recipe[recipe_name], old, new)
   replace_ingredient(data.raw.recipe[recipe_name].normal, old, new)
   replace_ingredient(data.raw.recipe[recipe_name].expensive, old, new)
end

function replace_ingredient(recipe, old, new)
	if recipe ~= nil and recipe.ingredients ~= nil then
		for i, ingredient in pairs(recipe.ingredients) do 
			-- For final fixes
			if ingredient.name == old then ingredient.name = new end
			-- For updates
			if ingredient[1] == old then ingredient[1] = new end
		end
	end
end

-- Remove an ingredient from a recipe
function util.remove_ingredient(recipe_name, old)
  remove_ingredient(data.raw.recipe[recipe_name], old)
  remove_ingredient(data.raw.recipe[recipe_name].normal, old)
  remove_ingredient(data.raw.recipe[recipe_name].expensive, old)
end

function remove_ingredient(recipe, old)
  index = -1
	if recipe ~= nil and recipe.ingredients ~= nil then
		for i, ingredient in pairs(recipe.ingredients) do 
      if ingredient.name == old or ingredient[1] == old then
        index = i
        break
      end
    end
    if index > -1 then
      table.remove(recipe.ingredients, index)
    end
  end
end


-- Replace an amount of an ingredient in a recipe. Keep at least 1 of old.
function util.replace_some_ingredient(recipe_name, old, new, amount)
  replace_some_ingredient(data.raw.recipe[recipe_name], old, new, amount)
  replace_some_ingredient(data.raw.recipe[recipe_name].normal, old, new, amount)
  replace_some_ingredient(data.raw.recipe[recipe_name].expensive, old, new, amount)
end

function replace_some_ingredient(recipe, old, new, amount)
	if recipe ~= nil and recipe.ingredients ~= nil then
		for i, ingredient in pairs(recipe.ingredients) do 
			-- For final fixes
			if ingredient.name == old then
        ingredient.amount = math.max(1, ingredient.amount - amount)
      end
			-- For updates
			if ingredient[1] == old then
        ingredient[2] = math.max(1, ingredient[2] - amount)
      end
		end
    add_ingredient(recipe, new, amount)
	end
end

return util
