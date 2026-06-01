/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_subject_bala_d
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
alter table ${idl_schema}.orws_m_omd_subject_bala_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_subject_bala_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_subject_bala_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_subject_bala_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 日期
    ,curr_code  -- 币种代码
    ,branch_code  -- 机构代码
    ,branch_name  -- 机构名称
    ,itemcd  -- 科目代码
    ,itemname  -- 科目名称
    ,cur_day_dr_bal  -- 借方余额
    ,cur_day_cr_bal  -- 贷方余额
    ,processor  -- 跟踪处理情况
    ,cur_day_dr_amt  -- 本期借方发生额
    ,cur_day_cr_amt  -- 本期货方发生额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 日期
    ,replace(replace(curr_code,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(branch_code,chr(13),''),chr(10),'')  -- 机构代码
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(itemcd,chr(13),''),chr(10),'')  -- 科目代码
    ,replace(replace(rtrim(itemname),chr(13),''),chr(10),'')  -- 科目名称
    ,cur_day_dr_bal  -- 借方余额
    ,cur_day_cr_bal  -- 贷方余额
    ,replace(replace(rtrim(processor),chr(13),''),chr(10),'')  -- 跟踪处理情况
    ,cur_day_dr_amt  -- 本期借方发生额
    ,cur_day_cr_amt  -- 本期货方发生额
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_subject_bala_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_subject_bala_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);