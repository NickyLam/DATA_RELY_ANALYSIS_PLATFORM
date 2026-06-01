/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_ibs_pre_proc_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow(
    etl_dt date
    ,evt_id varchar2(250)
    ,lp_id varchar2(100)
    ,pre_proc_id varchar2(100)
    ,init_pre_proc_id varchar2(100)
    ,bus_type_cd varchar2(30)
    ,pre_proc_status_cd varchar2(30)
    ,tran_flow_num varchar2(100)
    ,init_chn_cd varchar2(60)
    ,flow_bank_proc_flow_num varchar2(250)
    ,appl_dt date
    ,appl_org_id varchar2(100)
    ,acct_id varchar2(100)
    ,acct_name varchar2(500)
    ,cust_id varchar2(100)
    ,cust_name varchar2(500)
    ,cert_type_cd varchar2(30)
    ,cert_no varchar2(250)
    ,cert_name varchar2(500)
    ,agent_flg varchar2(10)
    ,agent_cert_type_cd varchar2(30)
    ,agent_cert_no varchar2(250)
    ,agent_cert_name varchar2(500)
    ,agent_cont_mode_cd varchar2(30)
    ,mobile_no varchar2(60)
    ,precon_id varchar2(100)
    ,wdraw_usage_and_reason varchar2(500)
    ,other_usage varchar2(1000)
    ,par_type_comb varchar2(500)
    ,par_type_amt_comb varchar2(1000)
    ,curr_cd varchar2(30)
    ,wdraw_lmt_comb varchar2(500)
    ,tran_type_cd varchar2(30)
    ,card_status_cd varchar2(30)
    ,bus_content_descb varchar2(1000)
    ,remark varchar2(2000)
    ,create_tm timestamp
    ,create_teller_id varchar2(100)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow is '智能网点预受理流水';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.pre_proc_id is '预受理编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.init_pre_proc_id is '原预受理编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.bus_type_cd is '业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.pre_proc_status_cd is '预受理状态代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.tran_flow_num is '交易流水号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.init_chn_cd is '发起渠道代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.flow_bank_proc_flow_num is '流程银行受理流水号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.appl_dt is '申请日期';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.appl_org_id is '申请机构编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.acct_id is '账户编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.acct_name is '账户名称';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.cust_name is '客户名称';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.cert_type_cd is '证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.cert_name is '证件名称';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.agent_flg is '代理标志';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.agent_cert_no is '代理人证件号码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.agent_cert_name is '代理人证件名称';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.agent_cont_mode_cd is '代理人联系方式代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.mobile_no is '手机号码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.precon_id is '预约ID';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.wdraw_usage_and_reason is '提现用途及理由';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.other_usage is '其他用途';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.par_type_comb is '券别';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.par_type_amt_comb is '券别金额组合';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.wdraw_lmt_comb is '提现金额';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.tran_type_cd is '交易类型代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.card_status_cd is '卡状态代码';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.bus_content_descb is '业务内容描述';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.remark is '备注';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.create_tm is '创建时间';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.create_teller_id is '创建柜员编号';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.start_dt is '开始日期';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.end_dt is '结束日期';
comment on column ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow.id_mark is '删除标识';
