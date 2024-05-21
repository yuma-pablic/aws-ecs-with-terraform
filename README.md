# aws-with-terraform
[AWSコンテナ設計・構築[本格]入門](https://www.sbcr.jp/product/4815607654/)の第五章までをコード化
## install
```
brew install terraform tfsec tflint
brew unlink tfenv
brew install tfenv
pip install pre-commit
pre-commit install       
```
## init
```
make dev-init
```
## apply
```
make dev-apply
```

## 参考書籍
- [AWSコンテナ設計・構築[本格]入門](https://www.sbcr.jp/product/4815607654/)
- [詳解 Terraform 第3版](https://www.oreilly.co.jp/books/9784814400522/)
