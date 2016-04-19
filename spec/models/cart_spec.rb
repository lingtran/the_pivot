require 'rails_helper'

RSpec.describe Cart, type: :model do
  context "add contents to cart" do
    it "can have contents" do
      cart = Cart.new({"1" => 1})

      expect(cart.contents).to eql({"1" => 1})
    end

    it "can add tasks to cart" do
      cart = Cart.new({"1" => 1})

      cart.add_task(1)
      cart.add_task(3)

      expect(cart.contents).to eql({"1" => 2, "3" => 1})
    end

    it "can return total number of all added tasks" do
      cart = Cart.new({"1" => 1})

      cart.add_task(1)
      cart.add_task(3)

      expect(cart.total).to eql(3)
    end
  end
end
