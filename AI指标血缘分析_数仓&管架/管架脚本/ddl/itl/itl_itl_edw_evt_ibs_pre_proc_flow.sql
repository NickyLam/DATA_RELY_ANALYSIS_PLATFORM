/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_ibs_pre_proc_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,pre_proc_id varchar2(100) -- 预受理编号
    ,init_pre_proc_id varchar2(100) -- 原预受理编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,pre_proc_status_cd varchar2(30) -- 预受理状态代码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,init_chn_cd varchar2(60) -- 发起渠道代码
    ,flow_bank_proc_flow_num varchar2(250) -- 流程银行受理流水号
    ,appl_dt date -- 申请日期
    ,appl_org_id varchar2(100) -- 申请机构编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(500) -- 账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,cert_name varchar2(500) -- 证件名称
    ,agent_flg varchar2(10) -- 代理标志
    ,agent_cert_type_cd varchar2(30) -- 代理人证件类型代码
    ,agent_cert_no varchar2(250) -- 代理人证件号码
    ,agent_cert_name varchar2(500) -- 代理人证件名称
    ,agent_cont_mode_cd varchar2(30) -- 代理人联系方式代码
    ,mobile_no varchar2(60) -- 手机号码
    ,precon_id varchar2(100) -- 预约ID
    ,wdraw_usage_and_reason varchar2(500) -- 提现用途及理由
    ,other_usage varchar2(1000) -- 其他用途
    ,par_type_comb varchar2(500) -- 券别组合
    ,par_type_amt_comb varchar2(1000) -- 券别金额组合
    ,curr_cd varchar2(30) -- 币种代码
    ,wdraw_lmt_comb varchar2(500) -- 提现金额组合
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,card_status_cd varchar2(30) -- 卡状态代码
    ,bus_content_descb varchar2(1000) -- 业务内容描述
    ,remark varchar2(2000) -- 备注
    ,create_tm timestamp -- 创建时间
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow is '智能网点预受理流水';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.pre_proc_id is '预受理编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.init_pre_proc_id is '原预受理编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.bus_type_cd is '业务类型代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.pre_proc_status_cd is '预受理状态代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.init_chn_cd is '发起渠道代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.flow_bank_proc_flow_num is '流程银行受理流水号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.appl_dt is '申请日期';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.appl_org_id is '申请机构编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.acct_id is '账户编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.acct_name is '账户名称';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.cust_name is '客户名称';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.cert_type_cd is '证件类型代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.cert_no is '证件号码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.cert_name is '证件名称';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.agent_flg is '代理标志';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.agent_cert_no is '代理人证件号码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.agent_cert_name is '代理人证件名称';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.agent_cont_mode_cd is '代理人联系方式代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.mobile_no is '手机号码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.precon_id is '预约ID';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.wdraw_usage_and_reason is '提现用途及理由';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.other_usage is '其他用途';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.par_type_comb is '券别组合';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.par_type_amt_comb is '券别金额组合';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.wdraw_lmt_comb is '提现金额组合';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.tran_type_cd is '交易类型代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.card_status_cd is '卡状态代码';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.bus_content_descb is '业务内容描述';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.remark is '备注';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.create_tm is '创建时间';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.create_teller_id is '创建柜员编号';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow.etl_timestamp is 'ETL处理时间戳';
