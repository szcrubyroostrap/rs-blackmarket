shared_examples 'a successful request' do
  it 'returns http success code' do
    subject

    expect(response).to be_successful
  end
end
