/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_specialtradeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_specialtradeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_specialtradeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_specialtradeinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,sptxn_tp varchar2(9) -- 特殊交易类型:pd01fd01
    ,hpn_dt date -- 发生日期:pd01fr01
    ,exdat_mdf_monum number(22) -- 到期日期变更月数:pd01fs02
    ,cr_ln_sptxn_hpn_amt number(38,0) -- 征信贷款特殊交易发生金额:pd01fj01
    ,pbccrlnsptxn_dtl_rcrd varchar2(900) -- 人行征信贷款特殊交易明细记录:pd01fq01
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
grant select on ${iol_schema}.cqss_i_r_specialtradeinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_specialtradeinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_specialtradeinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_specialtradeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_specialtradeinfo is '二代借贷账户特殊交易信息';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.sptxn_tp is '特殊交易类型:pd01fd01';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.hpn_dt is '发生日期:pd01fr01';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.exdat_mdf_monum is '到期日期变更月数:pd01fs02';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.cr_ln_sptxn_hpn_amt is '征信贷款特殊交易发生金额:pd01fj01';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.pbccrlnsptxn_dtl_rcrd is '人行征信贷款特殊交易明细记录:pd01fq01';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_specialtradeinfo.etl_timestamp is 'ETL处理时间戳';
