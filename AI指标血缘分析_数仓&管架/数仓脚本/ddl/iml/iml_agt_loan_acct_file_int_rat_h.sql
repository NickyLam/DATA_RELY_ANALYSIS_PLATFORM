/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_file_int_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_file_int_rat_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_file_int_rat_h(
    cust_id varchar2(100) -- 客户编号
    ,agt_id varchar2(250) -- 协议编号
    ,acct_id varchar2(100) -- 账户编号
    ,seq_num varchar2(60) -- 序号
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,lp_id varchar2(100) -- 法人编号
    ,and_begin_day_diff_between_days number(10) -- 与起始日相差天数
    ,invalid_dt number(10) -- 失效天数
    ,acrs_mon_int_rat number(18,8) -- 跨月利率
    ,not_acrs_mon_int_rat number(18,8) -- 不跨月利率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_acct_file_int_rat_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_file_int_rat_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_file_int_rat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_file_int_rat_h is '贷款账户靠档利率历史';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.seq_num is '序号';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.and_begin_day_diff_between_days is '与起始日相差天数';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.invalid_dt is '失效天数';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.acrs_mon_int_rat is '跨月利率';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.not_acrs_mon_int_rat is '不跨月利率';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_file_int_rat_h.etl_timestamp is 'ETL处理时间戳';
