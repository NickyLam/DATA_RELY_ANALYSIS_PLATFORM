/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_digit_curr_fin_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_digit_curr_fin_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_digit_curr_fin_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_digit_curr_fin_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sys_id varchar2(100) -- 系统编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,midgrod_tran_dt date -- 中台交易日期
    ,midgrod_tran_code varchar2(100) -- 中台交易码
    ,fin_tran_code varchar2(100) -- 金融交易码
    ,fin_tran_dt date -- 金融交易日期
    ,fin_flow_num varchar2(100) -- 金融流水号
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,msg_type varchar2(100) -- 报文类型
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,tran_amt number(30,2) -- 交易金额
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,pay_flow_num varchar2(100) -- 支付流水号
    ,payer_acct_id varchar2(2000) -- 付款人账户编号
    ,payer_name varchar2(2000) -- 付款人名称
    ,recver_acct_id varchar2(2000) -- 收款人账户编号
    ,recver_name varchar2(2000) -- 收款人名称
    ,entry_id varchar2(100) -- 记账分录编号
    ,check_entry_dt date -- 对账日期
    ,check_entry_status_cd varchar2(30) -- 对账状态代码
    ,revs_rs varchar2(2000) -- 冲正原因
    ,init_pay_flow_num varchar2(100) -- 原支付流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,err_cd varchar2(100) -- 错误码
    ,return_info varchar2(2000) -- 返回信息
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.evt_digit_curr_fin_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_digit_curr_fin_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_digit_curr_fin_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_digit_curr_fin_tran_flow is '数字货币金融交易流水';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.fin_tran_code is '金融交易码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.fin_tran_dt is '金融交易日期';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.fin_flow_num is '金融流水号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.msg_type is '报文类型';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.pay_flow_num is '支付流水号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.entry_id is '记账分录编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.revs_rs is '冲正原因';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.init_pay_flow_num is '原支付流水号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_digit_curr_fin_tran_flow.etl_timestamp is 'ETL处理时间戳';
