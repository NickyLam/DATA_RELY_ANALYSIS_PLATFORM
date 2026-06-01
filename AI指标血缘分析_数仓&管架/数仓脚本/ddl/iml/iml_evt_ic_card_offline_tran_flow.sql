/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ic_card_offline_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ic_card_offline_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ic_card_offline_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ic_card_offline_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,offline_flow_num varchar2(100) -- 脱机流水号
    ,offline_batch_no varchar2(60) -- 脱机批次号
    ,acct_id varchar2(100) -- 账户编号
    ,card_no varchar2(60) -- 卡号
    ,card_ser_num varchar2(30) -- 卡序列号
    ,app_idf varchar2(60) -- 应用标识符
    ,offline_tran_type_cd varchar2(30) -- 脱机交易类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,plat_tran_dt date -- 平台交易日期
    ,plat_tran_tm timestamp -- 平台交易时间
    ,unionpay_curr_cd varchar2(30) -- 银联币种代码
    ,unionpay_clear_dt date -- 银联清算日期
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,serv_status_descb varchar2(500) -- 服务状态描述
    ,tran_addr_desc varchar2(500) -- 交易地址描述
    ,elec_cash_acct_bal number(30,2) -- 电子现金账户余额
    ,other_amt number(30,2) -- 其他金额
    ,adj_entry_flg varchar2(10) -- 调账标志
    ,entry_flg varchar2(10) -- 记账标志
    ,enter_acct_dt date -- 入账日期
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,termn_flow_num varchar2(100) -- 终端流水号
    ,termn_cty_cd varchar2(30) -- 终端国家代码
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
grant select on ${iml_schema}.evt_ic_card_offline_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ic_card_offline_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ic_card_offline_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ic_card_offline_tran_flow is 'IC卡脱机交易流水';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.offline_flow_num is '脱机流水号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.offline_batch_no is '脱机批次号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.card_ser_num is '卡序列号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.app_idf is '应用标识符';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.offline_tran_type_cd is '脱机交易类型代码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.plat_tran_tm is '平台交易时间';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.unionpay_curr_cd is '银联币种代码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.unionpay_clear_dt is '银联清算日期';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.mercht_type_cd is '商户类型代码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.serv_status_descb is '服务状态描述';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.tran_addr_desc is '交易地址描述';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.elec_cash_acct_bal is '电子现金账户余额';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.other_amt is '其他金额';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.adj_entry_flg is '调账标志';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.entry_flg is '记账标志';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.enter_acct_dt is '入账日期';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.termn_flow_num is '终端流水号';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.termn_cty_cd is '终端国家代码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ic_card_offline_tran_flow.etl_timestamp is 'ETL处理时间戳';
