shared_examples 'an unauthorised request' do
  it 'returns unauthorized code' do
    subject

    expect(response).to be_unauthorized
  end
end
