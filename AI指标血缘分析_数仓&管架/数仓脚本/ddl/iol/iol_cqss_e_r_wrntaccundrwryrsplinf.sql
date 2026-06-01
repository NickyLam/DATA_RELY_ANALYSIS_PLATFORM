/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_wrntaccundrwryrsplinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,infrpt_dt date -- 信息报告日期:ed04br01
    ,acc_avy_st varchar2(2) -- 账户活动状态:ed04bd01
    ,bal number(38,0) -- 余额:ed04bj01
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed04bd02
    ,entp_cr_rskesr number(38,0) -- 企业征信风险敞口(风险敞口):ed04bj02
    ,sbstrepy_or_adcsh_ind varchar2(2) -- 代偿(垫款)标志:ed04bd03
    ,jnt_dbt_idr varchar2(2) -- 共同债务标识:ed04bd04
    ,cls_dt date -- 关闭日期:ed04br02
    ,crt_dt_tm date -- 创建日期时间
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
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
grant select on ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf is '担保账户在保责任信息';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.infrpt_dt is '信息报告日期:ed04br01';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.acc_avy_st is '账户活动状态:ed04bd01';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.bal is '余额:ed04bj01';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed04bd02';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.entp_cr_rskesr is '企业征信风险敞口(风险敞口):ed04bj02';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.sbstrepy_or_adcsh_ind is '代偿(垫款)标志:ed04bd03';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.jnt_dbt_idr is '共同债务标识:ed04bd04';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.cls_dt is '关闭日期:ed04br02';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf.etl_timestamp is 'ETL处理时间戳';
