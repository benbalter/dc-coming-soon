json.array!(@zoning_cases) do |zoning_case|
  json.extract! zoning_case, :id
  json.url zoning_case_url(zoning_case, format: :json)
end
