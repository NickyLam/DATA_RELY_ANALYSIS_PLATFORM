/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_pool_margin_stop_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_pool_margin_stop_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_pool_margin_stop_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_pool_margin_stop_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,stop_pay_dtl_id varchar2(100) -- 止付明细编号
    ,acct_id varchar2(100) -- 账户编号
    ,sub_acct_id varchar2(100) -- 子户编号
    ,stop_pay_status_cd varchar2(30) -- 止付状态代码
    ,pymc_status_cd varchar2(30) -- 备款状态代码
    ,stop_pay_amt number(30,2) -- 止付金额
    ,stop_pay_flow_num varchar2(100) -- 止付流水号
    ,solu_pay_flow_num varchar2(100) -- 解付流水号
    ,stop_pay_dt date -- 止付日期
    ,solu_pay_dt date -- 解付日期
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
grant select on ${iml_schema}.evt_bill_pool_margin_stop_h to ${icl_schema};
grant select on ${iml_schema}.evt_bill_pool_margin_stop_h to ${idl_schema};
grant select on ${iml_schema}.evt_bill_pool_margin_stop_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_pool_margin_stop_h is '票据池保证金止付历史';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.stop_pay_dtl_id is '止付明细编号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.acct_id is '账户编号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.sub_acct_id is '子户编号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.stop_pay_status_cd is '止付状态代码';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.pymc_status_cd is '备款状态代码';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.stop_pay_amt is '止付金额';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.stop_pay_flow_num is '止付流水号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.solu_pay_flow_num is '解付流水号';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.stop_pay_dt is '止付日期';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.solu_pay_dt is '解付日期';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_pool_margin_stop_h.etl_timestamp is 'ETL处理时间戳';
