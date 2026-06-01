/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wft_end_day_clarify_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wft_end_day_clarify_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wft_end_day_clarify_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wft_end_day_clarify_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,clarify_dt date -- 清分日期
    ,clarify_flow_num varchar2(100) -- 清分流水号
    ,mercht_id varchar2(100) -- 商户编号
    ,ibank_no varchar2(100) -- 联行号
    ,recver_name varchar2(750) -- 收款人名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,recvbl_acct_type_cd varchar2(60) -- 收款账户类型代码
    ,clarify_amt number(30) -- 清分金额
    ,memo varchar2(750) -- 摘要
    ,return_flow_num varchar2(100) -- 返回流水号
    ,return_sucs_flg varchar2(10) -- 返回成功标志
    ,return_info varchar2(750) -- 返回信息
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_wft_end_day_clarify_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wft_end_day_clarify_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wft_end_day_clarify_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wft_end_day_clarify_flow is '威富通日终清分流水';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.clarify_dt is '清分日期';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.clarify_flow_num is '清分流水号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.ibank_no is '联行号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.clarify_amt is '清分金额';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.memo is '摘要';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.return_flow_num is '返回流水号';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.return_sucs_flg is '返回成功标志';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wft_end_day_clarify_flow.etl_timestamp is 'ETL处理时间戳';
