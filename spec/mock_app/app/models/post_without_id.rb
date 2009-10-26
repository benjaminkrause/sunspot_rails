class PostWithoutId < ActiveRecord::Base
  self.primary_key = "uuid"
  
  before_create :generate_uuid

  searchable :ignore_attribute_changes_of => [ :updated_at ] do
    string :title
  end
  
  def generate_uuid
    self.uuid = Digest::MD5.hexdigest( "post-id-#{Time.now}") # pseudo uuid
  end
end
