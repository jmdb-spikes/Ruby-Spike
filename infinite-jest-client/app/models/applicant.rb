class Applicant 
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ActiveSupport::JSON
  
  attr_accessor :id, :firstname, :lastname, :age, :claimDate, :created_at, :updated_at
  
  def initialize(attributes = {})
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

  #def to_key
  #  "#{id}="
  #end

  def self.find(id) 
    json = RestClient.get 'http://localhost:3001/applicants/'+id+'.json'#TODO, :accept => :json
    resource = JSON.parse(json)
    return Applicant.new(resource)
  end
  
  def self.all
     json = RestClient.get 'http://localhost:3001/applicants.json'#TODO, :accept => :json
     resources = JSON.parse(json)
    @applicants = []
    resources.each { |resource| 
      @applicants.push(Applicant.new(resource))
    }
    return @applicants
  end

  def save
    p self
    RestClient.post('http://localhost:3001/applicants.json', self.to_json, :content_type => :json, :accept => :json) { |response, request, result, &block|
      case response.code
      when 201
        true
      when 422
        errors = JSON.parse(response.to_str)
        errors.each{ |key, value|
          self.errors.add(key, value)
        }
        false
      else
        response.return!(request, result, &block)
      end
    }
  end

  def update_attributes(params)
    p params

    params.each do |name, value|
      send("#{name}=", value)
    end

    p self.to_json

    p 'http://localhost:3001/applicants/'+self.id.to_s+'.json'

    response = RestClient.put('http://localhost:3001/applicants/'+self.id.to_s+'.json', self.to_json, :content_type => :json, :accept => :json) { |response, request, result, &block|
      case response.code
      when 200
        true
      when 422
        errors = JSON.parse(response.to_str)
        errors.each{ |key, value|
          self.errors.add(key, value)
        }
        false
      else
        response.return!(request, result, &block)
      end
    }

  end
end
