/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ibank_cap_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ibank_cap_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ibank_cap_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_cap_acct_bal_h(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,obj_id varchar2(60) -- 对象编号
    ,task_id varchar2(60) -- 任务编号
    ,stl_dt date -- 结算日期
    ,ext_cap_acct_id varchar2(60) -- 外部资金账户编号
    ,intnal_cap_acct_id varchar2(60) -- 内部资金账户编号
    ,curr_cd varchar2(10) -- 币种代码
    ,bal_type_cd varchar2(10) -- 余额类型代码
    ,bal number(38,8) -- 余额
    ,froz_bal number(38,8) -- 冻结余额
    ,aval_bal number(38,8) -- 可用余额
    ,open_dt date -- 开仓日期
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
grant select on ${iml_schema}.agt_ibank_cap_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_ibank_cap_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_ibank_cap_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ibank_cap_acct_bal_h is '同业资金账户余额历史';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.task_id is '任务编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.stl_dt is '结算日期';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.ext_cap_acct_id is '外部资金账户编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.bal_type_cd is '余额类型代码';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.bal is '余额';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.froz_bal is '冻结余额';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.aval_bal is '可用余额';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.open_dt is '开仓日期';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ibank_cap_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
