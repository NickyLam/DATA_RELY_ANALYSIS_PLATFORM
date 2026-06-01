/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_soe_info_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_soe_info_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_soe_info_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_soe_info_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,tran_dt date -- 交易日期
    ,soe_tran_status_cd varchar2(30) -- 结汇交易状态代码
    ,soe_tran_type_cd varchar2(30) -- 结汇交易类型代码
    ,bank_flow_num varchar2(100) -- 银行流水号
    ,soe_bus_type_cd varchar2(30) -- 结汇业务类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cty_rg_cd varchar2(30) -- 国家地区代码
    ,attach_cert_no varchar2(60) -- 补充证件号码
    ,cust_name varchar2(750) -- 客户名称
    ,soe_cap_attr_cd varchar2(30) -- 结汇资金属性代码
    ,curr_cd varchar2(30) -- 币种代码
    ,soe_amt number(30,2) -- 结汇金额
    ,soe_cny_acct_id varchar2(100) -- 结汇人民币账户编号
    ,soe_cap_modal_cd varchar2(30) -- 结汇资金形态代码
    ,indv_fx_acct_id varchar2(100) -- 个人外汇账户编号
    ,bus_trast_src_cd varchar2(30) -- 业务办理来源代码
    ,bus_trast_tm timestamp -- 业务办理时间
    ,input_rs_cd varchar2(30) -- 补录原因代码
    ,input_comnt varchar2(750) -- 补录说明
    ,remark varchar2(750) -- 备注
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,rtn_rcpt_bank_flow_num varchar2(100) -- 回执银行流水号
    ,ths_soe_usd_amt number(30,2) -- 本次结汇折美元金额
    ,tyr_soe_usd_surp_lmt number(30,2) -- 本年结汇折美元剩余额度
    ,indv_main_cls_status_cd varchar2(30) -- 个人主体分类状态代码
    ,issue_dt date -- 发布日期
    ,exp_dt date -- 到期日期
    ,issue_rs varchar2(1500) -- 发布原因
    ,issue_rs_cd varchar2(30) -- 发布原因代码
    ,err_cd varchar2(45) -- 错误码
    ,err_info_desc varchar2(1500) -- 错误信息描述
    ,init_node varchar2(45) -- 发起节点
    ,acpt_node varchar2(45) -- 接受节点
    ,send_tm timestamp -- 发送时间
    ,msg_id varchar2(100) -- 报文编号
    ,tran_info_desc varchar2(750) -- 交易信息描述
    ,src_sys_cd varchar2(30) -- 源系统代码
    ,sorc_sys_flow_num varchar2(100) -- 源系统流水号
    ,modif_rs_cd varchar2(30) -- 修改原因代码
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
grant select on ${iml_schema}.evt_soe_info_flow to ${icl_schema};
grant select on ${iml_schema}.evt_soe_info_flow to ${idl_schema};
grant select on ${iml_schema}.evt_soe_info_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_soe_info_flow is '结汇信息流水';
comment on column ${iml_schema}.evt_soe_info_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_soe_info_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_soe_info_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_soe_info_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_soe_info_flow.soe_tran_status_cd is '结汇交易状态代码';
comment on column ${iml_schema}.evt_soe_info_flow.soe_tran_type_cd is '结汇交易类型代码';
comment on column ${iml_schema}.evt_soe_info_flow.bank_flow_num is '银行流水号';
comment on column ${iml_schema}.evt_soe_info_flow.soe_bus_type_cd is '结汇业务类型代码';
comment on column ${iml_schema}.evt_soe_info_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_soe_info_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_soe_info_flow.cty_rg_cd is '国家地区代码';
comment on column ${iml_schema}.evt_soe_info_flow.attach_cert_no is '补充证件号码';
comment on column ${iml_schema}.evt_soe_info_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_soe_info_flow.soe_cap_attr_cd is '结汇资金属性代码';
comment on column ${iml_schema}.evt_soe_info_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_soe_info_flow.soe_amt is '结汇金额';
comment on column ${iml_schema}.evt_soe_info_flow.soe_cny_acct_id is '结汇人民币账户编号';
comment on column ${iml_schema}.evt_soe_info_flow.soe_cap_modal_cd is '结汇资金形态代码';
comment on column ${iml_schema}.evt_soe_info_flow.indv_fx_acct_id is '个人外汇账户编号';
comment on column ${iml_schema}.evt_soe_info_flow.bus_trast_src_cd is '业务办理来源代码';
comment on column ${iml_schema}.evt_soe_info_flow.bus_trast_tm is '业务办理时间';
comment on column ${iml_schema}.evt_soe_info_flow.input_rs_cd is '补录原因代码';
comment on column ${iml_schema}.evt_soe_info_flow.input_comnt is '补录说明';
comment on column ${iml_schema}.evt_soe_info_flow.remark is '备注';
comment on column ${iml_schema}.evt_soe_info_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_soe_info_flow.rtn_rcpt_bank_flow_num is '回执银行流水号';
comment on column ${iml_schema}.evt_soe_info_flow.ths_soe_usd_amt is '本次结汇折美元金额';
comment on column ${iml_schema}.evt_soe_info_flow.tyr_soe_usd_surp_lmt is '本年结汇折美元剩余额度';
comment on column ${iml_schema}.evt_soe_info_flow.indv_main_cls_status_cd is '个人主体分类状态代码';
comment on column ${iml_schema}.evt_soe_info_flow.issue_dt is '发布日期';
comment on column ${iml_schema}.evt_soe_info_flow.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_soe_info_flow.issue_rs is '发布原因';
comment on column ${iml_schema}.evt_soe_info_flow.issue_rs_cd is '发布原因代码';
comment on column ${iml_schema}.evt_soe_info_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_soe_info_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_soe_info_flow.init_node is '发起节点';
comment on column ${iml_schema}.evt_soe_info_flow.acpt_node is '接受节点';
comment on column ${iml_schema}.evt_soe_info_flow.send_tm is '发送时间';
comment on column ${iml_schema}.evt_soe_info_flow.msg_id is '报文编号';
comment on column ${iml_schema}.evt_soe_info_flow.tran_info_desc is '交易信息描述';
comment on column ${iml_schema}.evt_soe_info_flow.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_soe_info_flow.sorc_sys_flow_num is '源系统流水号';
comment on column ${iml_schema}.evt_soe_info_flow.modif_rs_cd is '修改原因代码';
comment on column ${iml_schema}.evt_soe_info_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_soe_info_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_soe_info_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_soe_info_flow.etl_timestamp is 'ETL处理时间戳';
