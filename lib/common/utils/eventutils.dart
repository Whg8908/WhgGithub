import 'package:flutter/material.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/23
 *
 * @Description 事件描述与动作
 *
 * PS: Stay hungry,Stay foolish.
 */
class EventUtils {
  static getActionAndDes(event) {
    String actionStr;
    String des;
    switch (event["type"]) {
      case "CommitCommentEvent":
        actionStr = "Commit comment at " + event["repo"]["name"];
        break;
      case "CreateEvent":
        if (event["payload"]["ref_type"] == "repository") {
          actionStr = "Created repository " + event["repo"]["name"];
        } else {
          actionStr = "Created " +
              event["payload"]["ref_type"] +
              " " +
              event["payload"]["ref"] +
              " at " +
              event["repo"]["name"];
        }
        break;
      case "DeleteEvent":
        actionStr = "Delete " +
            event["payload"]["ref_type"] +
            " " +
            event["payload"]["ref"] +
            " at " +
            event["repo"]["name"];
        break;
      case "ForkEvent":
        String oriRepo = event["repo"]["name"];
        String newRepo = event["actor"]["login"] + "/" + event["repo"]["name"];
        actionStr = "Forked " + oriRepo + " to " + newRepo;
        break;
      case "GollumEvent":
        actionStr = event["actor"]["login"] + " a wiki page ";
        break;

      case "InstallationEvent":
        actionStr = event["payload"]["action"] + " an GitHub App ";
        break;
      case "InstallationRepositoriesEvent":
        actionStr =
            event["payload"]["action"] + " repository from an installation ";
        break;
      case "IssueCommentEvent":
        actionStr = event["payload"]["action"] +
            " comment on issue " +
            event["payload"]["issue"]["number"].toString() +
            " in " +
            event["repo"]["name"];
        des = event["payload"]["comment"]["body"];
        break;
      case "IssuesEvent":
        actionStr = event["payload"]["action"] +
            " issue " +
            event["payload"]["issue"]["number"].toString().toString() +
            " in " +
            event["repo"]["name"];
        des = event["payload"]["issue"]["title"];
        break;

      case "MarketplacePurchaseEvent":
        actionStr = event["payload"]["action"] + " marketplace plan ";
        break;
      case "MemberEvent":
        actionStr =
            event["payload"]["action"] + " member to " + event["repo"]["name"];
        break;
      case "OrgBlockEvent":
        actionStr = event["payload"]["action"] + " a user ";
        break;
      case "ProjectCardEvent":
        actionStr = event["payload"]["action"] + " a project ";
        break;
      case "ProjectColumnEvent":
        actionStr = event["payload"]["action"] + " a project ";
        break;

      case "ProjectEvent":
        actionStr = event["payload"]["action"] + " a project ";
        break;
      case "PublicEvent":
        actionStr = "Made " + event["repo"]["name"] + " public";
        break;
      case "PullRequestEvent":
        actionStr = event["payload"]["action"] +
            " pull request " +
            event["repo"]["name"];
        break;
      case "PullRequestReviewEvent":
        actionStr = event["payload"]["action"] +
            " pull request review at" +
            event["repo"]["name"];
        break;
      case "PullRequestReviewCommentEvent":
        actionStr = event["payload"]["action"] +
            " pull request review comment at" +
            event["repo"]["name"];
        break;

      case "PushEvent":
        String ref = event["payload"]["ref"];
        ref = ref.substring(ref.lastIndexOf("/") + 1);
        actionStr = "Push to " + ref + " at " + event["repo"]["name"];

        des = '';
        String descSpan = '';

        int count = event["comments"];
        if (count != null) {
          int maxLines = 4;
          int max = (count != null && count > maxLines) ? maxLines - 1 : count;

          for (int i = 0; i < max; i++) {
            var commit = event["payload"]["comment"].get(i);
            if (i != 0) {
              descSpan += ("\n");
            }
            String sha = commit["sha"].substring(0, 7);
            descSpan += sha;
            descSpan += " ";
            descSpan += commit["message"];
          }
          if (count > maxLines) {
            descSpan = descSpan + "\n" + "...";
          }
        }
        break;
      case "ReleaseEvent":
        actionStr = event["payload"]["action"] +
            " release " +
            event["payload"]["release"]["tag_name"] +
            " at " +
            event["repo"]["name"];
        break;
      case "WatchEvent":
        actionStr = event["payload"]["action"] + " " + event["repo"]["name"];
        break;
    }

    return {"actionStr": actionStr, "des": des != null ? des : ""};
  }

  ///跳转
  static ActionUtils(BuildContext context, event, currentRepository) {
    if (event["repo"] == null) {
      NavigatorUtils.goPerson(context, event["actor"]["login"]);
      return;
    }
    String owner = event["repo"]["name"].split("/")[0];
    String repositoryName = event["repo"]["name"].split("/")[1];
    String fullName = owner + '/' + repositoryName;
    switch (event["type"]) {
      case 'ForkEvent':
        String forkName = event["actor"]["login"] + "/" + repositoryName;
        if (forkName == currentRepository) {
          return;
        }
        NavigatorUtils.goReposDetail(
            context, event["actor"]["login"], repositoryName);
        break;
      case 'PushEvent':
        if (event["payload"]["commits"] == null) {
          if (fullName == currentRepository) {
            return;
          }
          NavigatorUtils.goReposDetail(context, owner, repositoryName);
        } else if (event["payload"]["commits"].length == 1) {
          //goToPush(repositoryName, owner, event.payload.commits[0].sha)
        } else {
          //Actions.OptionModal({dataList: getOptionItem(repositoryName, owner, event.payload.commits)});
        }
        break;
      case 'ReleaseEvent':
        String url = event["payload"]["release"]["html_url"];
        //launchUrl(url);
        break;
      case 'IssueCommentEvent':
      case 'IssuesEvent':
        // 去issue
        /*Actions.IssueDetail({
          issue: event.payload.issue,
          title: fullName,
          repositoryName: repositoryName,
          userName: owner,
          needRightBtn: true,
          iconType:1,
          rightBtn: 'home',
          rightBtnPress: () => {
          Actions.RepositoryDetail({
          repositoryName: repositoryName, ownerName: owner
          , title: repositoryName
          });
          }
          });*/
        break;
      default:
        if (fullName == currentRepository) {
          return;
        }
        NavigatorUtils.goReposDetail(context, owner, repositoryName);
        break;
    }
  }
}
