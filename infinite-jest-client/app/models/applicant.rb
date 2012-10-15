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
    true
  end
  
  def self.find(id) 
    json = RestClient.get 'http://localhost:3001/applicants/'+id+'.json'
    resource = JSON.parse(json)
    return Applicant.new(resource)
  end
  
  def self.all
     json = RestClient.get 'http://localhost:3001/applicants.json'
     resources = JSON.parse(json)
    @applicants = []
    resources.each { |resource| 
      #  @applicants.push(Applicant.new(:id  => 1, :firstname => 'Peter', :lastname => 'Piper', :age => 20)) 
      @applicants.push(Applicant.new(resource))
      p @applicants
    } 
    return @applicants
  end
end
