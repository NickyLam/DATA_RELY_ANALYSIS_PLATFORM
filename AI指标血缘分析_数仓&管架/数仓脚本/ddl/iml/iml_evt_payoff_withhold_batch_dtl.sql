/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_payoff_withhold_batch_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_payoff_withhold_batch_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_payoff_withhold_batch_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_payoff_withhold_batch_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,batch_id varchar2(100) -- 批次编号
    ,deduct_seq_num varchar2(60) -- 扣款序号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,amt number(30,2) -- 金额
    ,acct_num_resp_code varchar2(30) -- 账号响应码
    ,acct_num_resp_info varchar2(100) -- 账号响应信息
    ,host_flow_num varchar2(100) -- 主机流水号
    ,host_tran_dt date -- 主机交易日期
    ,host_return_code varchar2(45) -- 主机返回码
    ,host_return_info varchar2(1500) -- 主机返回信息
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
grant select on ${iml_schema}.evt_payoff_withhold_batch_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_payoff_withhold_batch_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_payoff_withhold_batch_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_payoff_withhold_batch_dtl is '代发代扣批次明细';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.deduct_seq_num is '扣款序号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.amt is '金额';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.acct_num_resp_code is '账号响应码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.acct_num_resp_info is '账号响应信息';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.host_tran_dt is '主机交易日期';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.host_return_code is '主机返回码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.host_return_info is '主机返回信息';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_dtl.etl_timestamp is 'ETL处理时间戳';
