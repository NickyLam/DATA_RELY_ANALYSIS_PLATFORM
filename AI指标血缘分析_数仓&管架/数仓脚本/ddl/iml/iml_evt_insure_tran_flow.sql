/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_insure_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_insure_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_insure_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_insure_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,flow_num varchar2(100) -- 流水号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,ta_cd varchar2(30) -- TA代码
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(2000) -- 标准产品编号
    ,insure_pl_num varchar2(250) -- 保险单号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,tran_cd varchar2(30) -- 交易代码
    ,tran_cd_name varchar2(100) -- 交易代码名称
    ,bank_acct_id varchar2(60) -- 银行账户编号
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_id varchar2(60) -- 凭证编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee number(30,2) -- 手续费
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,operr_id varchar2(60) -- 操作员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(1500) -- 返回信息
    ,policy_dt date -- 保单日期
    ,policy_cfm_flow_num varchar2(100) -- 保单确认流水号
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,host_tran_cd varchar2(30) -- 主机交易代码
    ,host_return_code varchar2(45) -- 主机返回码
    ,host_return_info varchar2(1500) -- 主机返回信息
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_tm varchar2(30) -- 交易时间
    ,insure_print_id varchar2(100) -- 保险打印单编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_insure_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_insure_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_insure_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_insure_tran_flow is '保险交易流水';
comment on column ${iml_schema}.evt_insure_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_insure_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_insure_tran_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_insure_tran_flow.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_insure_tran_flow.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_insure_tran_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_insure_tran_flow.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.evt_insure_tran_flow.insure_pl_num is '保险单号';
comment on column ${iml_schema}.evt_insure_tran_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_insure_tran_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_insure_tran_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_cd_name is '交易代码名称';
comment on column ${iml_schema}.evt_insure_tran_flow.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_insure_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_insure_tran_flow.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_insure_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_insure_tran_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_insure_tran_flow.operr_id is '操作员编号';
comment on column ${iml_schema}.evt_insure_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_insure_tran_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_insure_tran_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_insure_tran_flow.policy_dt is '保单日期';
comment on column ${iml_schema}.evt_insure_tran_flow.policy_cfm_flow_num is '保单确认流水号';
comment on column ${iml_schema}.evt_insure_tran_flow.host_dt is '主机日期';
comment on column ${iml_schema}.evt_insure_tran_flow.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_insure_tran_flow.host_tran_cd is '主机交易代码';
comment on column ${iml_schema}.evt_insure_tran_flow.host_return_code is '主机返回码';
comment on column ${iml_schema}.evt_insure_tran_flow.host_return_info is '主机返回信息';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_insure_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_insure_tran_flow.insure_print_id is '保险打印单编号';
comment on column ${iml_schema}.evt_insure_tran_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_insure_tran_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_insure_tran_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_insure_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_insure_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_insure_tran_flow.etl_timestamp is 'ETL处理时间戳';
