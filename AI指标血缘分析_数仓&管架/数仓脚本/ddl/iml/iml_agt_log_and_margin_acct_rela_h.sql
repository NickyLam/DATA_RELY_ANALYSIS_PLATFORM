/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_log_and_margin_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_log_and_margin_acct_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_log_and_margin_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_and_margin_acct_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,log_id varchar2(100) -- 保函编号
    ,margin_acct_curr_cd varchar2(30) -- 保证金账户币种代码
    ,margin_acct_num varchar2(60) -- 保证金账号
    ,margin_acct_sub_acct_num varchar2(60) -- 保证金账户子账号
    ,margin_prod_id varchar2(100) -- 保证金产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,froz_id varchar2(100) -- 冻结编号
    ,stop_pay_amt number(30,2) -- 止付金额
    ,stop_pay_ratio number(18,6) -- 止付比例
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
grant select on ${iml_schema}.agt_log_and_margin_acct_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_log_and_margin_acct_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_log_and_margin_acct_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_log_and_margin_acct_rela_h is '保函与保证金账户关系历史';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.log_id is '保函编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.margin_acct_curr_cd is '保证金账户币种代码';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.margin_acct_num is '保证金账号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.margin_acct_sub_acct_num is '保证金账户子账号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.margin_prod_id is '保证金产品编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.froz_id is '冻结编号';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.stop_pay_amt is '止付金额';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.stop_pay_ratio is '止付比例';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_log_and_margin_acct_rela_h.etl_timestamp is 'ETL处理时间戳';
