require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:borrowings) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role).with_values(member: 0, librarian: 1) }
  end
end
