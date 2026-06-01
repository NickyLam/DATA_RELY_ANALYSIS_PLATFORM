/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_pty_fx_cap_cntpty
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
alter table ${idl_schema}.icrm_pty_fx_cap_cntpty drop partition p_${last_date};
alter table ${idl_schema}.icrm_pty_fx_cap_cntpty drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_pty_fx_cap_cntpty add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_pty_fx_cap_cntpty partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,cntpty_id  -- 交易对手编号
    ,dept_id  -- 部门编号
    ,cn_name  -- 中文名称
    ,en_name  -- 英文名称
    ,cn_abbr  -- 中文简称
    ,en_abbr  -- 英文简称
    ,fx_id  -- 外汇编号
    ,cust_id  -- 客户编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.cn_name,chr(13),''),chr(10),'')  -- 中文名称
    ,replace(replace(t1.en_name,chr(13),''),chr(10),'')  -- 英文名称
    ,replace(replace(t1.cn_abbr,chr(13),''),chr(10),'')  -- 中文简称
    ,replace(replace(t1.en_abbr,chr(13),''),chr(10),'')  -- 英文简称
    ,replace(replace(t1.fx_id,chr(13),''),chr(10),'')  -- 外汇编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.pty_fx_cap_cntpty t1    --外汇资金交易对手
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_pty_fx_cap_cntpty',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);