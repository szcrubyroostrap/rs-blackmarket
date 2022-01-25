shared_examples 'response successful' do
  it 'returns http success code' do
    expect(response).to be_successful
  end
end
