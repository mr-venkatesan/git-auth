class BranchsAndCommitsListModel {
  List<Branch> branches;
  List<CommitElement> commits;

  BranchsAndCommitsListModel({
    required this.branches,
    required this.commits,
  });

  factory BranchsAndCommitsListModel.fromJson(Map<String, dynamic> json) => BranchsAndCommitsListModel(
    branches: List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
    commits: List<CommitElement>.from(json["commits"].map((x) => CommitElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
    "commits": List<dynamic>.from(commits.map((x) => x.toJson())),
  };
}

class Branch {
  String name;
  TreeClass commit;
  bool protected;
  Protection protection;
  String protectionUrl;

  Branch({
    required this.name,
    required this.commit,
    required this.protected,
    required this.protection,
    required this.protectionUrl,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    name: json["name"],
    commit: TreeClass.fromJson(json["commit"]),
    protected: json["protected"],
    protection: Protection.fromJson(json["protection"]),
    protectionUrl: json["protection_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "commit": commit.toJson(),
    "protected": protected,
    "protection": protection.toJson(),
    "protection_url": protectionUrl,
  };
}

class TreeClass {
  String sha;
  String url;

  TreeClass({
    required this.sha,
    required this.url,
  });

  factory TreeClass.fromJson(Map<String, dynamic> json) => TreeClass(
    sha: json["sha"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "sha": sha,
    "url": url,
  };
}

class Protection {
  bool enabled;
  RequiredStatusChecks requiredStatusChecks;

  Protection({
    required this.enabled,
    required this.requiredStatusChecks,
  });

  factory Protection.fromJson(Map<String, dynamic> json) => Protection(
    enabled: json["enabled"],
    requiredStatusChecks: RequiredStatusChecks.fromJson(json["required_status_checks"]),
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "required_status_checks": requiredStatusChecks.toJson(),
  };
}

class RequiredStatusChecks {
  String enforcementLevel;
  List<dynamic> contexts;
  List<dynamic> checks;

  RequiredStatusChecks({
    required this.enforcementLevel,
    required this.contexts,
    required this.checks,
  });

  factory RequiredStatusChecks.fromJson(Map<String, dynamic> json) => RequiredStatusChecks(
    enforcementLevel: json["enforcement_level"],
    contexts: List<dynamic>.from(json["contexts"].map((x) => x)),
    checks: List<dynamic>.from(json["checks"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "enforcement_level": enforcementLevel,
    "contexts": List<dynamic>.from(contexts.map((x) => x)),
    "checks": List<dynamic>.from(checks.map((x) => x)),
  };
}

class CommitElement {
  String sha;
  String nodeId;
  PurpleCommit commit;
  String url;
  String htmlUrl;
  String commentsUrl;
  PurpleAuthor author;
  PurpleAuthor committer;
  List<Parent> parents;

  CommitElement({
    required this.sha,
    required this.nodeId,
    required this.commit,
    required this.url,
    required this.htmlUrl,
    required this.commentsUrl,
    required this.author,
    required this.committer,
    required this.parents,
  });

  factory CommitElement.fromJson(Map<String, dynamic> json) => CommitElement(
    sha: json["sha"],
    nodeId: json["node_id"],
    commit: PurpleCommit.fromJson(json["commit"]),
    url: json["url"],
    htmlUrl: json["html_url"],
    commentsUrl: json["comments_url"],
    author: PurpleAuthor.fromJson(json["author"]),
    committer: PurpleAuthor.fromJson(json["committer"]),
    parents: List<Parent>.from(json["parents"].map((x) => Parent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sha": sha,
    "node_id": nodeId,
    "commit": commit.toJson(),
    "url": url,
    "html_url": htmlUrl,
    "comments_url": commentsUrl,
    "author": author.toJson(),
    "committer": committer.toJson(),
    "parents": List<dynamic>.from(parents.map((x) => x.toJson())),
  };
}

class PurpleAuthor {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  bool siteAdmin;

  PurpleAuthor({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.siteAdmin,
  });

  factory PurpleAuthor.fromJson(Map<String, dynamic> json) => PurpleAuthor(
    login: json["login"],
    id: json["id"],
    nodeId: json["node_id"],
    avatarUrl: json["avatar_url"],
    gravatarId: json["gravatar_id"],
    url: json["url"],
    htmlUrl: json["html_url"],
    followersUrl: json["followers_url"],
    followingUrl: json["following_url"],
    gistsUrl: json["gists_url"],
    starredUrl: json["starred_url"],
    subscriptionsUrl: json["subscriptions_url"],
    organizationsUrl: json["organizations_url"],
    reposUrl: json["repos_url"],
    eventsUrl: json["events_url"],
    receivedEventsUrl: json["received_events_url"],
    type: json["type"],
    siteAdmin: json["site_admin"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "id": id,
    "node_id": nodeId,
    "avatar_url": avatarUrl,
    "gravatar_id": gravatarId,
    "url": url,
    "html_url": htmlUrl,
    "followers_url": followersUrl,
    "following_url": followingUrl,
    "gists_url": gistsUrl,
    "starred_url": starredUrl,
    "subscriptions_url": subscriptionsUrl,
    "organizations_url": organizationsUrl,
    "repos_url": reposUrl,
    "events_url": eventsUrl,
    "received_events_url": receivedEventsUrl,
    "type": type,
    "site_admin": siteAdmin,
  };
}

class PurpleCommit {
  FluffyAuthor author;
  FluffyAuthor committer;
  String message;
  TreeClass tree;
  String url;
  int commentCount;
  Verification verification;

  PurpleCommit({
    required this.author,
    required this.committer,
    required this.message,
    required this.tree,
    required this.url,
    required this.commentCount,
    required this.verification,
  });

  factory PurpleCommit.fromJson(Map<String, dynamic> json) => PurpleCommit(
    author: FluffyAuthor.fromJson(json["author"]),
    committer: FluffyAuthor.fromJson(json["committer"]),
    message: json["message"],
    tree: TreeClass.fromJson(json["tree"]),
    url: json["url"],
    commentCount: json["comment_count"],
    verification: Verification.fromJson(json["verification"]),
  );

  Map<String, dynamic> toJson() => {
    "author": author.toJson(),
    "committer": committer.toJson(),
    "message": message,
    "tree": tree.toJson(),
    "url": url,
    "comment_count": commentCount,
    "verification": verification.toJson(),
  };
}

class FluffyAuthor {
  String name;
  String email;
  DateTime date;

  FluffyAuthor({
    required this.name,
    required this.email,
    required this.date,
  });

  factory FluffyAuthor.fromJson(Map<String, dynamic> json) => FluffyAuthor(
    name: json["name"],
    email: json["email"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "date": date.toIso8601String(),
  };
}

class Verification {
  bool verified;
  String reason;
  String signature;
  String payload;

  Verification({
    required this.verified,
    required this.reason,
    required this.signature,
    required this.payload,
  });

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
    verified: json["verified"],
    reason: json["reason"],
    signature: json["signature"],
    payload: json["payload"],
  );

  Map<String, dynamic> toJson() => {
    "verified": verified,
    "reason": reason,
    "signature": signature,
    "payload": payload,
  };
}

class Parent {
  String sha;
  String url;
  String htmlUrl;

  Parent({
    required this.sha,
    required this.url,
    required this.htmlUrl,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
    sha: json["sha"],
    url: json["url"],
    htmlUrl: json["html_url"],
  );

  Map<String, dynamic> toJson() => {
    "sha": sha,
    "url": url,
    "html_url": htmlUrl,
  };
}
