/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl 

dmm_cust_loan_ovdue_his_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_cust_loan_ovdue_his_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_cust_loan_ovdue_his_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_cust_loan_ovdue_his_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) --客户编号
	,max_ovdue_day_t number(10,0) --近30天内最大逾期天数
    ,max_ovdue_day_n number(10,0) --近90天内最大逾期天数
    ,ovdue_month_cnt number(10,0) --近180天内当月最大逾期天数
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- etl处理日期
   -- ,etl_timestamp timestamp -- etl处理时间戳
     )
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dmm_cust_loan_ovdue_his_info to ${iel_schema};
grant select on ${idl_schema}.dmm_cust_loan_ovdue_his_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_cust_loan_ovdue_his_info is '客户贷款逾期历史信息';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.cust_id is '客户编号';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.max_ovdue_day_t is '近30天内最大逾期天数';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.max_ovdue_day_n is '近90天内最大逾期天数';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.ovdue_month_cnt is '近180天内当月最大逾期天数';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_info.etl_timestamp is 'ETL处理时间戳';
