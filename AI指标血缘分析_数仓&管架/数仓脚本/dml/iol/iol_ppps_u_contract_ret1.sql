/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_u_contract
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
                       FROM ppps_u_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ppps_u_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table ppps_u_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ppps_u_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ppps_u_contract(
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,' ' as pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ppps_u_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
