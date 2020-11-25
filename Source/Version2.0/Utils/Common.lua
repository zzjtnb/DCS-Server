SourceObj = SourceObj or {}
SourceObj.checkServer = function(id)
  if id == net.get_server_id() then
    return true
  else
    return false
  end
end

SourceObj.initMessage = function(groupId, SourcePoint)
  trigger.action.outTextForGroup(groupId, '警告!由于目前AIM-54有严重的bug, 因此每个架次的F-14B被限制为只能携带2枚AIM-54A_MK47', 60, true)
  local message =
    '*请注意！！！服务器已启用资源系统！请务必详阅以下内容，避免起飞自爆：你当前剩余点数:' ..
    tostring(SourcePoint) .. -- '\n[1]玩家初始拥有' ..
      -- tostring(_args[2]) ..
      "\n[1]服务器永久保存每位玩家的剩余资源点数,可通过F10菜单查询;\n[2]飞机、弹药、吊舱等都需消耗部分资源点,起飞后合计扣除.返场降落将根据你的弹药余量返点;\n[3]击杀敌方单位、吊运、救援，值班GCI、ATC、OP都可获取相应点数;\n[4]起飞前请务必检查\"余额\"及挂载量、合理支配点数，如果资源点不足以支付消耗，强行起飞将会自爆;\n[5]资源点明细见NP群:511466821或B站账号:'NPServer'\n\n***新机制加入难免BUG,有问题请向NP群管理反映,感谢支持和理解***"
  trigger.action.outTextForGroup(groupId, message, 60)
end
