# Github Actions 部署

1.将Settings/Pages选择为Git Actions部署
2.创建Assess Token 勾选workflow
3.在Settings/Secrets And Variables/Actions里面添加ASSESS_TOKEN变量
4.在Settings/Actions/General里面勾选workflows

- Workflow permissions(Read and write permissions)
- Actions permissions(Allow all actions and reusable workflows)

5.写脚本构建

## pnpm构建

```yml
# Sample workflow for building and deploying a Jekyll site to GitHub Pages
name: Deploy Jekyll with GitHub Pages dependencies preinstalled

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ['master']

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: 'pages'
  cancel-in-progress: false

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ['v18.6.0']
        pnpm-version: ['8.5.0']
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: setup node and pnpm
        uses: dafnik/setup-node-pnpm@v1
        with:
          pnpm: ${{ matrix.pnpm-version }}
          node: ${{ matrix.node-version }}
          install: false
      - run: |
          pnpm install
          npm run build
      - name: Setup Pages
        uses: actions/configure-pages@v5
      - name: Build with Jekyll
        uses: actions/jekyll-build-pages@v1
        with:
          source: ./dist
          destination: ./_site
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./_site

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    permissions:
      pages: write # to deploy to Pages
      id-token: write # to verify the deployment originates from an appropriate source
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
        with:
          token: ${{secrets.ACCESS_TOKEN}}
```
