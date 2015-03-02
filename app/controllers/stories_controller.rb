class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(story_params)
		flash[:notice] = 'Story was successully created.' if @story.save
		respond_with @story
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
		flash[:notice] = 'Story was sucessfully updated.' if @story.update(story_params)
		respond_with @story
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
		flash[:notice] = 'Story was successfully destroyed'	
    respond_with(@story, :location => stories_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :content, :picture)
    end
end
