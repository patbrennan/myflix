1) You should be using strong_parameters in your controllers.

2) Rails 4.x requires that scopes use a callable object. You need to take care of this mostly on ordering those has_many relationships. For example, instead of has_many :videos, order: :name you should do has_many :videos, ->{ order(:name) }