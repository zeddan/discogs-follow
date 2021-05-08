class LabelProcessor
  def initialize(release)
    @release = release
  end

  def call
    save_labels
  end

  private

  def save_labels
    @release["labels"].map do |fetched_label|
      label = Label.find_or_create_by!(discogs_label_id: fetched_label["id"])
      label.update(name: fetched_label["name"])
      label
    end
  end
end
