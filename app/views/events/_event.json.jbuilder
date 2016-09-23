json.extract! event, :id, :name, :start_date, :finish_date, :start_location, :end_location, :created_at, :updated_at
json.url event_url(event, format: :json)