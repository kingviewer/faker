module Utils
  module ReturnCodes
    SUCCESS = 'success'
    PERMISSION_DENIED = 'permission_denied'
    SYSTEM_BUSY = 'system_busy'
    INVALID_REQUEST = 'invalid_request'
    LOGIN_TO_OPERATE = 'login_to_operate'
    INVALID_PARAMS = 'invalid_params'
    USER_NOT_EXIST = 'user_not_exist'
    ERROR = 'error'

    class << self
      def success(data = nil)
        rs = {code: SUCCESS}
        rs[:data] = data if data
        rs
      end

      def permission_denied
        {code: PERMISSION_DENIED, msg: 'No permission to operate'}
      end

      def system_busy
        {code: SYSTEM_BUSY, msg: 'Network congestion, please try again later'}
      end

      def invalid_request
        {code: INVALID_REQUEST, msg: 'Invalid Request'}
      end

      def login_to_operate
        {code: LOGIN_TO_OPERATE, msg: 'You have not logged in or has expired. Please log in and try again'}
      end

      def invalid_params
        {code: INVALID_PARAMS, msg: 'Invalid or incorrect parameter'}
      end

      def user_not_exist
        {code: USER_NOT_EXIST, msg: 'Address not exist'}
      end

      def error(msg)
        {code: ERROR, msg: msg}
      end
    end
  end
end