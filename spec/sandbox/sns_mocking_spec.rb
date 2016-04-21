describe 'SNS mocking' do
  let(:sns) { Aws::SNS::Client.new(stub_responses: true) }

  it 'mocks successful sending of a message' do
    sns.stub_responses(:publish, { message_id: 'id1' })

    response = sns.publish(
      topic_arn: 'topicARN',
      message: 'hello'
    )

    expect(response.message_id).to eq 'id1'
  end
end
