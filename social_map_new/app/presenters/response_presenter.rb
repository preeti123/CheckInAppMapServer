class ResponsePresenter
  def initialize(options = {})
    @data = options[:data]
    @root = options[:root]
    @pagination = options[:pagination]
  end

  def to_json(something)
    Rails.logger.info("[ResponsePresenter.to_json] called with #{something}")
    body = if @data
      if @root.present?
        { @root => @data }
      else
        @data
      end
    end

    if body && body.is_a?(Hash)
      if @pagination
        body[:pagination] = @pagination
      elsif @data.respond_to?(:current_page)
        body[:pagination] = { :page => @data.current_page, :perPage => @data.per_page, :total => @data.total_entries }
      end
    end

    body ? body.to_json : ""
  end
end
