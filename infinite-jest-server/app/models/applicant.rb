class Applicant < ActiveRecord::Base
  attr_accessible :age, :claimDate, :firstname, :lastname
  
  validates :firstname, :lastname, :presence => true
  validates :age,  numericality: {:greater_than  => 18}
  
end
