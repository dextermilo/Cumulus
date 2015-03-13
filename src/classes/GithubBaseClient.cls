/**
* @author Ryan Foster, Salesforce Foundation
* @date 2015
*
* @group Github
*
* @description Base Class for Github clients, a loose "interface" and
* starting point for creating new clients.
*/
global abstract class GithubBaseClient {
    global Github parent;
    global Github.BaseResponse lastResponse { get; set; }
    global String endpoint { get; set; }
    global Integer perPage { get; set; } { perPage = 30; }

    global Boolean hasFirst {
        get {
            return this.lastResponse != null && this.lastResponse.first != null;
        }
    }
    global Boolean hasLast {
        get {
            return this.lastResponse != null && this.lastResponse.last != null;
        }
    }
    global Boolean hasNext {
        get {
            return this.lastResponse != null && this.lastResponse.next != null;
        }
    }
    global Boolean hasPrev {
        get {
            return this.lastResponse != null && this.lastResponse.prev != null;
        }
    }

    global GithubBaseClient() {}

    global GithubBaseClient(Github parent, String endpoint) {
        this.parent = parent;
        this.endpoint = endpoint;
    }

    global Github.BaseResponse makeRequest(String ep, String method, String body) {
        String target = ep != null && ep != '' ? this.endpoint + '/' + ep : this.endpoint;
        if (ep != null && ep.startsWith('?')) {
            target = this.endpoint + ep;
        }
        String renamedBody = null;
        if (body != null) {
            renamedBody = Github.renameReservedBack(body);
        }
        this.lastResponse = this.parent.makeRequest(target, method, renamedBody);
        return this.lastResponse;
    }

    global Github.BaseResponse makeRequest(String method, String body) {
        return makeRequest(null, method, body);
    }

    global Github.BaseResponse makeRequest(Integer num) {
        return makeRequest(String.valueOf(num), 'GET', null);
    }

    global Github.BaseResponse makeRequest(String url) {
        this.lastResponse = this.parent.makeRequest(url);
        return this.lastResponse;
    }

    global Github.BaseResponse makeRequest() {
        return this.makeRequest('GET', null);
    }

    global void paginate(String url) {
        this.makeRequest(url);
    }

}