/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ref_card_bin_para_h
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
alter table ${itl_schema}.itl_edw_ref_card_bin_para_h drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ref_card_bin_para_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ref_card_bin_para_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ref_card_bin_para_h partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,卡标识编号  -- VARCHAR2(100)
    ,法人编号  -- VARCHAR2(60)
    ,卡bin名称  -- VARCHAR2(500)
    ,卡bin类型代码  -- VARCHAR2(30)
    ,停止发卡标志  -- VARCHAR2(30)
    ,ic卡制作许可代码  -- VARCHAR2(30)
    ,卡号长度  -- NUMBER(10)
    ,凭证种类代码  -- VARCHAR2(30)
    ,凭证号码起始位置  -- NUMBER(10)
    ,凭证号码长度  -- NUMBER(10)
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.卡标识编号,chr(13),''),chr(10),'')  -- VARCHAR2(100)
    ,replace(replace(t1.法人编号,chr(13),''),chr(10),'')  -- VARCHAR2(60)
    ,replace(replace(t1.卡bin名称,chr(13),''),chr(10),'')  -- VARCHAR2(500)
    ,replace(replace(t1.卡bin类型代码,chr(13),''),chr(10),'')  -- VARCHAR2(30)
    ,replace(replace(t1.停止发卡标志,chr(13),''),chr(10),'')  -- VARCHAR2(30)
    ,replace(replace(t1.ic卡制作许可代码,chr(13),''),chr(10),'')  -- VARCHAR2(30)
    ,replace(replace(t1.卡号长度,chr(13),''),chr(10),'')  -- NUMBER(10)
    ,replace(replace(t1.凭证种类代码,chr(13),''),chr(10),'')  -- VARCHAR2(30)
    ,replace(replace(t1.凭证号码起始位置,chr(13),''),chr(10),'')  -- NUMBER(10)
    ,replace(replace(t1.凭证号码长度,chr(13),''),chr(10),'')  -- NUMBER(10)
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_ref_card_bin_para_h t1    --卡bin参数历史
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ref_card_bin_para_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);