enum UserAccess {
  private("private"),
  restricted("restricted"),
  public("public"),
  follow("follow");

  final String access;
  const UserAccess(this.access);

  factory UserAccess.parse(String acs) {
    switch(acs) {
      case "private":
        return UserAccess.private;
      case "restricted":
        return UserAccess.restricted;
      case "public":
        return UserAccess.public;
      case "follow":
        return UserAccess.follow;
      default:
        return UserAccess.private;
    }
  }
}
