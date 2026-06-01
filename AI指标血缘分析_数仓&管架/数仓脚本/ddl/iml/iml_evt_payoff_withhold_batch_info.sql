/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_payoff_withhold_batch_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_payoff_withhold_batch_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_payoff_withhold_batch_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_payoff_withhold_batch_info(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_dt date -- 批次日期
    ,batch_flow_num varchar2(100) -- 批次流水号
    ,sign_id varchar2(100) -- 签约编号
    ,batch_id varchar2(100) -- 批次编号
    ,batch_data_doc_name varchar2(500) -- 批次数据文件名
    ,memo_cd varchar2(30) -- 摘要代码
    ,memo_comnt varchar2(150) -- 摘要说明
    ,sign_type_cd varchar2(30) -- 签约类型代码
    ,deduct_acct_id varchar2(100) -- 扣款账户编号
    ,deduct_acct_name varchar2(750) -- 扣款账户名称
    ,tot number(10) -- 总笔数
    ,tot_amt number(30,2) -- 总金额
    ,sucs_cnt number(10) -- 成功笔数
    ,sucs_amt number(30,2) -- 成功金额
    ,fail_cnt number(10) -- 失败笔数
    ,fail_amt number(30,2) -- 失败金额
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,err_info_desc varchar2(375) -- 错误信息描述
    ,actl_deduct_acct_id varchar2(100) -- 实际扣款账户编号
    ,midgrod_tran_flow_num varchar2(100) -- 中台交易流水号
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
grant select on ${iml_schema}.evt_payoff_withhold_batch_info to ${icl_schema};
grant select on ${iml_schema}.evt_payoff_withhold_batch_info to ${idl_schema};
grant select on ${iml_schema}.evt_payoff_withhold_batch_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_payoff_withhold_batch_info is '代发代扣批次信息';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.batch_flow_num is '批次流水号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.sign_id is '签约编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.batch_id is '批次编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.batch_data_doc_name is '批次数据文件名';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.memo_cd is '摘要代码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.sign_type_cd is '签约类型代码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.deduct_acct_id is '扣款账户编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.deduct_acct_name is '扣款账户名称';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.tot is '总笔数';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.tot_amt is '总金额';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.sucs_amt is '成功金额';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.fail_amt is '失败金额';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.actl_deduct_acct_id is '实际扣款账户编号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.midgrod_tran_flow_num is '中台交易流水号';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_payoff_withhold_batch_info.etl_timestamp is 'ETL处理时间戳';
