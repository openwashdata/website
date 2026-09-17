---
id: 2026-09-17-001-openwashdata-website-has-a-built-problem
timestamp: 2026-09-17T15:24:07+02:00
model: claude-fable-5-1
files_touched:
  - _freeze/pages/gallery/data/index/execute-results/html.json
---

openwashdata/website has a built problem from a recent PR:

3:14:03 PM: Netlify Build                                                 
3:14:03 PM: ────────────────────────────────────────────────────────────────
3:14:03 PM: ​
3:14:03 PM: ❯ Version
3:14:03 PM:   @netlify/build 36.4.6
3:14:03 PM: ​
3:14:03 PM: ❯ Flags
3:14:03 PM:   accountId: 593521093c1d5e282bb54c0b
3:14:03 PM:   baseRelDir: true
3:14:03 PM:   buildId: 6aaa960c61683e00088b3d56
3:14:03 PM:   deployId: 6aaa960c61683e00088b3d58
3:14:03 PM: ​
3:14:03 PM: ❯ Current directory
3:14:03 PM:   /opt/build/repo
3:14:03 PM: ​
3:14:03 PM: ❯ Config file
3:14:03 PM:   /opt/build/repo/netlify.toml
3:14:03 PM: ​
3:14:03 PM: ❯ Context
3:14:03 PM:   deploy-preview
3:14:03 PM: ​
3:14:03 PM: ❯ Warning: @quarto/netlify-plugin-quarto will be executed with Node.js version 22.23.2
3:14:03 PM:   The plugin cannot be executed with your defined Node.js version 20.20.2
3:14:03 PM: ​
3:14:03 PM:   Read more about our minimum required version in our forums announcement
3:14:03 PM: ​
3:14:03 PM: ❯ Loading plugins
3:14:03 PM:    - @quarto/netlify-plugin-quarto@0.0.5 from netlify.toml and package.json
3:14:08 PM: Netlify configuration {
3:14:08 PM:   functions: { '*': {} },
3:14:08 PM:   plugins: [
3:14:08 PM:     {
3:14:08 PM:       origin: 'config',
3:14:08 PM:       package: '@quarto/netlify-plugin-quarto',
3:14:08 PM:       inputs: {}
3:14:08 PM:     }
3:14:08 PM:   ],
3:14:08 PM:   build: {
3:14:08 PM:     environment: {
3:14:08 PM:       BRANCH: 'dev',
3:14:08 PM:       CONTEXT: 'deploy-preview',
3:14:08 PM:       DEPLOY_PRIME_URL: 'https://deploy-preview-159--luminous-treacle-bd685b.netlify.app',
3:14:08 PM:       DEPLOY_URL: 'https://6aaa960c61683e00088b3d58--luminous-treacle-bd685b.netlify.app',
3:14:08 PM:       REVIEW_ID: '159',
3:14:08 PM:       SITE_ID: 'edc7dcb2-0ded-4d2d-b807-4287e81075ba',
3:14:08 PM:       SITE_NAME: 'luminous-treacle-bd685b',
3:14:08 PM:       URL: 'https://openwashdata.org'
3:14:08 PM:     },
3:14:08 PM:     publish: '/opt/build/repo/_site',
3:14:08 PM:     publishOrigin: 'ui',
3:14:08 PM:     processing: { css: {}, html: {}, images: {}, js: {} },
3:14:08 PM:     services: {}
3:14:08 PM:   },
3:14:08 PM:   headers: [],
3:14:08 PM:   redirects: []
3:14:08 PM: }
3:14:08 PM: Plugin configuration { version: 'latest', cmd: 'render' }
3:14:08 PM: Build directory _site
3:14:09 PM:
