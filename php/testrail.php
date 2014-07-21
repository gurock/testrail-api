<?php

/**
 * TestRail API binding for PHP (API v2, available since TestRail 3.0)
 *
 * Learn more:
 *
 * http://docs.gurock.com/testrail-api2/start
 * http://docs.gurock.com/testrail-api2/accessing
 *
 * Copyright Gurock Software GmbH. See license.md for details.
 */

class TestRailAPIClient
{
	private $_user;
	private $_password;
	private $_url;

	public function __construct($base_url)
	{
		$base_url = trim($base_url, '/') . '/';
		$this->_url = $base_url . 'index.php?/api/v2/';
	}

	/**
	 * Get/Set User
	 *
	 * Returns/sets the user used for authenticating the API requests.
	 */
	public function get_user()
	{
		return $this->_user;
	}

	public function set_user($user)
	{
		$this->_user = $user;
	}

	/**
	 * Get/Set Password
	 *
	 * Returns/sets the password used for authenticating the API requests.
	 */
	public function get_password()
	{
		return $this->_password;
	}

	public function set_password($password)
	{
		$this->_password = $password;
	}

	/**
	 * Send Get
	 *
	 * Issues a GET request (read) against the API and returns the result
	 * (as PHP array).
	 *
	 * Arguments:
	 *
	 * $uri                 The API method to call including parameters
	 *                      (e.g. get_case/1)
	 */
	public function send_get($uri)
	{
		return $this->_send_request('GET', $uri, null);
	}

	/**
	 * Send POST
	 *
	 * Issues a POST request (write) against the API and returns the result
	 * (as PHP array).
	 *
	 * Arguments:
	 *
	 * $uri                 The API method to call including parameters
	 *                      (e.g. add_case/1)
	 * $data                The data to submit as part of the request (as
	 *                      PHP array, strings must be UTF-8 encoded)
	 */
	public function send_post($uri, $data)
	{
		return $this->_send_request('POST', $uri, $data);
	}

	protected function _create_handle()
	{
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
		return $ch;
	}

	protected function _send_request($method, $uri, $data)
	{
		$ch = $this->_create_handle();
		curl_setopt($ch, CURLOPT_URL, $this->_url . $uri);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

		if ($method == 'POST')
		{
			if (is_array($data))
			{
				$data_str = json_encode($data);
			}
			else 
			{
				$data_str = '';
			}

			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data_str);
		}
		else 
		{
			curl_setopt($ch, CURLOPT_POST, false);
		}

		curl_setopt(
			$ch,
			CURLOPT_HTTPHEADER,
			array(
				'Expect: ', 
				'Content-Type: application/json'
			)
		);

		curl_setopt($ch, CURLOPT_USERPWD, "$this->_user:$this->_password");
		$response = curl_exec($ch);
		if ($response === false)
		{
			throw new TestRailAPIException(curl_error($ch));
		}

		if ($response)
		{
			$result = json_decode($response, true); // As array
		}
		else 
		{
			$result = array();
		}

		$info = curl_getinfo($ch);
		if ($info['http_code'] != 200)
		{
			throw new TestRailAPIException(
				sprintf(
					'TestRail API returned HTTP %s (%s)',
					$info['http_code'],
					isset($result['error']) ? 
						'"' . $result['error'] . '"' : 
						'No additional error message received'
				)
			);
		}

		$this->_close_handle($ch);
		return $result;
	}

	protected function _close_handle($ch)
	{
		curl_close($ch);
	}
}

class TestRailAPIException extends Exception
{
}
