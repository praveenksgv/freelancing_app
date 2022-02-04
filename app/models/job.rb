class Job < ApplicationRecord
  belongs_to :user
  before_save :upcase_skills
  default_scope -> {order(created_at: :desc)}

  has_many :requests, dependent: :destroy


  validates :title, presence: true, length: {minimum: 15, maximum: 100}
  validates :description, presence: true, length: {minimum: 200, maximum: 3000}
  validates :state, presence: true
  validates :budget, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :skills, presence: true
  validate :atleast_one_skill 

  #state - closed 0 , private 1, public 2
  #Validations
  #title - minimum_length=50, maximum_length=255
  #description - minimum_length: 300
  #state - presence: true
  #budget - should be positive, precision:6, scale:2
  #skills - presence: true, atleast one skill should be present, skill length should greater than one

  def atleast_one_skill
    if skills.nil?
      return true
    else
      a = skills.split(',')
      a.each do |b|
        c = b.strip 
        if c.length > 1
          return true
        end
      end
    end
    errors.add(:skills, "should be present in the Job")
  end


  private
    def upcase_skills
      self.skills = skills.upcase 
    end
end

  
