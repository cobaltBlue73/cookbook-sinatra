require 'csv'
require_relative 'recipe'

class Cookbook
  CSV_READ_OPT = {
    col_sep: ','
    # headers: true
  }
  CSV_WRITE_OPT = {
    col_sep: ',',
    force_quotes: true,
    quote_char: '"'
  }
  private_constant :CSV_READ_OPT, :CSV_WRITE_OPT

  def initialize(csv_file_path)
    @recipes = []
    @file_path = csv_file_path
    CSV.foreach(csv_file_path, CSV_READ_OPT) do |name, description, done, prep_time, difficulty|
      done_val = done.downcase == 'true'
      @recipes << Recipe.new(name, description, done_val, prep_time, difficulty)
    end
  end

  def all
    @recipes.clone
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_to_file
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    write_to_file
  end

  def mark_recipe_done(recipe_index)
    @recipes[recipe_index].mark_done!
    write_to_file
  end

  private

  def write_to_file
    CSV.open(@file_path, 'wb', CSV_WRITE_OPT) do |csv|
      @recipes.each do |recipe| 
        csv << [recipe.name, recipe.description, 
                recipe.done?, recipe.prep_time, 
                recipe.difficulty]
      end
    end
  end
end
