/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_quote_contract
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
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
                       FROM bdms_cpes_quote_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_cpes_quote_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_cpes_quote_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_cpes_quote_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_cpes_quote_contract(
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,' ' as bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_quote_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
