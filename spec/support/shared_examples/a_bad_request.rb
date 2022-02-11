shared_examples 'a bad request' do
  it 'returns http bad request code' do
    subject

    expect(response).to be_bad_request
  end
end
