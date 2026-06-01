/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_plms_addaccountbalance
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.plms_addaccountbalance drop partition p_${last_date};
alter table ${idl_schema}.plms_addaccountbalance drop partition p_${batch_date};

-- 2.2 add today partition
--whenever sqlerror exit sql.sqlcode;
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.plms_addaccountbalance add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

--删除临时表
whenever sqlerror continue none;
drop table ${idl_schema}.crss_customer_info_tmp_${batch_date};

--创建临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crss_customer_info_tmp_${batch_date} as select mfcustomerid from ${iol_schema}.crss_customer_info where 1=2;

--临时表装数
insert/*+append*/ into ${idl_schema}.crss_customer_info_tmp_${batch_date} nologging
select
         distinct
          t1.mfcustomerid
     from iol.crss_customer_info t1,
          idl.f_pty_cust_identity_rela t2 
     where 
       t1.start_dt<=to_date('${batch_date}','yyyymmdd') 
      and t1.end_dt>to_date('${batch_date}','yyyymmdd') 
      and t2.etl_dt=to_date('${batch_date}','yyyymmdd') 
      and (
       'CSTCMS'||t1.CUSTOMERID = t2.PARTY_ID
       or 'CSTCIF' || t1.mfcustomerid = t2.party_id
       --and 'CSTCMS' || t1.customerid <> t2.party_id
       or 'CSTCIF'||t1.CUSTOMERID = t2.PARTY_ID and t1.MFCUSTOMERID is null
     )
;
commit;

-- 2.4 insert data target table
insert /*+ append */ into ${idl_schema}.plms_addaccountbalance partition for (to_date('${batch_date}','yyyymmdd')) (
    cust_no  -- 客户ID
    ,acct_no  -- 账户编号
    ,acct_tp  -- 账户类型
    ,subs_ac  -- 子账户编号
    ,curr_code  -- 币种
    ,dp_bal  -- 账户余额
    ,dp_mon_avl  -- 月日均存款
    ,acct_st  -- 账户状态
    ,debt_tp  -- 储种代码
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.cust_no,chr(13),''),chr(10),'')  -- 客户ID
    ,replace(replace(t1.acct_no,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_tp,chr(13),''),chr(10),'')  -- 账户类型
    ,replace(replace(t1.subs_ac,chr(13),''),chr(10),'')  -- 子账户编号
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 币种
    ,t1.dp_bal  -- 账户余额
    ,t1.dp_mon_avl+t1.xd_dp_mon_avl  -- 存款月日均/协定存款月积数
    ,replace(replace(t1.acct_st,chr(13),''),chr(10),'')  -- 账户状态
    ,replace(replace(t1.debt_tp,chr(13),''),chr(10),'')  -- 储种代码
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,t1.etl_timestamp  -- 
from ${idl_schema}.a_d_dp_info_ft t1  --adm存款明细汇总
inner join ${idl_schema}.crss_customer_info_tmp_${batch_date} t2
 on  t1.cust_no=t2.mfcustomerid
where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;


--drop tmp table
whenever sqlerror exit sql.sqlcode;
drop table ${idl_schema}.crss_customer_info_tmp_${batch_date};

-- 2.6 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'plms_addaccountbalance',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);