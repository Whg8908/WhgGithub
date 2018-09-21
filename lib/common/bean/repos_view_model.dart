/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class ReposViewModel {
  String ownerName;
  String ownerPic;
  String repositoryName;
  String repositoryStar;
  String repositoryFork;
  String repositoryWatch;
  String hideWatchIcon;
  String repositoryType;
  String repositoryDes;

  ReposViewModel();

  ReposViewModel.fromMap(data) {
    ownerName = data["owner"]["login"];
    ownerPic = data["owner"]["avatar_url"];
    repositoryName = data["name"];
    repositoryStar = data["watchers_count"].toString();
    repositoryFork = data["forks_count"].toString();
    repositoryWatch = data["open_issues"].toString();
    repositoryType = data["language"] ?? '---';
    repositoryDes = data["description"] ?? '---';
  }
}
