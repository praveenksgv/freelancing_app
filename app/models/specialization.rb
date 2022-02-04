class Specialization < ApplicationRecord
  belongs_to :user

  before_save :remove_spaces, :name_upcase

  validates :name, presence: true, length: { minimum: 2 }

  validates_uniqueness_of :user_id, scope: :name


  #validation is just one such that the specialization should not be empty

  private
    def name_upcase
      if self.name.nil? 
        return true
      end
      self.name = name.upcase
    end

    def remove_spaces
      if self.name.nil?
        return true 
      end
      self.name = name.strip
    end

end
