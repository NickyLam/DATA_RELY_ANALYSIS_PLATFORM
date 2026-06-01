/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_txn_sign_ret1
CreateDate: 20250408
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
                       FROM ppps_e_txn_sign_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ppps_e_txn_sign');

  if v_var <> 0 then
    execute immediate 'alter table ppps_e_txn_sign drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ppps_e_txn_sign add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ppps_e_txn_sign (
    id -- 自增主键
    ,trx_id -- 交易流水号
    ,issr_id -- 发起方所属机构编号
    ,trx_dt_tm -- 交易ISO日期时间
    ,trx_ctgy -- 交易类别
    ,txn_date -- 平台交易日期
    ,txn_time -- 平台交易时间
    ,status -- 流水状态
    ,instg_id -- 支付账户所属机构标识
    ,instg_acct_de -- 签约人支付账户编号
    ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,sgn_acct_tp -- 签约人账户类型
    ,sgn_acct_id_de -- 签约人银行账户号码
    ,sgn_acct_nm_de -- 签约人银行账户名称
    ,id_tp -- 签约人证件类型
    ,id_no_de -- 签约人证件号码
    ,mob_no_de -- 签约人预留手机号
    ,sgn_acct_lvl -- 签约人银行账户等级
    ,sms_seq_no -- 验证序列号
    ,sms_index -- 验证码索引
    ,cust_no -- 客户号
    ,biz_sts_cd -- 业务返回码
    ,biz_sts_desc -- 业务返回说明
    ,sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc -- 系统返回说明
    ,sys_rtn_tm -- 系统返回时间
    ,insert_time -- 创建时间
    ,update_time -- 最后更新时间
    ,remark -- 备注信息
    ,global_no -- 全局流水号
    ,mcht_no -- 渠道编号
    ,lgn_id -- 受理机构登录账号
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    id as id -- 自增主键
    ,trx_id as trx_id -- 交易流水号
    ,issr_id as issr_id -- 发起方所属机构编号
    ,trx_dt_tm as trx_dt_tm -- 交易ISO日期时间
    ,trx_ctgy as trx_ctgy -- 交易类别
    ,txn_date as txn_date -- 平台交易日期
    ,txn_time as txn_time -- 平台交易时间
    ,status as status -- 流水状态
    ,instg_id as instg_id -- 支付账户所属机构标识
    ,instg_acct_de as instg_acct_de -- 签约人支付账户编号
    ,sgn_acct_issr_id as sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,sgn_acct_tp as sgn_acct_tp -- 签约人账户类型
    ,sgn_acct_id_de as sgn_acct_id_de -- 签约人银行账户号码
    ,sgn_acct_nm_de as sgn_acct_nm_de -- 签约人银行账户名称
    ,id_tp as id_tp -- 签约人证件类型
    ,id_no_de as id_no_de -- 签约人证件号码
    ,mob_no_de as mob_no_de -- 签约人预留手机号
    ,sgn_acct_lvl as sgn_acct_lvl -- 签约人银行账户等级
    ,sms_seq_no as sms_seq_no -- 验证序列号
    ,sms_index as sms_index -- 验证码索引
    ,cust_no as cust_no -- 客户号
    ,biz_sts_cd as biz_sts_cd -- 业务返回码
    ,biz_sts_desc as biz_sts_desc -- 业务返回说明
    ,sys_rtn_cd as sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc as sys_rtn_desc -- 系统返回说明
    ,sys_rtn_tm as sys_rtn_tm -- 系统返回时间
    ,insert_time as insert_time -- 创建时间
    ,update_time as update_time -- 最后更新时间
    ,remark as remark -- 备注信息
    ,' ' as global_no -- 全局流水号
    ,' ' as mcht_no -- 渠道编号
    ,' ' as lgn_id -- 受理机构登录账号
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_e_txn_sign_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

