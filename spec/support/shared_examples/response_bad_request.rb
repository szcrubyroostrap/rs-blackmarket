shared_examples 'response bad_request' do
  it 'returns http bad request code' do
    expect(response).to be_bad_request
  end
end
