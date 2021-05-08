class LabelDownloader
  def initialize(release_id)
    @release_id = release_id
  end

  def call
    save_labels
  end

  private

  def save_labels
    release = call_api
    release["labels"].map do |fetched_label|
      label = Label.find_or_create_by!(discogs_label_id: fetched_label["id"])
      label.update(name: fetched_label["name"])
      label
    end
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
