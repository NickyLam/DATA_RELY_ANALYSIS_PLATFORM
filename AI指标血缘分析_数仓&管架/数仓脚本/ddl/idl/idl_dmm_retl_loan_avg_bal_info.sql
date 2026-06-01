/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_retl_loan_avg_bal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_retl_loan_avg_bal_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_loan_avg_bal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_loan_avg_bal_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_num varchar2(100) --借据号
    ,std_prod_id varchar2(60) --标准产品编号
    ,curr_mon_is_ovdue_flg varchar2(10) --当月是否逾期标志
    ,curr_mon_fir_ovdue_dt date --当月首次逾期日期
    ,m_avg_bal number(30,2) --月日均余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dmm_retl_loan_avg_bal_info to ${idl_schema};
grant select on ${idl_schema}.dmm_retl_loan_avg_bal_info to ${iel_schema};
grant select on ${idl_schema}.dmm_retl_loan_avg_bal_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_retl_loan_avg_bal_info is '零售贷款日均余额信息';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.dubil_num is '借据号';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.curr_mon_is_ovdue_flg is '当月是否逾期标志';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.curr_mon_fir_ovdue_dt is '当月首次逾期日期';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.m_avg_bal is '月日均余额';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_retl_loan_avg_bal_info.etl_timestamp is 'ETL处理时间戳';
