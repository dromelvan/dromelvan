class UploadJsonFile
  
  def upload(json_file)
    upload_result = {}
    upload_result[:validation_errors], data = validate_json(json_file)
    if !upload_result[:validation_errors].any?
      upload_result[:data_errors], upload_result[:missing_players] = validate_data(data)
      if !upload_result[:data_errors].any? && !upload_result[:missing_players].any?
        upload_result[:data_updates] = update_data(data)
      end
    end
    upload_result
  end
  
  private
    def validate_json(json)
      begin
        data = JSON.parse(json, object_class: OpenStruct)
        return [], data
      rescue JSON::ParserError => e
        return [ e.message ], nil
      end
    end
  
end
  
