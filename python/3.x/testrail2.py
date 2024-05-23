"""Modified TestRail API binding for Python 3.x. without external dependencies.

This version provides the same interface as `testrail.py`, but without the `requests` module.

Diff from `testrail.py`:
    - Added a user agent, so it won't fail at some server configurations
    - Removed the `requests` package and replaced it with `urllib` from the standard library

Modified by worstprgr (adam@seishin.io - PGP: key.seishin.io) - not affiliated with Gurock Software GmbH
"""
from urllib import request
from http import client  # for type hints
import random
import string
import base64
import json


class APIClient:
    def __init__(self, base_url: str, ua: bool = False):
        """
        A simplified interface for TestRail.
        :param base_url: The URL of the TestRail server
        :param ua: Add a user agent to the header (Optional, Default: False)
        """
        self.user: str = ''
        self.password: str = ''
        if not base_url.endswith('/'): base_url += '/'
        self.__url: str = base_url + 'index.php?/api/v2/'
        self.ua = ua
        self.user_agent: str = 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:109.0) Gecko/20100101 Firefox/119.0'

    def send_get(self, uri: str, filepath=None):
        """Issue a GET request (read) against the API.

        Args:
            uri: The API method to call including parameters, e.g. get_case/1.
            filepath: The path and file name for attachment download; used only
                for 'get_attachment/:attachment_id'.

        Returns:
            A dict containing the result of the request.
        """
        return self.__send_request('GET', uri, filepath)

    def send_post(self, uri: str, data: any):
        """Issue a POST request (write) against the API.

        Args:
            uri: The API method to call, including parameters, e.g. add_case/1.
            data: The data to submit as part of the request as a dict; strings
                must be UTF-8 encoded. If adding an attachment, must be the
                path to the file.

        Returns:
            A dict containing the result of the request.
        """
        return self.__send_request('POST', uri, data)

    def __send_request(self, method: str, uri: str, data: any) -> Exception | bytes | str | dict:
        req: request.Request
        response: client.HTTPResponse

        url: str = self.__url + uri
        auth: str = str(base64.b64encode(bytes(f'{self.user}:{self.password}', 'utf-8')), 'ascii').strip()

        auth_header: tuple = ('Authorization', f'Basic {auth}')
        agent_header: tuple = ('User-Agent', self.user_agent)
        con_type_json_header: tuple = ('Content-Type', 'application/json')

        if method == 'POST':
            if uri[:14] == 'add_attachment':  # add_attachment API method
                prep_data_payload: tuple = self.__upload_data_handler(data)

                data_header: tuple[str] = prep_data_payload[0]
                data_encoded: bytes = prep_data_payload[1]

                req = request.Request(url, data=data_encoded, method=method)
                req.add_header(*auth_header)
                self.__add_user_agent(req, agent_header)
                req.add_header(*data_header)
            else:
                payload = bytes(json.dumps(data), 'utf-8')

                req = request.Request(url, data=payload, method=method)
                req.add_header(*auth_header)
                self.__add_user_agent(req, agent_header)
                req.add_header(*con_type_json_header)
        else:
            req = request.Request(url, method=method)
            req.add_header(*auth_header)
            self.__add_user_agent(req, agent_header)
            req.add_header(*con_type_json_header)

        # Sending the request
        # Note: No need to close the connection explicitly,
        # urllib includes a "Connection:close" header in its HTTP requests
        response = request.urlopen(req)
        response_as_bytes: bytes = response.read()

        if response.status > 201:
            # Unsure which error should appear, if json content is found in the response
            # and the status code is > 201
            error: str = 'Some unknown error occurred'
            is_json: bool = self.__val_json(response_as_bytes)

            if not is_json:
                error = "Missing a valid JSON response."
            raise APIError(f'TestRail API returned HTTP {response.status} {error}')
        else:
            if uri[:15] == 'get_attachment/':  # Expecting file, not JSON
                try:
                    open(data, 'wb').write(response_as_bytes)
                    return data
                except:
                    return "Error saving attachment."
            else:
                try:
                    return json.loads(response_as_bytes)
                except:  # Nothing to return
                    return {}

    @staticmethod
    def __val_json(data: bytes) -> bool:
        """
        Parses a byte object. If it's json data, it returns `True`.
        """
        try:
            json.loads(data)
            return True
        except json.decoder.JSONDecodeError:
            return False

    def __add_user_agent(self, request_type: request.Request, ua_header: tuple) -> None:
        if self.ua:
            request_type.add_header(*ua_header)

    @staticmethod
    def __upload_data_handler(fp: str) -> tuple:
        """
        Urllib doesn't support the content type `multipart/form-data` natively.
        So it must be constructed separately.

        :param fp: The filepath or filename
        :return: A tuple, that contains a header for the request, and the encoded file.
        """

        def webkit_boundary_gen() -> str:
            """
            Generate random characters for the WebKitFormBoundary
            """
            rnd_ascii_letters_digits: list[str] = random.sample(string.ascii_letters + string.digits, 16)
            return '----WebKitFormBoundary' + ''.join(rnd_ascii_letters_digits)

        def get_file_name(fn: str) -> str:
            if '/' in fn:
                return fn.split('/')[-1]
            elif '\\' in fn:
                return fn.split('\\')[-1]
            else:
                return fn

        # Note: The key "attachment" is specific to TestRail
        files: dict = {'attachment': (get_file_name(fp), open(fp, 'rb'), 'text/plain')}

        boundary: str = webkit_boundary_gen()
        body: bytes = b''

        for key, (filename, file, content_type) in files.items():
            body += b'--' + boundary.encode() + b'\r\n'
            body += 'Content-Disposition: form-data; name="{0}"; filename="{1}"\r\n'.format(key, filename).encode()
            body += 'Content-Type: {0}\r\n\r\n'.format(content_type).encode()
            body += file.read() + b'\r\n'

        file_headers: tuple = ('Content-Type', 'multipart/form-data; boundary=' + boundary)
        body += b'--' + boundary.encode() + b'--\r\n'
        return file_headers, body


class APIError(Exception):
    pass
