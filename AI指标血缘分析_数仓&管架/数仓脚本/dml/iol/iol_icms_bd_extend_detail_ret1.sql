/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BD_EXTEND_DETAIL_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ICMS_BD_EXTEND_DETAIL_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BD_EXTEND_DETAIL');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BD_EXTEND_DETAIL drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BD_EXTEND_DETAIL add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BD_EXTEND_DETAIL(
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,overdrafttime -- 
            ,paymentobject -- 
            ,purpose -- 
            ,ftcommission -- 
            ,agreementid -- 
            ,isreceivebill -- 
            ,iscreditrelease -- 
            ,lastmodified -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,to_date('00010101','yyyymmdd')  AS overdrafttime -- 
            ,' ' AS paymentobject -- 
            ,' ' AS purpose -- 
            ,' ' AS ftcommission -- 
            ,' ' AS agreementid -- 
            ,' ' AS isreceivebill -- 
            ,' ' AS iscreditrelease -- 
            ,to_date('00010101','yyyymmdd')  AS lastmodified -- 
            ,' ' AS oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BD_EXTEND_DETAIL_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
