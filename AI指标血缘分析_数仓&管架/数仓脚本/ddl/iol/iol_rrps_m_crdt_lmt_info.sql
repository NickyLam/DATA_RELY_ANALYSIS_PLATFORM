/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rrps_m_crdt_lmt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rrps_m_crdt_lmt_info
whenever sqlerror continue none;
drop table ${iol_schema}.rrps_m_crdt_lmt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rrps_m_crdt_lmt_info(
    data_dt varchar2(8) -- 数据日期
    ,lgl_rep_id varchar2(200) -- 法人编号
    ,prim_crdt_cont_id varchar2(200) -- 主授信合同编号
    ,prim_crdt_cont_nm varchar2(750) -- 主授信合同名称
    ,cust_id varchar2(200) -- 客户编号
    ,org_id varchar2(200) -- 机构编号
    ,cur varchar2(3) -- 币种
    ,crdt_total_lmt number(30,2) -- 授信总额度
    ,aldy_use_lmt number(30,2) -- 已用额度
    ,exp_crdt_lmt number(30,2) -- 敞口授信额度
    ,exp_aldy_use_lmt number(30,2) -- 敞口已用额度
    ,opr_crdt_tot_amt number(30,2) -- 经营授信总额
    ,opr_aldy_use_crdt_tot_amt number(30,2) -- 经营已用授信总额
    ,hse_crdt_lmt number(30,2) -- 住房授信额度
    ,hse_aldy_use_crdt_lmt number(30,2) -- 住房已用授信额度
    ,car_loan_crdt_lmt number(30,2) -- 车贷授信额度
    ,car_loan_aldy_use_crdt_lmt number(30,2) -- 车贷已用授信额度
    ,sl_crdt_lmt number(30,2) -- 助学授信额度
    ,sl_aldy_use_crdt_lmt number(30,2) -- 助学已用授信额度
    ,oth_cnsmp_crdt_lmt number(30,2) -- 其他消费授信额度
    ,oth_cnsmp_aldy_use_crdt_lmt number(30,2) -- 其他消费已用授信额度
    ,crdt_stat varchar2(10) -- 授信状态
    ,first_crdt_dt varchar2(8) -- 首次授信日期
    ,dept_line varchar2(750) -- 部门条线
    ,data_src varchar2(500) -- 数据来源
    ,oth_in_crdt_amt number(30,2) -- 其他表内授信金额
    ,out_crdt_amt number(30,2) -- 表外授信金额
    ,bill_acpt_crdt_amt number(30,2) -- 票据承兑授信金额
    ,crdt_app_dt varchar2(8) -- 授信申请日期
    ,crdt_start_dt varchar2(8) -- 授信开始日期
    ,crdt_exp_dt varchar2(8) -- 授信到期日期
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
grant select on ${iol_schema}.rrps_m_crdt_lmt_info to ${iml_schema};
grant select on ${iol_schema}.rrps_m_crdt_lmt_info to ${icl_schema};
grant select on ${iol_schema}.rrps_m_crdt_lmt_info to ${idl_schema};
grant select on ${iol_schema}.rrps_m_crdt_lmt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rrps_m_crdt_lmt_info is '授信额度主表';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.data_dt is '数据日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.lgl_rep_id is '法人编号';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.prim_crdt_cont_id is '主授信合同编号';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.prim_crdt_cont_nm is '主授信合同名称';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.cust_id is '客户编号';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.org_id is '机构编号';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.cur is '币种';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.crdt_total_lmt is '授信总额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.aldy_use_lmt is '已用额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.exp_crdt_lmt is '敞口授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.exp_aldy_use_lmt is '敞口已用额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.opr_crdt_tot_amt is '经营授信总额';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.opr_aldy_use_crdt_tot_amt is '经营已用授信总额';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.hse_crdt_lmt is '住房授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.hse_aldy_use_crdt_lmt is '住房已用授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.car_loan_crdt_lmt is '车贷授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.car_loan_aldy_use_crdt_lmt is '车贷已用授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.sl_crdt_lmt is '助学授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.sl_aldy_use_crdt_lmt is '助学已用授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.oth_cnsmp_crdt_lmt is '其他消费授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.oth_cnsmp_aldy_use_crdt_lmt is '其他消费已用授信额度';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.crdt_stat is '授信状态';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.first_crdt_dt is '首次授信日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.dept_line is '部门条线';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.data_src is '数据来源';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.oth_in_crdt_amt is '其他表内授信金额';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.out_crdt_amt is '表外授信金额';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.bill_acpt_crdt_amt is '票据承兑授信金额';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.crdt_app_dt is '授信申请日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.crdt_start_dt is '授信开始日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.crdt_exp_dt is '授信到期日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rrps_m_crdt_lmt_info.etl_timestamp is 'ETL处理时间戳';
