## v0.0.2-basic_setup

This snapshot provides several basic setups in the administrative area.

### Modules

- Installed [Admin Toolbar](https://www.drupal.org/project/admin_toolbar) module.
- Installed [Rebuild Cache Access](https://www.drupal.org/project/rebuild_cache_access) module.
- Installed [Media Library Edit](https://www.drupal.org/project/media_library_edit) module.
- Installed [Config Pages](https://www.drupal.org/project/config_pages) module.
- Installed [Focal Point](https://www.drupal.org/project/focal_point) module.
- Installed [Metatag](https://www.drupal.org/project/metatag) module.
- Installed [Pathauto](https://www.drupal.org/project/pathauto) module.
- Installed [Node title help text](https://www.drupal.org/project/node_title_help_text) module.
- Installed [Token OR](https://www.drupal.org/project/token_or) module.
- Installed [Simple XML sitemap](https://www.drupal.org/project/simple_sitemap) module.
- Installed [Moderation Sidebar](https://www.drupal.org/project/moderation_sidebar) module.
- Installed [Diff](https://www.drupal.org/project/diff) module.
- Installed [Autosave Form](https://www.drupal.org/project/autosave_form) module.
- Installed [Conflict](https://www.drupal.org/project/conflict) module.
- Installed [SVG Image Field](https://www.drupal.org/project/svg_image_field) module.
- Installed [Media Directories](https://www.drupal.org/project/media_directories) module.
- Installed [Login Email or Username](https://www.drupal.org/project/login_emailusername) module.
- Installed [Devel](https://www.drupal.org/project/devel) module (in **require-dev**).

#### Config page: *Site settings*

- Added *Default share image* field.

#### Taxonomy

- Added vocabulary *Media directories* to organise media assets.

#### Image styles
- Added new *focal point* based image styles: *Landscape 16:9*, *Portrait 9:16*, *Square 1:1*, and *Panorama 4:1*.

#### Media
- Adjusted *Media > Image* form display to use *focal point*.
- Adjusted all media types form display and manage display settings (need to revisit).

#### Content types
- Replaced *Image* field in *Article* to use *Media > Image* (*Main image* field).
- Reused *Main image* field in *Basic page*.
- Added *Meta tags* field in *Article* and *Basic page*.
- Adjusted *Article* and *Basic page* form display settings.
- Adjusted *Article* and *Basic page* manage display settings (need to revisit).

#### Configuration
- Enabled *Workflows > Editorial - Content moderation* to *Article* and *Basic page*.
- Added *Pathauto pattern* to *Article* and *Basic page*.
- Adjusted default meta tags for *Content*.
- Adjusted Simple XML Sitemap inclusion settings to include *Article* and *Basic page*.
- Adjusted *Full HTML* text formats and editors to be the first picked-up by the CKEditor. Adjusted the *embed media* settings.
