const fetch = require('node-fetch')
const URL = require('url')
const querystring = require('querystring')

/**
 * @param {string} method
 * @param {string} host
 * @param {object} user
 * @param {string} path
 * @param {any} body
 * @param {object} queryObj
 * @param {object} opts
 * @returns {object} {body, status, headers}
 */
async function _fetchy(method, host, user, path, body = undefined, queryObj = null, opts = {}) {

  const {username, password} = user
  const headers = opts.headers || {}
  // set basic authorization
  headers['Authorization'] = `Basic ${Buffer.from(username + ":" + password).toString('base64')}`
  headers['Content-Type'] = 'application/json'

  let url = host + path

  if(queryObj) {
    url += `?${querystring(queryObj)}`
  }
  if(method == "GET") body = undefined
  if(body != null) {
    headers["Content-Type"] = "application/json"
  }
  console.log(url)
  const response = await fetch(url, Object.assign({
    method, headers, body: typeof body === 'object' ? JSON.stringify(body) : body
  }, opts))

  const contentType = response.headers.get("content-type")
  if(contentType && contentType.includes("application/json")) {
    const body = await response.json()
    return {body, status: response.status, headers: response.headers}
  } else {
    return {body: await response.text(), status: response.status, headers: response.headers}
  }
}

module.exports = (host, user) => ({
  get: _fetchy.bind(global, "GET", host, user),
  put: _fetchy.bind(global, "PUT", host, user),
  post: _fetchy.bind(global, "POST", host, user),
  del: _fetchy.bind(global, "DELETE", host, user)
})
