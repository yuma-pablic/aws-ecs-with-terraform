# aws-with-terraform
[AWSコンテナ設計・構築[本格]入門](https://www.sbcr.jp/product/4815607654/)の第五章までをコード化
## install
```
brew install terraform tflint trivy
brew unlink tfenv
brew install tfenv
pip install pre-commit
pre-commit install
```
## init
```
task dev-init
```
## apply
```
task dev-apply
```

## 参考書籍
- [AWSコンテナ設計・構築[本格]入門](https://www.sbcr.jp/product/4815607654/)
- [詳解 Terraform 第3版](https://www.oreilly.co.jp/books/9784814400522/)
- [ecspresso handbook v2対応版](https://zenn.dev/fujiwara/books/ecspresso-handbook-v2)

## License
MIT

Copyright <2024> <yvng-saimon>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.