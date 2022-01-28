shared_examples 'a successful request' do
  it 'returns http success code' do
    expect(response).to be_successful
  end
end
