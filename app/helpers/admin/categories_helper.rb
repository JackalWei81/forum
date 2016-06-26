module Admin::CategoriesHelper

  def category_used?(category)
    category.topics.size == 0 ? false : true
  end
end
