/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_dxezfxtwlzye
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
alter table ${idl_schema}.orws_m_omd_dxezfxtwlzye drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_dxezfxtwlzye drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_dxezfxtwlzye add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_dxezfxtwlzye partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 数据日期
    ,jg  -- 机构
    ,khwd  -- 开户网点
    ,gzzh  -- 挂账账号
    ,zhmc  -- 账户名称
    ,ye  -- 余额
    ,km  -- 科目
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(rtrim(date_id),chr(13),''),chr(10),'')  -- 数据日期
    ,replace(replace(rtrim(jg),chr(13),''),chr(10),'')  -- 机构
    ,replace(replace(rtrim(khwd),chr(13),''),chr(10),'')  -- 开户网点
    ,replace(replace(rtrim(gzzh),chr(13),''),chr(10),'')  -- 挂账账号
    ,replace(replace(rtrim(zhmc),chr(13),''),chr(10),'')  -- 账户名称
    ,ye  -- 余额
    ,replace(replace(rtrim(km),chr(13),''),chr(10),'')  -- 科目
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_dxezfxtwlzye
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_dxezfxtwlzye',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);