shared_examples 'user is not logged in' do
  it 'returns unauthorized code' do
    expect(response).to be_unauthorized
  end
end
