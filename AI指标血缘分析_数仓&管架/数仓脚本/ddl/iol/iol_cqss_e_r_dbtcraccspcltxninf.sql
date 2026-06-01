/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dbtcraccspcltxninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dbtcraccspcltxninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dbtcraccspcltxninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dbtcraccspcltxninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,sptxn_tp varchar2(3) -- 特殊交易类型(交易类型):ed01cd01
    ,txn_dt date -- 交易日期:ed01cr01
    ,cr_ln_sptxn_hpn_amt number(38,0) -- 征信贷款特殊交易发生金额(交易金额):ed01cj01
    ,exdat_mdf_monum number(22) -- 到期日期变更月数:ed01cs02
    ,tndtl_inf varchar2(900) -- 交易明细信息:ed01cq01
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
grant select on ${iol_schema}.cqss_e_r_dbtcraccspcltxninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccspcltxninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccspcltxninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccspcltxninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dbtcraccspcltxninf is '借贷账户特定交易信息';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.sptxn_tp is '特殊交易类型(交易类型):ed01cd01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.txn_dt is '交易日期:ed01cr01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.cr_ln_sptxn_hpn_amt is '征信贷款特殊交易发生金额(交易金额):ed01cj01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.exdat_mdf_monum is '到期日期变更月数:ed01cs02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.tndtl_inf is '交易明细信息:ed01cq01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dbtcraccspcltxninf.etl_timestamp is 'ETL处理时间戳';
