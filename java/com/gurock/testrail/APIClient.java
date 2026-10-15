/**
 * TestRail API binding for Java (API v2, available since TestRail 3.0)
 * Updated for TestRail 5.7
 * Requires Java 11 or later
 *
 * Learn more:
 *
 * http://docs.gurock.com/testrail-api2/start
 * http://docs.gurock.com/testrail-api2/accessing
 *
 * Copyright Gurock Software GmbH. See license.md for details.
 */
 
package com.gurock.testrail;

import java.net.URI;
import java.net.MalformedURLException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;


public class APIClient
{
	private String m_user;
	private String m_password;
	private String m_url;
	private final HttpClient m_client = HttpClient.newBuilder()
		.followRedirects(HttpClient.Redirect.NORMAL)
		.build();

	public APIClient(String base_url)
	{
		if (!base_url.endsWith("/"))
		{
			base_url += "/";
		}
		
		this.m_url = base_url + "index.php?/api/v2/";
	}

	/**
	 * Get/Set User
	 *
	 * Returns/sets the user used for authenticating the API requests.
	 */
	public String getUser()
	{
		return this.m_user;
	}

	public void setUser(String user)
	{
		this.m_user = user;
	}

	/**
	 * Get/Set Password
	 *
	 * Returns/sets the password used for authenticating the API requests.
	 */
	public String getPassword()
	{
		return this.m_password;
	}

	public void setPassword(String password)
	{
		this.m_password = password;
	}

	/**
	 * Send Get
	 *
	 * Issues a GET request (read) against the API and returns the result
	 * (as Object, see below).
	 *
	 * Arguments:
	 *
	 * uri                  The API method to call including parameters
	 *                      (e.g. get_case/1)
	 *
	 * Returns the parsed JSON response as standard object which can
	 * either be an instance of JSONObject or JSONArray (depending on the
	 * API method). In most cases, this returns a JSONObject instance which
	 * is basically the same as java.util.Map.
	 * 
	 * If 'get_attachment/:attachment_id', returns a String
	 */
	public Object sendGet(String uri, String data)
		throws MalformedURLException, IOException, APIException
	{
		return this.sendRequest("GET", uri, data);
	}
	
	public Object sendGet(String uri)
			throws MalformedURLException, IOException, APIException
	{
		return this.sendRequest("GET", uri, null);
	}

	/**
	 * Send POST
	 *
	 * Issues a POST request (write) against the API and returns the result
	 * (as Object, see below).
	 *
	 * Arguments:
	 *
	 * uri                  The API method to call including parameters
	 *                      (e.g. add_case/1)
	 * data                 The data to submit as part of the request (e.g.,
	 *                      a map)
	 *                      If adding an attachment, must be the path
	 *                      to the file
	 *
	 * Returns the parsed JSON response as standard object which can
	 * either be an instance of JSONObject or JSONArray (depending on the
	 * API method). In most cases, this returns a JSONObject instance which
	 * is basically the same as java.util.Map.
	 */
	public Object sendPost(String uri, Object data)
		throws MalformedURLException, IOException, APIException
	{
		return this.sendRequest("POST", uri, data);
	}
	
	private Object sendRequest(String method, String uri, Object data)
		throws MalformedURLException, IOException, APIException
	{
		HttpRequest.Builder builder = HttpRequest.newBuilder()
			.uri(URI.create(this.m_url + uri))
			.header("Authorization", "Basic " + getAuthorization(this.m_user, this.m_password));

		if (method.equals("POST"))
		{
			// Add the POST arguments, if any. We just serialize the passed
			// data object (i.e. a dictionary) and then add it to the
			// request body.
			if (data != null && uri.startsWith("add_attachment"))   // add_attachment API requests
			{
				String boundary = "TestRailAPIAttachmentBoundary"; //Can be any random string
				File uploadFile = new File((String)data);

				ByteArrayOutputStream body = new ByteArrayOutputStream();
				body.write(("--" + boundary + "\r\n").getBytes("UTF-8"));
				body.write(("Content-Disposition: form-data; name=\"attachment\"; filename=\""
					+ uploadFile.getName() + "\"\r\n\r\n").getBytes("UTF-8"));
				body.write(Files.readAllBytes(uploadFile.toPath()));
				body.write(("\r\n--" + boundary + "--\r\n").getBytes("UTF-8"));

				builder.header("Content-Type", "multipart/form-data; boundary=" + boundary);
				builder.POST(HttpRequest.BodyPublishers.ofByteArray(body.toByteArray()));
			}
			else if (data != null)	// Not an attachment
			{
				builder.header("Content-Type", "application/json");
				builder.POST(HttpRequest.BodyPublishers.ofByteArray(
					JSONValue.toJSONString(data).getBytes("UTF-8")));
			}
			else
			{
				builder.POST(HttpRequest.BodyPublishers.noBody());
			}
		}
		else	// GET request
		{
			builder.header("Content-Type", "application/json");
			builder.GET();
		}

		// Execute the actual web request and record any occurred errors.
		HttpResponse<byte[]> response;
		try
		{
			response = this.m_client.send(builder.build(), HttpResponse.BodyHandlers.ofByteArray());
		}
		catch (InterruptedException e)
		{
			Thread.currentThread().interrupt();
			throw new IOException("Request interrupted", e);
		}

		int status = response.statusCode();
		byte[] responseBody = response.body();

		// If 'get_attachment' (not 'get_attachments') returned valid status code, save the file
		if ((status == 200) && (uri.startsWith("get_attachment/")))
		{
			Files.write(Paths.get((String)data), responseBody);
			return (String) data;
		}

		if (status != 200 && responseBody.length == 0)
		{
			throw new APIException(
				"TestRail API return HTTP " + status +
				" (No additional error message received)"
			);
		}

		// Read the response body, if any, and deserialize it from JSON.
		String text = new String(responseBody, "UTF-8");

		Object result;
		if (!text.equals(""))
		{
			result = JSONValue.parse(text);
		}
		else
		{
			result = new JSONObject();
		}

		// Check for any occurred errors and add additional details to
		// the exception message, if any (e.g. the error message returned
		// by TestRail).
		if (status != 200)
		{
			String error = "No additional error message received";
			if (result != null && result instanceof JSONObject)
			{
				JSONObject obj = (JSONObject) result;
				if (obj.containsKey("error"))
				{
					error = '"' + (String) obj.get("error") + '"';
				}
			}

			throw new APIException(
				"TestRail API returned HTTP " + status +
				" (" + error + ")"
			);
		}

		return result;
	}

	private static String getAuthorization(String user, String password)
	{
		try 
		{
			return new String(Base64.getEncoder().encode((user + ":" + password).getBytes()));
		}
		catch (IllegalArgumentException e)
		{
			// Not thrown
		}
		
		return "";
	}
}
