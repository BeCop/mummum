json.array!(@stories) do |story|
  json.extract! story, :id, :title, :content, :picture
  json.url story_url(story, format: :json)
end
