/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_mpcs_cpmtstaff
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
alter table ${itl_schema}.itl_edw_mpcs_cpmtstaff drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_mpcs_cpmtstaff drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_mpcs_cpmtstaff add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_mpcs_cpmtstaff partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,staffno  -- 
    ,tlrtype  -- 
    ,staffname  -- 
    ,sex  -- 
    ,birthday  -- 
    ,idtype  -- 
    ,idno  -- 
    ,ofinstno  -- 
    ,ofdeptno  -- 
    ,stafftype  -- 
    ,mobile  -- 
    ,email  -- 
    ,safemode  -- 
    ,signpswd  -- 
    ,pswdchgdt  -- 
    ,rowstat  -- 
    ,upddt  -- 
    ,updtm  -- 
    ,ygno  -- 
    ,motto  -- 
    ,ofdeptnm  -- 
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.staffno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tlrtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.staffname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sex,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.birthday,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ofinstno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ofdeptno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.stafftype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.email,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.safemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.signpswd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pswdchgdt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rowstat,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.upddt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updtm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ygno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motto,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ofdeptnm,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_mpcs_cpmtstaff t1    --员工表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_mpcs_cpmtstaff',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);