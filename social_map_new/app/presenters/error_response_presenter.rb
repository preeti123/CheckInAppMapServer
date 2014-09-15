class ErrorResponsePresenter
  def initialize(http_code, errors)
    @http_code = http_code
    @errors = errors
  end

  def to_json(something)
    Rails.logger.info("[ErrorResponsePresenter.to_json] called with #{something}")
    response_hash.to_json
  end

  def to_s
    "api_error_status=#{@http_code} api_error_list=#{errors_hash.to_json}"
  end

  def response_hash
    {
      :httpCode => @http_code,
      :errors => errors_hash
    }
  end

  def errors_hash
    @errors.map do |e|
      {
        :code => e[:code],
        :message => e[:message],
        :refersTo => e[:refers_to],
        :values => e[:values]
      }.reject { |k, v| v.blank? }
    end
  end

end
