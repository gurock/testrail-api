#
# TestRail API binding for Java (API v2, available since TestRail 3.0)
#  Updated for TestRail 5.7
#
# Learn more:
#
# http://docs.gurock.com/testrail-api2/start
# http://docs.gurock.com/testrail-api2/accessing
#
# Copyright Gurock Software GmbH. See license.md for details.
#

require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module TestRail
	class APIClient
		@url = ''
		@user = ''
		@password = ''

		attr_accessor :user
		attr_accessor :password

		def initialize(base_url)
			if !base_url.match(/\/$/)
				base_url += '/'
			end
			@url = base_url + 'index.php?/api/v2/'
		end

		#
		# Send Get
		#
		# Issues a GET request (read) against the API and returns the result
		# (as Ruby hash).
		# If 'get_attachment/{id}' is successful, returns the data parameter
		#
		# Arguments:
		#
		# uri                 The API method to call including parameters
		#                     (e.g. get_case/1)
		# data                When using get_attachment/{id}, this should be
		#                     the file path (including filename) where the 
		#                     attachment should be saved
		#
		def send_get(uri, data=nil) 
			_send_request('GET', uri, data)
		end

		#
		# Send POST
		#
		# Issues a POST request (write) against the API and returns the result
		# (as Ruby hash).
		#
		# Arguments:
		#
		# uri                 The API method to call including parameters
		#                     (e.g. add_case/1)
		# data                The data to submit as part of the request (as
		#                     Ruby hash, strings must be UTF-8 encoded)
		#                     If adding an attachment, should be the path
		#                     to the file
		#
		def send_post(uri, data)
			_send_request('POST', uri, data)
		end

		private
		def _send_request(method, uri, data)
			url = URI.parse(@url + uri)
			if method == 'POST'
				request = Net::HTTP::Post.new(url.path + '?' + url.query)
					if uri.start_with?('add_attachment')
						# SOURCE: https://yukimotopress.github.io/http
						boundary = "TestRailAPIAttachmentBoundary"
						post_body = []
						post_body << "--#{boundary}\r\n"
						post_body << "Content-Disposition: form-data; name=\"attachment\"; filename=\"#{File.basename(data)}\"\r\n"
						post_body << "\r\n"
						post_body << File.open(data, 'rb') {|io| io.read}
						post_body << "\r\n--#{boundary}--\r\n"
						
						request.body = post_body.join
						request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
					else
						request["Content-Type"] = "application/json"
						request.body = JSON.dump(data)
					end
			else
				request = Net::HTTP::Get.new(url.path + '?' + url.query)
				request["Content-Type"] = "application/json"
				request["x-api-ident"] = "beta"
			end
			request.basic_auth(@user, @password)

			conn = Net::HTTP.new(url.host, url.port)
			if url.scheme == 'https'
				conn.use_ssl = true
				conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
			response = conn.request(request)

			if response.body && !response.body.empty? && (response.code == '200')
				if uri.start_with?('get_attachment/')
					File.open(data, 'w') { |file| file.write(response.body) }
					result = data
				else
					result = JSON.parse(response.body)
				end
			else
				result = {}
			end

			if response.code != '200'
				if result && result.key?('error')
					error = '"' + result['error'] + '"'
				else
					error = 'No additional error message received'
				end
				raise APIError.new('TestRail API returned HTTP %s (%s)' %
					[response.code, error])
			end
			
			result
		end
	end

	class APIError < StandardError
	end
end
