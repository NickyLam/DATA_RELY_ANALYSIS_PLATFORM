/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_conl_bk_payoff_tran_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_conl_bk_payoff_tran_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_tran_h(
    evt_id varchar(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_id varchar2(100) -- 批次编号
    ,seq_num varchar2(100) -- 序号
    ,cust_id varchar2(100) -- 交易客户编号
    ,recver_name varchar2(250) -- 收款人名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,payer_name varchar2(250) -- 付款人名称
    ,payer_acct_id varchar2(100) -- 付款人账户编号
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_dt date -- 交易日期
    ,core_tran_dt date -- 核心交易日期
    ,core_batch_id varchar2(100) -- 核心批次编号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,remark varchar2(250) -- 备注
    ,recver_ibank_no varchar2(100) -- 收款方联行号
    ,recver_open_brac_name varchar2(500) -- 收款方开户网点名称
    ,mobile_no varchar2(60) -- 手机号码
    ,return_code varchar2(250) -- 返回码
    ,return_info varchar2(1000) -- 返回信息
    ,err_info varchar2(250) -- 错误信息
    ,bank_int_flg varchar2(10) -- 行内标志
    ,emply_id varchar2(100) -- 员工编号
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
grant select on ${iml_schema}.evt_conl_bk_payoff_tran_h to ${icl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_tran_h to ${idl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_tran_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_conl_bk_payoff_tran_h is '企业网银代发工资交易明细历史';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.batch_id is '批次编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.seq_num is '序号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.core_batch_id is '核心批次编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.remark is '备注';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.recver_ibank_no is '收款方联行号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.recver_open_brac_name is '收款方开户网点名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.return_code is '返回码';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.return_info is '返回信息';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.err_info is '错误信息';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.bank_int_flg is '行内标志';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.emply_id is '员工编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_conl_bk_payoff_tran_h.etl_timestamp is 'ETL处理时间戳';
