shared_examples 'a not found request' do
  it 'returns http not found code' do
    subject

    expect(response).to be_not_found
  end
end
