module Iterable
  ##
  #
  # Interact with /push API endpoints
  #
  # @example Creating push endpoint object
  #   # With default config
  #   templates = Iterable::Push.new
  #   templates.get
  #
  #   # With custom config
  #   conf = Iterable::Config.new(token: 'new-token')
  #   templates = Iterable::Push.new(config)
  class Push < ApiResource
    ##
    #
    # Target a user with a push notification.
    #
    # @param campaign_id [Integer] ID of the push campaign to trigger
    # @param attrs [Hash] Hash of attributes to pass like dataFields with the request
    # @option attrs [String] :recipientEmail Either email or userId must be passed in to identify the user. If both are
    #   passed in, email takes precedence.
    # @option attrs [String] :recpientUserId UserId that was passed into the updateUser call
    # @option attrs [Hash] :dataFields Hash object containing fields to merge into email template
    # @option attrs [Time] :sendAt Schedule the message for up to 365 days in the future. If set in the past, message
    #   is sent immediately.
    # @option attrs [Boolean] :allowRepeatMarketingSends Allow repeat marketing sends? Defaults to true.
    # @option attrs [String] :metadata Metadata to pass back via system webhooks. Not used for rendering
    #
    # @return [Iterable::Response] A response object
    def target(campaign_id, attrs = {})
      if attrs[:recipientEmail].nil? && attrs[:recipientUserId].nil?
        raise ArgumentError, 'missing recipientEmail or recipientUserId'
      end

      attrs[:campaignId] = campaign_id
      attrs[:sendAt] = attrs[:sendAt].utc.strftime('%F %T') if attrs[:sendAt].respond_to?(:utc)

      Iterable.request(conf, '/push/target').post(attrs)
    end
  end
end
