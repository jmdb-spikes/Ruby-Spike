class Applicant
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ActiveSupport::JSON

  attr_accessor :id, :firstname, :lastname, :age, :claimDate, :created_at, :updated_at

  #TODO: refactor resource URL generation

  def initialize(attributes = {})
    #TODO to handle dates should translate "claimDate(1i)"=>"2012", "claimDate(2i)"=>"11", "claimDate(3i)"=>"22" to a date field

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def persisted?
    self.id != nil
  end

  def self.find(id)
    json = RestClient.get 'http://localhost:3001/applicants/'+id+'.json', :content_type => :json, :accept => :json
    resource = JSON.parse(json)
    return Applicant.new(resource)
  end

  def self.all
    json = RestClient.get 'http://localhost:3001/applicants.json', :content_type => :json, :accept => :json
    resources = JSON.parse(json)
    return resources.map {|resource| Applicant.new(resource)}
  end

  def save
    RestClient.post('http://localhost:3001/applicants.json', self.to_json, :content_type => :json, :accept => :json) { |response, request, result, &block|
      case response.code
        when 201
          true
        when 422
          _parse_errors(response)
          false
        else
          response.return!(request, result, &block)
      end
    }
  end

  def update_attributes(params)
    _merge_attributes(params)

    RestClient.put('http://localhost:3001/applicants/'+self.id.to_s+'.json', self.to_json, :content_type => :json, :accept => :json) { |response, request, result, &block|
      case response.code
        when 200
          true
        when 422
          _parse_errors(response)
          false
        else
          response.return!(request, result, &block)
      end
    }
  end

  def destroy
    RestClient.delete('http://localhost:3001/applicants/'+self.id.to_s+'.json', :content_type => :json, :accept => :json) { |response, request, result, &block|
      case response.code
        when 204
          true
        else
          response.return!(request, result, &block)
      end
    }
  end

  def _parse_errors(response)
    errors = JSON.parse(response.to_str)
    errors.each { |key, value|
      self.errors.add(key, value)
    }
  end

  def _merge_attributes(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

end
