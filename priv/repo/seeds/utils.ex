defmodule Liveview.Seeds.Utils do
  @colors [
    "E6F7FF", "FFEBEE", "E8F5E9", "FFF8E1", "F3E5F5",
    "E0F7FA", "FFF3E0", "F1F8E9", "E8EAF6", "FAFAFA"
  ]

  def create_image_url(name) do
    encoded_name = URI.encode(name)
    bg_color = Enum.random(@colors)
    "https://placehold.co/600x400/#{bg_color}/31343C.svg?font=playfair-display&text=#{encoded_name}"
  end
end
