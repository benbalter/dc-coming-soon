json.array!(@abra_notices) do |abra_notice|
  json.extract! abra_notice, :id, :posting_date, :petition_date, :hearing_date, :protest_date, :anc_id, :license_class_id
  json.url abra_notice_url(abra_notice, format: :json)
end
