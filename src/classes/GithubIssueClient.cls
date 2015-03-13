/**
* @author Ryan Foster, Salesforce Foundation
* @date 2015
*
* @group Github
*
* @description Client for Issues.
*
* Use from an instance of the base `Github` class:
*
* Github git = new Client(repo, xxx-auth-token);
*
* Retrieve the first 30 Issues:
* git.issues.get();
*
* Check if there are more Issues:
* if (git.issues.hasNext) {}
*
* Get the next 30 Milestones:
* git.issues.next();
*
* Check if there is a previous page of Issues:
* if (git.issues.hasPrev) {}
*
* Get the previous 30 Issues:
* git.issues.prev();
*
* Get all Issues:
* git.issues.all();
*
* Get a single Issue by issue num (Github id):
* git.issues.get(1);
*
* Create a new Issue:
* git.issues.create(issue);
*
* Update an Issue that has a valid `num` (Github id):
* git.issues.put(issue);
*
* Delete an Issue that has a valid `num` (Github id):
* git.issues.remove(issue);
*
*/
global class GithubIssueClient extends GithubBaseClient {

    global GithubIssueClient(Github parent, String endpoint) {
        this.parent = parent;
        this.endpoint = endpoint;
    }

    /**
    * @param filter string  Indicates which sorts of issues to return. Can be one of:
    *   - assigned: Issues assigned to you
    *   - created: Issues created by you
    *   - mentioned: Issues mentioning you
    *   - subscribed: Issues you’re subscribed to updates for
    *   - all: All issues the authenticated user can see, regardless of participation or creation
    *   - Default: all
    * @param state   string  Indicates the state of the issues to return. Can be either open, closed, or all. Default: open
    * @param labels  string  A list of comma separated label names. Example: bug,ui,@high
    * @param sort    string  What to sort results by. Can be either created, updated, comments. Default: created
    * @param direction   string  The direction of the sort. Can be either asc or desc. Default: desc
    * @param since   string  Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    **/
    global List<Github.Issue> get(String filter, String state, String labels,
            String sortBy, String direction, String since, Integer perPage) {

        String query = Github.buildQueryString(new Map<String, String>{
            'filter' => filter,
            'state' => state,
            'labels' => labels,
            'sort' => sortBy,
            'direction' => direction,
            'since' => since,
            'per_page' => perPage != null ? String.valueOf(perPage) : null
        });
        this.makeRequest(query, 'GET', null);
        return (List<Github.Issue>) JSON.deserialize(this.lastResponse.body, List<Github.Issue>.class);
    }

    global List<Github.Issue> get() {
        return this.get('all', null, null, null, null, null, null);
    }

    global Github.Issue get(Integer num) {
        System.assert(num != null, 'Issue number is required to get a Issue.');
        this.makeRequest(num);
        return (Github.Issue) JSON.deserialize(this.lastResponse.body, Github.Issue.class);
    }

    global Github.Issue create(Github.Issue issue) {
        this.makeRequest('POST', JSON.serialize(issue));
        return (Github.Issue) JSON.deserialize(this.lastResponse.body, Github.Issue.class);
    }

    global Github.Issue put(Github.Issue issue) {
        this.makeRequest(String.valueOf(issue.num), 'PATCH', JSON.serialize(issue));
        return (Github.Issue) JSON.deserialize(this.lastResponse.body, Github.Issue.class);
    }

    global void remove(Github.Issue issue) {
        this.makeRequest(String.valueOf(issue.num), 'DELETE', null);
    }

    global List<Github.Issue> next() {
        super.paginate(this.lastResponse.next);
        return (List<Github.Issue>) JSON.deserialize(this.lastResponse.body, List<Github.Issue>.class);
    }

    global List<Github.Issue> prev() {
        super.paginate(this.lastResponse.prev);
        return (List<Github.Issue>) JSON.deserialize(this.lastResponse.body, List<Github.Issue>.class);
    }

    global List<Github.Issue> last() {
        super.paginate(this.lastResponse.last);
        return (List<Github.Issue>) JSON.deserialize(this.lastResponse.body, List<Github.Issue>.class);
    }

    global List<Github.Issue> first() {
        super.paginate(this.lastResponse.first);
        return (List<Github.Issue>) JSON.deserialize(this.lastResponse.body, List<Github.Issue>.class);
    }

    global List<Github.Issue> all() {
        List<Github.Issue> issues = this.get('all', 'all', null, null, null, null, 100);
        while (this.hasNext) {
            issues.addAll(this.next());
        }
        return issues;
    }
}