class User < ActiveRecord::Base
    has_many :elections, dependent: :destroy
    validates :name, presence: true
end
