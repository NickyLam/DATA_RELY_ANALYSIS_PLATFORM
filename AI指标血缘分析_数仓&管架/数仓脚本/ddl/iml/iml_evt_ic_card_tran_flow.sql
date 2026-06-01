/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ic_card_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ic_card_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ic_card_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ic_card_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,plat_tran_flow_num varchar2(100) -- 平台交易流水号
    ,plat_tran_dt date -- 平台交易日期
    ,tran_chn_id varchar2(100) -- 交易渠道编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,card_no varchar2(60) -- 卡号
    ,card_ser_num varchar2(60) -- 卡序列号
    ,tran_code varchar2(30) -- 交易码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,ic_card_tran_status_cd varchar2(30) -- IC卡交易状态代码
    ,tran_status_code varchar2(60) -- 交易状态码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,serv_status_descb varchar2(500) -- 服务状态描述
    ,app_idf varchar2(60) -- 应用标识符
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,mercht_id varchar2(100) -- 商户编号
    ,clear_dt date -- 清算日期
    ,cntpty_acct_num varchar2(60) -- 交易对手账号
    ,elec_cash_acct_bal number(30,2) -- 电子现金账户余额
    ,cust_name varchar2(500) -- 客户名称
    ,cust_cert_type_cd varchar2(30) -- 客户证件类型代码
    ,cust_cert_no varchar2(60) -- 客户证件号码
    ,public_agent_name varchar2(500) -- 代办人姓名
    ,public_agent_cert_type_cd varchar2(30) -- 代办人证件类型代码
    ,public_agent_cert_no varchar2(60) -- 代办人证件号码
    ,remark varchar2(750) -- 备注
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
grant select on ${iml_schema}.evt_ic_card_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ic_card_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ic_card_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ic_card_tran_flow is 'IC卡交易流水';
comment on column ${iml_schema}.evt_ic_card_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.plat_tran_flow_num is '平台交易流水号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_chn_id is '交易渠道编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.card_ser_num is '卡序列号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ic_card_tran_flow.ic_card_tran_status_cd is 'IC卡交易状态代码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_status_code is '交易状态码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ic_card_tran_flow.serv_status_descb is '服务状态描述';
comment on column ${iml_schema}.evt_ic_card_tran_flow.app_idf is '应用标识符';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_ic_card_tran_flow.cntpty_acct_num is '交易对手账号';
comment on column ${iml_schema}.evt_ic_card_tran_flow.elec_cash_acct_bal is '电子现金账户余额';
comment on column ${iml_schema}.evt_ic_card_tran_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_ic_card_tran_flow.cust_cert_type_cd is '客户证件类型代码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.cust_cert_no is '客户证件号码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.public_agent_name is '代办人姓名';
comment on column ${iml_schema}.evt_ic_card_tran_flow.public_agent_cert_type_cd is '代办人证件类型代码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.public_agent_cert_no is '代办人证件号码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_ic_card_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ic_card_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ic_card_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ic_card_tran_flow.etl_timestamp is 'ETL处理时间戳';
