# 交叉链接约定

活文档之间用标准 Markdown 链接显式互联，把"顺着一个功能看全貌"从**人脑记同名约定**变成**可点击、可遍历**的关系图。

## Bundle 相对链接（推荐）

以 `/` 开头、相对 `.ctxloom/` 根解析，文档在子目录间移动时仍稳定。

示例：
```markdown
[需求文档](/requirements/coupon.md)
[设计文档](/designs/coupon.md)
```

## 活文档关联指引行

每份活文档（`requirements/`、`designs/`、`tasks/`、`archive/` 下的 `<功能>.md`）正文**开头**放一行关联指引，指向该功能的上下游同名文档：

```markdown
> 关联：需求 [/requirements/coupon.md] ｜ 设计 [/designs/coupon.md] ｜ 执行 [/tasks/coupon.md]
```

## 坏链容忍

如果功能文档在各阶段间移动或某些阶段被跳过，对应的链接可能不存在——这是正常的，消费方必须容忍坏链。坏链表示"尚未写的知识"，不是错误。
