class SocialMediaModel {
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final String? linkedIn;
  final String? catalog;
  final String? website;
  final String? virtualTour;
  final List<String>? profileLink;

  SocialMediaModel({
    this.instagram,
    this.facebook,
    this.twitter,
    this.linkedIn,
    this.catalog,
    this.virtualTour,
    this.website,
    this.profileLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'facebook': facebook,
      'twitter': twitter,
      'linkedIn': linkedIn,
      'catalog': catalog,
      'virtualTour': virtualTour,
      'website': website,
      'profileLink': profileLink,
    };
  }
}
