/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_payoff_sal_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_payoff_sal_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_payoff_sal_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_payoff_sal_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,batch_flow_num varchar2(100) -- 批次流水号
    ,seq_num varchar2(60) -- 序号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(750) -- 账户名称
    ,tran_amt number(30,2) -- 交易金额
    ,acct_resp_code varchar2(90) -- 账户响应码
    ,acct_num_err_info varchar2(750) -- 账号错误信息
    ,host_tran_flow_num varchar2(100) -- 主机交易流水号
    ,host_tran_dt date -- 主机交易日期
    ,resp_code varchar2(90) -- 响应码
    ,resp_info varchar2(1500) -- 响应信息
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
grant select on ${iml_schema}.evt_payoff_sal_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_payoff_sal_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_payoff_sal_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_payoff_sal_dtl is '代发工资明细';
comment on column ${iml_schema}.evt_payoff_sal_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_payoff_sal_dtl.batch_flow_num is '批次流水号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.seq_num is '序号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_payoff_sal_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_payoff_sal_dtl.acct_resp_code is '账户响应码';
comment on column ${iml_schema}.evt_payoff_sal_dtl.acct_num_err_info is '账号错误信息';
comment on column ${iml_schema}.evt_payoff_sal_dtl.host_tran_flow_num is '主机交易流水号';
comment on column ${iml_schema}.evt_payoff_sal_dtl.host_tran_dt is '主机交易日期';
comment on column ${iml_schema}.evt_payoff_sal_dtl.resp_code is '响应码';
comment on column ${iml_schema}.evt_payoff_sal_dtl.resp_info is '响应信息';
comment on column ${iml_schema}.evt_payoff_sal_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_payoff_sal_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_payoff_sal_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_payoff_sal_dtl.etl_timestamp is 'ETL处理时间戳';
