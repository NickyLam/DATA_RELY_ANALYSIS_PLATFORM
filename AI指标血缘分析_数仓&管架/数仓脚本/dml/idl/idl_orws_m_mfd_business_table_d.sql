/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_mfd_business_table_d
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
alter table ${idl_schema}.orws_m_mfd_business_table_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_mfd_business_table_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_mfd_business_table_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_mfd_business_table_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 数据日期
    ,branch_code  -- 机构编码
    ,curr_code  -- 币种编码
    ,acc_code  -- 科目代号
    ,itemna  -- 科目名称
    ,blncdn  -- 余额性质
    ,last_day_dr_bal  -- 上日末借方余额
    ,last_day_cr_bal  -- 上日末贷方余额
    ,last_mon_dr_bal  -- 上月末借方余额
    ,last_mon_cr_bal  -- 上月末贷方余额
    ,last_quar_dr_bal  -- 上季末借方余额
    ,last_quar_cr_bal  -- 上季末贷方余额
    ,last_hyear_dr_bal  -- 上半年末借方余额
    ,last_hyear_cr_bal  -- 上半年末贷方余额
    ,last_year_dr_bal  -- 上年末借方余额
    ,last_year_cr_bal  -- 上年末贷方余额
    ,cur_day_dr_amt  -- 本日借方发生额
    ,cur_day_cr_amt  -- 本日贷方发生额
    ,mon_dr_amt_cml  -- 本月借方发生额
    ,mon_cr_amt_cml  -- 本月贷方发生额
    ,quar_dr_amt_cml  -- 本季借方发生额
    ,quar_cr_amt_cml  -- 本季贷方发生额
    ,hyear_dr_amt_cml  -- 本半年借方发生额
    ,hyear_cr_amt_cml  -- 本半年贷方发生额
    ,year_dr_amt_cml  -- 本年借方发生额
    ,year_cr_amt_cml  -- 本年贷方发生额
    ,cur_day_dr_bal  -- 本日借方余额
    ,cur_day_cr_bal  -- 本日贷方余额
    ,mon_dr_bal_cml  -- 本月借方余额
    ,mon_cr_bal_cml  -- 本月贷方余额
    ,quar_dr_bal_cml  -- 本季借方余额
    ,quar_cr_bal_cml  -- 本季贷方余额
    ,hyear_dr_bal_cml  -- 本半年借方余额
    ,hyear_cr_bal_cml  -- 本半年贷方余额
    ,year_dr_bal_cml  -- 本年借方余额
    ,year_cr_bal_cml  -- 本年贷方余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 数据日期
    ,replace(replace(branch_code,chr(13),''),chr(10),'')  -- 机构编码
    ,replace(replace(curr_code,chr(13),''),chr(10),'')  -- 币种编码
    ,replace(replace(acc_code,chr(13),''),chr(10),'')  -- 科目代号
    ,replace(replace(rtrim(itemna),chr(13),''),chr(10),'')  -- 科目名称
    ,replace(replace(rtrim(blncdn),chr(13),''),chr(10),'')  -- 余额性质
    ,last_day_dr_bal  -- 上日末借方余额
    ,last_day_cr_bal  -- 上日末贷方余额
    ,last_mon_dr_bal  -- 上月末借方余额
    ,last_mon_cr_bal  -- 上月末贷方余额
    ,last_quar_dr_bal  -- 上季末借方余额
    ,last_quar_cr_bal  -- 上季末贷方余额
    ,last_hyear_dr_bal  -- 上半年末借方余额
    ,last_hyear_cr_bal  -- 上半年末贷方余额
    ,last_year_dr_bal  -- 上年末借方余额
    ,last_year_cr_bal  -- 上年末贷方余额
    ,cur_day_dr_amt  -- 本日借方发生额
    ,cur_day_cr_amt  -- 本日贷方发生额
    ,mon_dr_amt_cml  -- 本月借方发生额
    ,mon_cr_amt_cml  -- 本月贷方发生额
    ,quar_dr_amt_cml  -- 本季借方发生额
    ,quar_cr_amt_cml  -- 本季贷方发生额
    ,hyear_dr_amt_cml  -- 本半年借方发生额
    ,hyear_cr_amt_cml  -- 本半年贷方发生额
    ,year_dr_amt_cml  -- 本年借方发生额
    ,year_cr_amt_cml  -- 本年贷方发生额
    ,cur_day_dr_bal  -- 本日借方余额
    ,cur_day_cr_bal  -- 本日贷方余额
    ,mon_dr_bal_cml  -- 本月借方余额
    ,mon_cr_bal_cml  -- 本月贷方余额
    ,quar_dr_bal_cml  -- 本季借方余额
    ,quar_cr_bal_cml  -- 本季贷方余额
    ,hyear_dr_bal_cml  -- 本半年借方余额
    ,hyear_cr_bal_cml  -- 本半年贷方余额
    ,year_dr_bal_cml  -- 本年借方余额
    ,year_cr_bal_cml  -- 本年贷方余额
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_mfd_business_table_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_mfd_business_table_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);