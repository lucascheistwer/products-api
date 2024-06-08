class Product
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def to_json(*_args)
    { id: @id, name: @name }.to_json
  end
end
