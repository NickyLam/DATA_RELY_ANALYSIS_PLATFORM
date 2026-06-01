/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_bank_acct
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
                       FROM rtis_bank_acct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('rtis_bank_acct');
  
  if v_var <> 0 then 
    execute immediate 'alter table rtis_bank_acct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table rtis_bank_acct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.rtis_bank_acct(
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rtis_bank_acct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
