class Artists::FollowsController < FollowsController # rubocop:disable Style/ClassAndModuleChildren
  before_action :set_followable, except: :new

  def new
    @artist = Artist.new
  end

  def create
    @followable = Artist.find_or_create_by(artist_params)
    super
  end

  private

  def set_followable
    @followable = Artist.find_or_create_by(id: params[:artist_id])
  end

  def artist_params
    params.require(:artist).permit(:name, :discogs_artist_id)
  end
end
