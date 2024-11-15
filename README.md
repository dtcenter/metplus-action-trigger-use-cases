# metplus-action-trigger-use-cases
Custom GitHub Action used to trigger a METplus testing workflow to ensure that changes to other METplus component repositories do not break METplus use case functionality.

## Example Usage
```
name: Trigger METplus Workflow

on:
  push:
    branches:
      - develop
      - 'main_v[0-9]+.[0-9]+'
    paths-ignore:
      - 'docs/**'
      - '.github/pull_request_template.md'
      - '.github/ISSUE_TEMPLATE/**'
      - '**/README.md'
      - '**/LICENSE.md'

jobs:
  trigger_metplus:
    name: Trigger METplus testing workflow
    runs-on: ubuntu-latest
    steps:
      - uses: dtcenter/metplus-action-trigger-use-cases@v1
        with:
          token: ${{ secrets.METPLUS_BOT_TOKEN }}
```
