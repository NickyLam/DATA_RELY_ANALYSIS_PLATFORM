/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_afterpaybusiness
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_afterpaybusiness
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_afterpaybusiness purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_afterpaybusiness(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,acctpid varchar2(135) -- 账户类型标识:pe01ad01
    ,inst_nm varchar2(360) -- 机构名称:pe01aq01
    ,af_py_acc_btp_cd varchar2(3) -- 后付费账户业务类型代码:pe01ad02
    ,stdt date -- 开始日期:pe01ar01
    ,pyf_stcd varchar2(2) -- 缴费状态代码:pe01ad03
    ,inarr_cost_amt number(38,0) -- 拖欠费用金额:pe01aj01
    ,bookentr_yrmo varchar2(11) -- 记账年月:pe01ar02
    ,rctly24etrsmopyf_rcrd varchar2(108) -- 最近24个月缴费记录:pe01aq02
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pe01zs01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_i_r_afterpaybusiness to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_afterpaybusiness to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_afterpaybusiness to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_afterpaybusiness to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_afterpaybusiness is '二代后付费业务信息';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.acctpid is '账户类型标识:pe01ad01';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.inst_nm is '机构名称:pe01aq01';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.af_py_acc_btp_cd is '后付费账户业务类型代码:pe01ad02';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.stdt is '开始日期:pe01ar01';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.pyf_stcd is '缴费状态代码:pe01ad03';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.inarr_cost_amt is '拖欠费用金额:pe01aj01';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.bookentr_yrmo is '记账年月:pe01ar02';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.rctly24etrsmopyf_rcrd is '最近24个月缴费记录:pe01aq02';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.annttn_and_sttmnt_num is '标注及声明个数:pe01zs01';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_afterpaybusiness.etl_timestamp is 'ETL处理时间戳';
