/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_ywpzsgzf_d
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
alter table ${idl_schema}.orws_m_omd_ywpzsgzf_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_ywpzsgzf_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_ywpzsgzf_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_ywpzsgzf_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 日期
    ,branch_code  -- 机构
    ,branch_name  -- 机构名称
    ,jyrq  -- 交易日期
    ,yg_name  -- 员工名称
    ,acc_code  -- 科目代码
    ,acc_name  -- 科目名称
    ,lsh  -- 流水号
    ,opertordt  -- 操作时间
    ,cnt  -- 作废数量
    ,processor  -- 跟踪处理情况
    ,menuid  -- 交易码
    ,menuname  -- 交易名称
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 日期
    ,replace(replace(branch_code,chr(13),''),chr(10),'')  -- 机构
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(rtrim(jyrq),chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(rtrim(yg_name),chr(13),''),chr(10),'')  -- 员工名称
    ,replace(replace(rtrim(acc_code),chr(13),''),chr(10),'')  -- 科目代码
    ,replace(replace(rtrim(acc_name),chr(13),''),chr(10),'')  -- 科目名称
    ,replace(replace(rtrim(lsh),chr(13),''),chr(10),'')  -- 流水号
    ,replace(replace(rtrim(opertordt),chr(13),''),chr(10),'')  -- 操作时间
    ,cnt  -- 作废数量
    ,replace(replace(rtrim(processor),chr(13),''),chr(10),'')  -- 跟踪处理情况
    ,replace(replace(rtrim(menuid),chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(rtrim(menuname),chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_ywpzsgzf_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_ywpzsgzf_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);