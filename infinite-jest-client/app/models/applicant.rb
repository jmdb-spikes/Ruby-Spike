class Applicant 
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveSupport::JSON
  
  attr_accessor :id, :firstname, :lastname, :age, :claimDate
  
  attr_accessor :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end
  
  def read_attribute_for_validation(key)
    @attributes[key]
  end
  
  def self.all
     json = RestClient.get 'http://localhost:3001/applicants.json'
     resources = JSON.parse(json)
    @applicants = []
    resources.each { |resource| 
        @applicants.push(Applicant.from_hash(resource)) 
    } 
    return @applicants
  end
  
  def self.from_hash(hash)
    applicant = Applicant.new
    applicant.firstname = hash['firstname']
    applicant.lastname = hash['lastname']
    applicant.age = hash['age']
    applicant.claimDate = hash['claimDate']
    applicant.id = hash['id']
    return applicant  
  end
end
