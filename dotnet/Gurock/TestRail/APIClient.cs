/**
 * TestRail API binding for .NET (API v2, available since TestRail 3.0)
 * Compatible with TestRail 3.0 and later
 *
 * Learn more:
 *
 * http://docs.gurock.com/testrail-api2/start
 * http://docs.gurock.com/testrail-api2/accessing
 *
 * Copyright Gurock Software GmbH. See license.md for details.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Gurock.TestRail
{
    public class APIClient
    {
        private string m_user;
        private string m_password;
        private string m_url;
        private static readonly HttpClient s_client = new HttpClient();

        public APIClient(string base_url)
        {
            if (!base_url.EndsWith("/"))
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
        public string User
        {
            get { return this.m_user; }
            set { this.m_user = value; }
        }

        /**
         * Get/Set Password
         *
         * Returns/sets the password used for authenticating the API requests.
         */
        public string Password
        {
            get { return this.m_password; }
            set { this.m_password = value; }
        }

        /**
         * Send Get
         *
         * Issues a GET request (read) against the API and returns the result
         * (as JSON object, i.e. JObject or JArray instance).
         * If 'get_attachment/:attachment_id', returns a string
         *
         * Arguments:
         *
         * uri                  The API method to call including parameters
         *                      (e.g. get_case/1)
         */
        public object SendGet(string uri, object filepath = null)
        {
            return SendRequest("GET", uri, filepath);
        }

        /**
         * Send POST
         *
         * Issues a POST request (write) against the API and returns the result
         * (as JSON object, i.e. JObject or JArray instance).
         *
         * Arguments:
         *
         * uri                  The API method to call including parameters
         *                      (e.g. add_case/1)
         * data                 The data to submit as part of the request (as
         *                      serializable object, e.g. a dictionary)
         *                      If adding an attachment, must be the path
         *                      to the file
         */
        public object SendPost(string uri, object data)
        {
            return SendRequest("POST", uri, data);
        }

        private object SendRequest(string method, string uri, object data)
        {
            string url = this.m_url + uri;

            // Create the request object and set the required HTTP method
            // (GET/POST) and headers (basic auth).
            using (HttpRequestMessage request = new HttpRequestMessage(new HttpMethod(method), url))
            {
                string auth = Convert.ToBase64String(
                    Encoding.ASCII.GetBytes(
                        String.Format(
                            "{0}:{1}",
                            this.m_user,
                            this.m_password
                        )
                    )
                );

                request.Headers.Authorization = new AuthenticationHeaderValue("Basic", auth);

                if (method == "POST")
                {
                    if (uri.StartsWith("add_attachment"))   // add_attachment API requests
                    {
                        string filePath = (String)data;

                        MultipartFormDataContent form = new MultipartFormDataContent();
                        ByteArrayContent file = new ByteArrayContent(File.ReadAllBytes(filePath));
                        file.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                        form.Add(file, "attachment", Path.GetFileName(filePath));
                        request.Content = form;
                    }
                    // For non-attachment requests, add the POST arguments, if any.
                    // We just serialize the passed data object (i.e. a dictionary)
                    // and then add it to the request body.
                    else if (data != null)
                    {
                        request.Content = new StringContent(
                            JsonConvert.SerializeObject(data),
                            Encoding.UTF8,
                            "application/json"
                        );
                    }
                }

                // Execute the actual web request (GET or POST).
                using (HttpResponseMessage response = s_client.SendAsync(request).GetAwaiter().GetResult())
                {
                    int statusCode = (int)response.StatusCode;

                    // If 'get_attachment' (but not 'get_attachments') returned valid status code, save the file
                    if ((statusCode == 200) && (uri.StartsWith("get_attachment/")))
                    {
                        try
                        {
                            File.WriteAllBytes(
                                (String)data,
                                response.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult()
                            );
                            return (String)data;
                        }
                        catch (Exception)
                        {
                            throw new APIException("Unable to save attachment.");
                        }
                    }

                    // Read the response body, if any, and deserialize it from JSON.
                    string text = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                    JContainer result;
                    if (text != "")
                    {
                        if (text.StartsWith("["))
                        {
                            result = JArray.Parse(text);
                        }
                        else
                        {
                            try
                            {
                                result = JObject.Parse(text);
                            }
                            catch   // Response is not in JSON format
                            {
                                throw new APIException(String.Format(
                                    "TestRail API returned the following: {0}\n",
                                    text));
                            }
                        }
                    }
                    else
                    {
                        result = new JObject();
                    }

                    // Check for any occurred errors and add additional details to
                    // the exception message, if any (e.g. the error message returned
                    // by TestRail).
                    if (!response.IsSuccessStatusCode)
                    {
                        string error = (result as JObject) != null ? (string)result["error"] : null;
                        if (error != null)
                        {
                            error = '"' + error + '"';
                        }
                        else
                        {
                            error = "No additional error message received";
                        }

                        throw new APIException(
                            String.Format(
                                "TestRail API returned HTTP {0} ({1})",
                                statusCode,
                                error
                            )
                        );
                    }

                    return result;
                }
            }
        }
    }
}
