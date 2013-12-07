describe MALRequester do
  it 'should have a default base url and user agent header' do
    request = stub_request(:any, 'http://myanimelist.net/')
      .with(headers: { 'User-Agent' => 'test-api-key' })

    MALRequester.get('/')
    request.should have_been_requested
  end
end