class UserSerializer < ActiveModel::Serializer
  attributes :id, :auth_token
end
