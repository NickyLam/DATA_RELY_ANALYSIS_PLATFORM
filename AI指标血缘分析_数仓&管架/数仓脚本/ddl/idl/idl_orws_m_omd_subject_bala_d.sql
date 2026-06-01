/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_subject_bala_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_subject_bala_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_subject_bala_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_subject_bala_d(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 日期
    ,curr_code varchar2(3) -- 币种代码
    ,branch_code varchar2(16) -- 机构代码
    ,branch_name varchar2(50) -- 机构名称
    ,itemcd varchar2(20) -- 科目代码
    ,itemname varchar2(50) -- 科目名称
    ,cur_day_dr_bal number -- 借方余额
    ,cur_day_cr_bal number -- 贷方余额
    ,processor varchar2(400) -- 跟踪处理情况
    ,cur_day_dr_amt number -- 本期借方发生额
    ,cur_day_cr_amt number -- 本期货方发生额
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
grant select on ${idl_schema}.orws_m_omd_subject_bala_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_subject_bala_d is '科目挂账余额监控统计表';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.date_id is '日期';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.curr_code is '币种代码';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.branch_code is '机构代码';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.branch_name is '机构名称';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.itemcd is '科目代码';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.itemname is '科目名称';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.cur_day_dr_bal is '借方余额';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.cur_day_cr_bal is '贷方余额';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.processor is '跟踪处理情况';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.cur_day_dr_amt is '本期借方发生额';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.cur_day_cr_amt is '本期货方发生额';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_subject_bala_d.etl_timestamp is 'ETL处理时间戳';
