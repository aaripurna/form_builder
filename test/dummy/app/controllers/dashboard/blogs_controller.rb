module Dashboard
  class BlogsController < DashboardController
    before_action :set_blog, except: [:create, :index, :new]

    def index
      @blogs = Blog.all
    end

    def new
      @blog = Blog.new
    end

    def edit
    end

    def show
      redirect_to action: :edit
    end

    def create
      @blog = Blog.new(blog_params)
      respond_to do |format|
        if @blog.save
          format.html { redirect_to action: :index, notice: "blog updated successfully!" }
          format.json { render json: { location: dashboard_blogs_url }, status: :created }
        else
          format.html { redirect_to action: :edit, notice: "failed to update blog" }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @blog.update(blog_params)
          format.html { redirect_to action: :index, notice: "blog updated successfully!" }
          format.json { render json: { location: dashboard_blogs_url }, status: :ok }
        else
          format.html { redirect_to action: :edit, notice: "failed to update blog" }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @blog.destroy
          format.html { redirect_to action: :index, notice: "blog deleted successfully!" }
          format.json { render json: { location: dashboard_blogs_url }, status: :ok }
        else
          format.html { redirect_to action: :index, notice: "failed to delete blog" }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def blog_params
      params.require(:blog).permit(:title, :slug, :body)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to action: :index
    end
  end
end
