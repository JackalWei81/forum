class Admin::CategoriesController < ApplicationController

  before_action :set_category, :only => [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Created successfully!!"
      redirect_to admin_categories_path
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Edited successfully!!"
      redirect_to admin_categories_path
    else
      render :action => :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:alert] = "Delete successfully!!"
      redirect_to admin_categories_path
    end
  end

  protected

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
