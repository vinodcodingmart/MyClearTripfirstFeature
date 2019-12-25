json.extract! datum, :id, :keyword, :url, :slot, :apply_count, :created_at, :updated_at
json.url datum_url(datum, format: :json)
