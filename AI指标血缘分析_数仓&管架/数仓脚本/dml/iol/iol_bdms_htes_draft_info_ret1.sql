/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_draft_info
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
                       FROM bdms_htes_draft_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_htes_draft_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_htes_draft_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_htes_draft_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_htes_draft_info(
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,' ' as migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from bdms_htes_draft_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
