using System;
using System.Net;
using System.IO;
using System.Text;

namespace Gurock.TestRail
{
	public class APIClient
	{
		private string m_user;
		private string m_password;
		private string m_url;

		public APIClient(string base_url)
		{
			if (!base_url.EndsWith("/"))
			{
				base_url += "/";
			}

			this.m_url = base_url + "index.php?/api/v2/";
		}

		public string User
		{
			get { return this.m_user; }
			set { this.m_user = value; }
		}

		public string Password
		{
			get { return this.m_password; }
			set { this.m_password = value; }
		}

		public string SendGet(string uri)
		{
			return SendRequest("GET", uri);
		}

		public string SendPost(string uri)
		{
			return SendRequest("POST", uri);
		}

		private string SendRequest(string method, string uri)
		{
			string url = this.m_url + uri;
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
			request.ContentType = "application/json";
			request.Method = method;

			string auth = Convert.ToBase64String(
				Encoding.ASCII.GetBytes(
					String.Format(
						"{0}:{1}",
						this.m_user,
						this.m_password
					)
				)
			);

			request.Headers.Add("Authorization", "Basic " + auth);

			string text = "";
			HttpWebResponse response = (HttpWebResponse)request.GetResponse();
			using (StreamReader reader = new StreamReader(response.GetResponseStream()))
			{
				text = reader.ReadToEnd();
			}

			return text; 
		}
	}
}
