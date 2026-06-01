/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_agt_tran_bank_acct_lmt
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_agt_tran_bank_acct_lmt drop partition p_${last_date};
alter table ${idl_schema}.aml_agt_tran_bank_acct_lmt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_agt_tran_bank_acct_lmt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_agt_tran_bank_acct_lmt (
    etl_dt  -- 数据日期
    ,agt_id  -- 法人编号
    ,attr_name  -- 客户编号
    ,lp_id  -- 股东客户编号
    ,acct_id  -- 股东名称
    ,cust_id  -- 股东类型代码
    ,user_seq_num  -- 股东组织机构类型代码
    ,attr_val  -- 股东所在国别代码
    ,tran_chn_cd  -- 股东组织机构代码
    ,start_dt  -- 股东营业执照编号
    ,end_dt  -- 企业出资人经济成分代码
    ,id_mark  -- 自然人股东证件类型代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.attr_name,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 股东客户编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 股东名称
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 股东类型代码
    ,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'')  -- 股东组织机构类型代码
    ,replace(replace(t1.attr_val,chr(13),''),chr(10),'')  -- 股东所在国别代码
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 股东组织机构代码
    ,t1.start_dt  -- 股东营业执照编号
    ,t1.end_dt  -- 企业出资人经济成分代码
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 自然人股东证件类型代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_tran_bank_acct_lmt t1    --交易银行账户限额
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_agt_tran_bank_acct_lmt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);