require 'nokogiri'
require 'open-uri'

class ScrapeBbcGoodFood
  RECIPES_QUERY = "https://www.bbcgoodfood.com/search/recipes?query="
  TEST_FILE_PATH = "strawberry.html"
  private_constant :RECIPES_QUERY, :TEST_FILE_PATH

  def initialize(keyword, max_recipes = 5, use_test_file = false)
    @keyword = keyword
    @use_test_file = use_test_file
    @recipe_query = RECIPES_QUERY + keyword
    @max_recipes = max_recipes
  end

  def find_recipes_online
    html_file = @use_test_file ? File.open('strawberry.html') : open(@recipe_query).read
    doc = Nokogiri::HTML(html_file, nil, 'utf-8')
    recipes = []
    doc.search('.node-recipe').first(@max_recipes).each do |node|
      recipes << node_to_hash(node)
    end
    recipes
  end

  def self.call(keyword, max_recipes = 5, use_test_file = false)
    ScrapeBbcGoodFood.new(keyword, max_recipes, use_test_file).find_recipes_online
  end

  private

  def node_to_hash(node)
    {
      name: node.at('.teaser-item__title').content.strip,
      description: node.at('.field-type-text-with-summary').content.strip,
      prep_time: node.at('.teaser-item__info-item--total-time').content.strip,
      difficulty: node.at('.teaser-item__info-item--skill-level').content.strip
    }
  end
end
