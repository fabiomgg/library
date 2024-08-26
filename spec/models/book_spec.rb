require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:borrowings).dependent(:destroy) }
  end
end
