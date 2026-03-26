//
//  YYKitFix.h
//  ChangXiangGrain
//
//  Created by GG on 2023/11/2.
//  Copyright © 2023 ChangXiangCloud. All rights reserved.
//

/*
  本文件用于集中记录对原始 YYKit 的兼容性修复。
  每个修复请按以下格式追加：

  【问题ID】简要描述
  - 影响文件/方法：
  - 触发条件：
  - 修复方案：
  - 备注（可选）：
*/

#pragma mark - 已应用的修复

/*
  【Fix-001】YYAsyncLayer 在 iOS 17+ 因 size 为 0 导致闪退
  - 影响文件/方法：YYAsyncLayer.m → -[YYAsyncLayer _displayAsync:]
  - 触发条件：UIGraphicsBeginImageContextWithOptions 传入 width 或 height 为 0
  - 修复方案：
    • API 替换：UIGraphicsBeginImageContextWithOptions → UIGraphicsImageRenderer
    • 安全处理：移除 size=0 手动判断（renderer 自动处理）
    • 内存管理：提前捕获 backgroundColor 避免 block 访问 self
    • 逻辑简化：删除内部重复的 size 校验分支
    • 行为一致：同步/异步分支共享相同渲染逻辑
*/
