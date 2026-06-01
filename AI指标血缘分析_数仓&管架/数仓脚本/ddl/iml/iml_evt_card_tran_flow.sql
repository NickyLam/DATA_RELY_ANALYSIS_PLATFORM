/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_card_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_card_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_card_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_card_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,card_no varchar2(60) -- 卡号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,mercht_id varchar2(100) -- 商户编号
    ,unionpay_dt date -- 银联日期
    ,host_dt date -- 主机日期
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,lmt_id varchar2(100) -- 限制编号
    ,card_tran_status_cd varchar2(30) -- 卡交易状态代码
    ,remark varchar2(500) -- 备注
    ,termn_flow_num varchar2(100) -- 终端流水号
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
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
grant select on ${iml_schema}.evt_card_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_card_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_card_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_card_tran_flow is '卡片交易流水';
comment on column ${iml_schema}.evt_card_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_card_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_card_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_card_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_card_tran_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_card_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_card_tran_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_card_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_card_tran_flow.unionpay_dt is '银联日期';
comment on column ${iml_schema}.evt_card_tran_flow.host_dt is '主机日期';
comment on column ${iml_schema}.evt_card_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_card_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_card_tran_flow.lmt_id is '限制编号';
comment on column ${iml_schema}.evt_card_tran_flow.card_tran_status_cd is '卡交易状态代码';
comment on column ${iml_schema}.evt_card_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_card_tran_flow.termn_flow_num is '终端流水号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_card_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_card_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_card_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_card_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_card_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_card_tran_flow.etl_timestamp is 'ETL处理时间戳';
