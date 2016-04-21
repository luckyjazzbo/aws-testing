describe 'SQS mocking' do
  let(:sqs)    { Aws::SQS::Client.new(stub_responses: true) }
  let(:poller) { Aws::SQS::QueuePoller.new('https://example.com', client: sqs) }

  it 'mocks successful sending of a message' do
    sqs.stub_responses(:send_message, { message_id: 'id1' })

    response = sqs.send_message(
      queue_url: 'https://example.com',
      message_body: 'hello'
    )

    expect(response.message_id).to eq 'id1'
  end

  it 'mocks receiving of a message' do
    sqs.stub_responses(:receive_message, [
      { messages: [
          { message_id: 'id1', receipt_handle: 'rh1', body: '321' },
        ]
      }
    ])

    poller.poll do |message|
      expect(message.body).to eq '321'
      throw :stop_polling
    end
  end
end
