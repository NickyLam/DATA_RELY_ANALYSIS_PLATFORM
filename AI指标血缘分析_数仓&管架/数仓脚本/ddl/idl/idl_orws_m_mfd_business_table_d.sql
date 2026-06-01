/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_mfd_business_table_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_mfd_business_table_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_mfd_business_table_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_mfd_business_table_d(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 数据日期
    ,branch_code varchar2(16) -- 机构编码
    ,curr_code varchar2(3) -- 币种编码
    ,acc_code varchar2(16) -- 科目代号
    ,itemna varchar2(200) -- 科目名称
    ,blncdn varchar2(1) -- 余额性质
    ,last_day_dr_bal number -- 上日末借方余额
    ,last_day_cr_bal number -- 上日末贷方余额
    ,last_mon_dr_bal number -- 上月末借方余额
    ,last_mon_cr_bal number -- 上月末贷方余额
    ,last_quar_dr_bal number -- 上季末借方余额
    ,last_quar_cr_bal number -- 上季末贷方余额
    ,last_hyear_dr_bal number -- 上半年末借方余额
    ,last_hyear_cr_bal number -- 上半年末贷方余额
    ,last_year_dr_bal number -- 上年末借方余额
    ,last_year_cr_bal number -- 上年末贷方余额
    ,cur_day_dr_amt number -- 本日借方发生额
    ,cur_day_cr_amt number -- 本日贷方发生额
    ,mon_dr_amt_cml number -- 本月借方发生额
    ,mon_cr_amt_cml number -- 本月贷方发生额
    ,quar_dr_amt_cml number -- 本季借方发生额
    ,quar_cr_amt_cml number -- 本季贷方发生额
    ,hyear_dr_amt_cml number -- 本半年借方发生额
    ,hyear_cr_amt_cml number -- 本半年贷方发生额
    ,year_dr_amt_cml number -- 本年借方发生额
    ,year_cr_amt_cml number -- 本年贷方发生额
    ,cur_day_dr_bal number -- 本日借方余额
    ,cur_day_cr_bal number -- 本日贷方余额
    ,mon_dr_bal_cml number -- 本月借方余额
    ,mon_cr_bal_cml number -- 本月贷方余额
    ,quar_dr_bal_cml number -- 本季借方余额
    ,quar_cr_bal_cml number -- 本季贷方余额
    ,hyear_dr_bal_cml number -- 本半年借方余额
    ,hyear_cr_bal_cml number -- 本半年贷方余额
    ,year_dr_bal_cml number -- 本年借方余额
    ,year_cr_bal_cml number -- 本年贷方余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_m_mfd_business_table_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_mfd_business_table_d is '表内经营状况表-计财部';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.date_id is '数据日期';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.branch_code is '机构编码';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.curr_code is '币种编码';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.acc_code is '科目代号';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.itemna is '科目名称';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.blncdn is '余额性质';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_day_dr_bal is '上日末借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_day_cr_bal is '上日末贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_mon_dr_bal is '上月末借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_mon_cr_bal is '上月末贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_quar_dr_bal is '上季末借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_quar_cr_bal is '上季末贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_hyear_dr_bal is '上半年末借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_hyear_cr_bal is '上半年末贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_year_dr_bal is '上年末借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.last_year_cr_bal is '上年末贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.cur_day_dr_amt is '本日借方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.cur_day_cr_amt is '本日贷方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.mon_dr_amt_cml is '本月借方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.mon_cr_amt_cml is '本月贷方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.quar_dr_amt_cml is '本季借方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.quar_cr_amt_cml is '本季贷方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.hyear_dr_amt_cml is '本半年借方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.hyear_cr_amt_cml is '本半年贷方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.year_dr_amt_cml is '本年借方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.year_cr_amt_cml is '本年贷方发生额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.cur_day_dr_bal is '本日借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.cur_day_cr_bal is '本日贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.mon_dr_bal_cml is '本月借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.mon_cr_bal_cml is '本月贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.quar_dr_bal_cml is '本季借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.quar_cr_bal_cml is '本季贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.hyear_dr_bal_cml is '本半年借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.hyear_cr_bal_cml is '本半年贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.year_dr_bal_cml is '本年借方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.year_cr_bal_cml is '本年贷方余额';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_mfd_business_table_d.etl_timestamp is 'ETL处理时间戳';
