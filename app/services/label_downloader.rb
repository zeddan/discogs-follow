class LabelDownloader
  def initialize(name, release_id)
    @name = name
    @release_id = release_id
  end

  def call
    save_label
  end

  private

  def save_label
    release = call_api
    label = release["labels"].detect { |key| key["name"] == @name }
    label_id = label["id"] unless label.nil?
    Label.create!(discogs_label_id: label_id, name: @name)
  end

  def call_api
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def credentials
    {
      key: Rails.application.credentials.discogs_key,
      secret: Rails.application.credentials.discogs_secret
    }
  end

  def url
    [
      "https://api.discogs.com/releases/#{@release_id}?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
end
