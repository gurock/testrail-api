const fetchyWrap = require('./request')

class TestRail {
  /**
   *
   * @param {string} host base host
   * @param {object} user user name and password
   * @param {string} user.username testrail username
   * @param {string} user.password testrail user password
   */
  constructor(host, user) {
    console.log(host)
    this.fetchy = fetchyWrap(host, user)
  }

  async getCase(id) {
    const {body} = await this.fetchy.get(`get_case/${id}`)
    return body
  }

  async getCases(projectId, filters) {
    const {body} = await this.fetchy.get(`get_cases/${projectId}`, null, filters)
    return body
  }

  async addCase(sectionId, caseData) {
    const {body} = this.fetchy.post(`add_case/${sectionId}`, caseData)
    return body
  }

  async updateCase(caseId, caseData) {
    const {body} = this.fetchy.post(`update_case/${caseId}`, caseData)
    return body
  }

  async deleteCase(caseId) {
    const {body} = this.fetchy.post(`delete_case/${caseId}`)
    return body
  }

  async getCaseFields() {
    const {body} = this.fetchy.get('get_case_fields')
    return body
  }

  async getCaseTypes() {
    const {body} = this.fetchy.get('get_case_types')
    return body
  }


  async getMilestone(id) {
    const {body} = await this.fetchy.get(`get_milestone/${id}`)
    return body
  }

  async getMilestones(projectId, filters) {
    const {body} = await this.fetchy.get(`get_milestones/${projectId}`, null, filters)
    return body
  }

  async addMilestone(projectId, data) {
    const {body} = await this.fetchy.post(`add_milestone/${projectId}`, data)
    return body
  }

  async updateMilestone(milestoneId, data) {
    const {body} = await this.fetchy.post(`update_milestone/${milestoneId}`, data)
    return body
  }

  async deleteMilestone(milestoneId) {
    const {body} = await this.fetchy.post(`delete_milestone/${milestoneId}`)
    return body
  }

  async getPlan(id) {
    const {body} = await this.fetchy.get(`get_plan/${id}`)
    return body
  }

  async getPlans(projectId, filters) {
    const {body} = await this.fetchy.get(`get_plans/${projectId}`, null, filters)
    return body
  }

  async addPlan(projectId, data) {
    const {body} = await this.fetchy.post(`add_plan/${projectId}`, data)
    return body
  }

  async addPlanEntry(planId, data) {
    const {body} = await this.fetchy.post(`add_plan_entry/${planId}`, data)
    return body
  }

  async updatePlan(planId, data) {
    const {body} = await this.fetchy.post(`update_plan/${planId}`, data)
    return body
  }

  async updatePlanEntry(planId, entry_id, data) {
    const {body} = await this.fetchy.post(`update_plan_entry/${planId}/${entry_id}`, data)
    return body
  }

  async closePlan(planId) {
    const {body} = await this.fetchy.post(`close_plan/${planId}`)
    return body
  }

  async deletePlan(planId) {
    const {body} = await this.fetchy.post(`delete_plan/${planId}`)
    return body
  }

  async deletePlanEntry(planId, entry_id) {
    const {body} = await this.fetchy.post(`delete_plan_entry/${planId}/${entry_id}`)
    return body
  }

  async getPriorities() {
    const {body} = await this.fetchy.get('get_priorities')
    return body
  }

  async getProject(projectId) {
    const {body} = await this.fetchy.get(`get_project/${projectId}`)
    return body
  }

  async getProjects(filters) {
    const {body} = await this.fetchy.get('get_projects', null, filters)
    return body
  }

  async addProject(data) {
    const {body} = await this.fetchy.post('add_project', data)
    return body
  }

  async updateProject(projectId, data) {
    const {body} = await this.fetchy.post(`update_project/${projectId}`, data)
    return body
  }

  async deleteProject(projectId) {
    const {body} = await this.fetchy.post(`delete_project/${projectId}`)
    return body
  }

  async getResults(testId, filters) {
    const {body} = await this.fetchy.get(`get_results/${testId}`, body, filters)
    return body
  }

  async getResultsForCase(runId, caseId, filters) {
    const {body} = await this.fetchy.get(`get_results_for_case/${runId}/${caseId}`, null, filters)
    return body
  }

  async getResultsForRun(runId, filters) {
    const {body} = await this.fetchy.get(`get_results_for_run/${runId}`, null, filters)
    return body
  }

  async addResult(testId, data) {
    const {body} = await this.fetchy.post(`add_result/${testId}`, data)
    return body
  }

  async addResultForCase(runId, caseId, data) {
    const {body} = await this.fetchy.post(`add_result_for_case/${runId}/${caseId}`, data)
  }

  async addResults(runId, data) {
    const {body} = await this.fetchy.post(`add_results/${runId}`, {results: data})
  }

  async addResultsForCases(runId, data) {
    const {body} = await this.fetchy.post(`add_results_for_cases/${runId}`, {results: data})
    return body
  }

  async getResultFields() {
    const {body} = await this.fetchy.get('get_result_fields')
    return body
  }


  async getRun(runId) {
    const {body} = await this.fetchy.get(`get_run/${runId}`)
    return body
  }

  async getRuns(projectId, filters) {
    const {body} = await this.fetchy.get(`get_runs/${projectId}`, null, filters)
    return body
  }

  async addRun(projectId, data) {
    const {body} = await this.fetchy.post(`add_run/${projectId}`, data)
    return body
  }

  async updateRun(runId, data) {
    const {body} = await this.fetchy.post(`update_run/${runId}`, data)
    return body
  }

  async closeRun(runId) {
    const {body} = await this.fetchy.post(`close_run/${runId}`)
    return body
  }

  async deleteRun(runId) {
    const {body} = await this.fetchy.post(`delete_run/${runId}`)
    return body
  }

  async getSection(sectionId) {
    const {body} = await this.fetchy.get(`get_section/${sectionId}`)
    return body
  }

  async getSections(projectId, filters) {
    const {body} = await this.fetchy.get(`get_sections/${projectId}`, null, filters)
    return body
  }

  async addSection(projectId, data) {
    const {body} = await this.fetchy.post(`add_section/${projectId}`, data)
    return body
  }

  async updateSection(sectionId, data) {
    const {body} = await this.fetchy.post(`update_section/${sectionId}`, data)
    return body
  }

  async deleteSection(sectionId) {
    const {body} = await this.fetchy.post(`delete_section/${sectionId}`)
    return body
  }

  async getStatuses() {
    const {body} = await this.fetchy.get('get_statuses')
    return body
  }


  async getSuite(suiteId) {
    const {body} = await this.fetchy.get(`get_suite/${suiteId}`)
    return body
  }

  async getSuites(projectId) {
    const {body} = await this.fetchy.get(`get_suites/${projectId}`)
    return body
  }

  async addSuite(projectId, data) {
    const {body} = await this.fetchy.post(`add_suite/${projectId}`, data)
    return body
  }

  async updateSuite(suiteId, data) {
    const {body} = await this.fetchy.post(`update_suite/${suiteId}`, data)
    return body
  }

  async deleteSuite(suiteId) {
    const {body} = await this.fetchy.post(`delete_suite/${suiteId}`)
    return body
  }


  async getTemplates(projectId) {
    const {body} = await this.fetchy.get(`get_templates/${projectId}`)
    return body
  }

  async getTest(testId) {
    const {body} = await this.fetchy.get(`get_test/${testId}`)
    return body
  }

  async getTests(runId, filters) {
    const {body} = await this.fetchy.get(`get_tests/${runId}`, null, filters)
    return body
  }

  async getUser(userId) {
    const {body} = await this.fetchy.get(`get_user/${userId}`)
    return body
  }

  async getUserByEmail(email) {
    const {body} = await this.fetchy.get('get_user_by_email', null, {email})
    return body
  }

  async getUsers() {
    const {body} = await this.fetchy.get('get_users')
    return body
  }
}

module.exports = {
  TestRail
}
