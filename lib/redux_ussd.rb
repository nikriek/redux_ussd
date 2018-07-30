# frozen_string_literal: true

require 'redux_ussd/version'
require 'redux_ussd/menu'
require 'redux_ussd/store'

# Makes the menu DSL accessible to a class
module ReduxUssd
  def setup_menu(state = nil)
    @menu ||= begin
      new_state = state || initial_state
      ReduxUssd::Menu.new(new_state).tap do |menu|
        Menu::Proxy.new(menu).instance_eval(&self.class.menu)
      end
    end
  end

  def menu
    @menu
  end

  def self.included(klass)
    klass.extend ClassMethods
  end

  private

  # Holds a class-level definition of the menu DSL
  module ClassMethods
    def menu(&block)
      @menu_block ||= block
    end
  end

  def initial_state
    {
      navigation: {
        current_screen: :index,
        routes: {}
      },
      prompt: {}
    }
  end
end
