/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ibank_curr_cap_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,obj_id varchar2(100) -- 对象编号
    ,task_id varchar2(100) -- 任务编号
    ,ext_cap_acct_id varchar2(100) -- 外部资金账户编号
    ,intnal_cap_acct_id varchar2(100) -- 内部资金账户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acct_bal number(38,8) -- 账户余额
    ,futures_margin number(38,8) -- 期货保证金
    ,open_tm timestamp -- 开仓时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ibank_curr_cap_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_ibank_curr_cap_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_ibank_curr_cap_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h is '同业活期资金账户余额历史';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.task_id is '任务编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.ext_cap_acct_id is '外部资金账户编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.acct_bal is '账户余额';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.futures_margin is '期货保证金';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.open_tm is '开仓时间';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ibank_curr_cap_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
