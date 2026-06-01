/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_agent_consmt_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_agent_consmt_tran_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_agent_consmt_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_tran_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(60) -- TA代码
    ,ta_cfm_dt date -- TA确认日期
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,appl_form_id varchar2(60) -- 申请单编号
    ,init_appl_form_id varchar2(60) -- 原申请单编号
    ,cust_id varchar2(60) -- 客户编号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,bank_acct_id varchar2(60) -- 银行账户编号
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_name varchar2(450) -- 产品名称
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,consmt_bus_type_cd varchar2(10) -- 代销业务类型代码
    ,sell_mode_cd varchar2(10) -- 销售模式代码
    ,bus_cd varchar2(10) -- 业务代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,curr_cd varchar2(10) -- 币种代码
    ,divd_way_cd varchar2(10) -- 分红方式代码
    ,huge_redem_proc_cd varchar2(10) -- 巨额赎回处理代码
    ,tran_chn_cd varchar2(10) -- 交易渠道代码
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_cd varchar2(10) -- 交易代码
    ,appl_lot number(30,2) -- 申请份额
    ,appl_amt number(30,2) -- 申请金额
    ,cfm_lot number(30,2) -- 确认份额
    ,cfm_amt number(30,2) -- 确认金额
    ,prod_nv number(30,8) -- 产品净值
    ,tran_comm_fee number(30,2) -- 交易手续费
    ,tran_agent_fee number(30,2) -- 交易代理费
    ,tran_return_code varchar2(90) -- 交易返回码
    ,tran_return_info varchar2(300) -- 交易返回信息
    ,tran_subrch_id varchar2(60) -- 交易支行编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,tran_happ_dt date -- 交易发生日期
    ,tran_happ_tm timestamp(6) -- 交易发生时间
    ,tran_belong_org_id varchar2(60) -- 交易归属机构编号
    ,comb_sell_flag varchar2(10) -- 组合销售标志
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_agent_consmt_tran_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_agent_consmt_tran_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_agent_consmt_tran_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_agent_consmt_tran_dtl is '代理代销交易明细';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.ta_cd is 'TA代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.ta_cfm_dt is 'TA确认日期';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.rela_flow_num is '关联流水号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.appl_form_id is '申请单编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.init_appl_form_id is '原申请单编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.prod_acct_id is '产品账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.bank_acct_id is '银行账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.consmt_bus_type_cd is '代销业务类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.sell_mode_cd is '销售模式代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.bus_cd is '业务代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.divd_way_cd is '分红方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.huge_redem_proc_cd is '巨额赎回处理代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_chn_cd is '交易渠道代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_cd is '交易代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.appl_lot is '申请份额';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.appl_amt is '申请金额';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.cfm_lot is '确认份额';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.cfm_amt is '确认金额';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.prod_nv is '产品净值';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_comm_fee is '交易手续费';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_agent_fee is '交易代理费';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_return_code is '交易返回码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_return_info is '交易返回信息';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_subrch_id is '交易支行编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_teller_id is '交易柜员编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.auth_teller_id is '授权柜员编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_happ_dt is '交易发生日期';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_happ_tm is '交易发生时间';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.tran_belong_org_id is '交易归属机构编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.comb_sell_flag is '组合销售标志';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.comb_prod_id is '组合产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_agent_consmt_tran_dtl.etl_timestamp is 'ETL处理时间戳';
