## v0.0.2-basic_setup

This snapshot provides several basic setups in the administrative area.

### Modules

In alphabetical order:

- Installed [Admin Toolbar](https://www.drupal.org/project/admin_toolbar) module.
- Installed [Autosave Form](https://www.drupal.org/project/autosave_form) module.
- Installed [Clientside Validation](https://www.drupal.org/project/clientside_validation) module.
- Installed [Config Ignore](https://www.drupal.org/project/config_ignore) module.
- Installed [Config Pages](https://www.drupal.org/project/config_pages) module.
- Installed [Conflict](https://www.drupal.org/project/conflict) module.
- Installed [Devel](https://www.drupal.org/project/devel) module (in *require-dev*, for later use).
- Installed [Diff](https://www.drupal.org/project/diff) module.
- Installed [Entity Browser Block](https://www.drupal.org/project/entity_browser_block) module (for later use).
- Installed [Field Group](https://www.drupal.org/project/field_group) module (for later use).
- Installed [Flood control](https://www.drupal.org/project/flood_control) module.
- Installed [Focal Point](https://www.drupal.org/project/focal_point) module.
- Installed [Honeypot](https://www.drupal.org/project/honeypot) module.
- Installed [Inline Entity Form](https://www.drupal.org/project/inline_entity_form) module (for later use).
- Installed [Login Email or Username](https://www.drupal.org/project/login_emailusername) module.
- Installed [Media Directories](https://www.drupal.org/project/media_directories) module.
- Installed [Media Library Edit](https://www.drupal.org/project/media_library_edit) module.
- Installed [Metatag](https://www.drupal.org/project/metatag) module.
- Installed [Moderation Sidebar](https://www.drupal.org/project/moderation_sidebar) module.
- Installed [Node title help text](https://www.drupal.org/project/node_title_help_text) module.
- Installed [Pathauto](https://www.drupal.org/project/pathauto) module.
- Installed [Rebuild Cache Access](https://www.drupal.org/project/rebuild_cache_access) module.
- Installed [Reroute Email](https://www.drupal.org/project/reroute_email) module.
- Installed [Search API](https://www.drupal.org/project/search_api) module.
- Installed [Security Kit](https://www.drupal.org/project/seckit) module.
- Installed [Sessionless BigPipe](https://www.drupal.org/project/big_pipe_sessionless) module.
- Installed [Simple XML sitemap](https://www.drupal.org/project/simple_sitemap) module.
- Installed [Site Alert](https://www.drupal.org/project/site_alert) module (for later use).
- Installed [SVG Image Field](https://www.drupal.org/project/svg_image_field) module.
- Installed [Token OR](https://www.drupal.org/project/token_or) module.
- Installed [Username Enumeration Prevention](https://www.drupal.org/project/username_enumeration_prevention) module.
- Installed [Webform](https://www.drupal.org/project/webform) module.

#### Config page

- Added new config page *Site settings*.
  - Added *Default share image* field.

#### Taxonomy

- Added vocabulary *Media directories* to help organising media assets.

#### Media
- Adjusted *Media > __all__* form display and manage display settings (need to revisit).
  - Adjusted *Media > Image* form display to use *focal point*.

#### Content types
- Replaced *Image* field in *Article* to use *Media > Image* (*Main image* field).
- Reused *Main image* field in *Basic page*.
- Added *Meta tags* field in *Article* and *Basic page*.
- Added *Article date* field in *Article*.
- Adjusted *Article* and *Basic page* form display settings.
- Adjusted *Article* and *Basic page* manage display settings (need to revisit).

#### Configuration
- (Media > Image styles) Added new image styles based on *Focal point scale and crop*: *Landscape 16:9*, *Portrait 9:16*, *Square 1:1*, and *Panorama 4:1*.
- (Workflow > Workflows) Enabled *Content moderation* workflow to *Article* and *Basic page*.
- (Search and metadata > URL aliases > Patterns) Added *Pathauto* pattern aliases for *Article* and *Basic page*.
- (Search and metadata > Metatag) Adjusted default *metatag default* for *Content*.
- (Region and language > Date and time formats) Added new formats: *Standard - Date*, *Standard - Time*, and *Standard - Date Time*.
- (Search and metadata > Simple XML Sitemap > Inclusion) Adjusted *Content* settings to include *Article* and *Basic page*.
- (Content authoring > Text formats and editors) Adjusted *Full HTML* text formats and editors to be the first picked-up by the CKEditor.
  - Enabled *Embed media* settings on the *Full HTML* format.
- (Search and metadata > Search API) Used Search API *Database Search Defaults* module (need to revisit).
- (Development > Configuration synchronization > Ignore) Adjusted settings to ignore *media.settings* and *reroute_email.settings* config.
- (System > Security Kit settings) Adjusted settings:
  - Set CSP `frame-ancestors` to allow lando sub-domains (fixed media oembed warning).
