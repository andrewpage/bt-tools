require 'spec_helper'

describe Tools do
  it 'should implement the `create` method' do
    expect(Tools).to respond_to(:create)
  end

  it 'should implement the `transcode` method' do
    expect(Tools).to respond_to(:transcode)
  end
end
