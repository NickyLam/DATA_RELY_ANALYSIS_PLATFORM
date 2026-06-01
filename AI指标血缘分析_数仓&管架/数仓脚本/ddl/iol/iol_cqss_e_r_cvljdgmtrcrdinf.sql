/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_cvljdgmtrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef020i01
    ,crjdgmtputorcdcourtnm varchar2(360) -- 征信判决立案法院名称(立案法院名称):ef020q01
    ,fileno varchar2(180) -- 案号:ef020i02
    ,cr_jdgmt_putonrcrd_dt date -- 征信判决立案日期(立案日期):ef020r01
    ,csoatn varchar2(180) -- 案由:ef020q02
    ,ltgtn_pos varchar2(2) -- 诉讼地位:ef020d01
    ,trial_prgm varchar2(2) -- 审判程序:ef020d02
    ,cr_jdgmt_ltgtn_obj varchar2(900) -- 征信判决诉讼标的(诉讼标的):ef020q03
    ,crjdgmt_ltgtn_obj_amt number(38,0) -- 征信判决诉讼标的金额(诉讼标的金额):ef020j01
    ,cr_jdgmt_endcs_mtdcd varchar2(90) -- 征信判决结案方式代码(结案方式):ef020d03
    ,cr_jdgmt_jdgmt_efdt date -- 征信判决判决生效日期(判决/调解生效日期):ef020r02
    ,cr_jdgmt_jdgmtrst varchar2(900) -- 征信判决判决结果(判决/调解结果):ef020q04
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
grant select on ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf is '民事判决记录信息';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_inf_id is '征信信息编号:ef020i01';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.crjdgmtputorcdcourtnm is '征信判决立案法院名称(立案法院名称):ef020q01';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.fileno is '案号:ef020i02';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_jdgmt_putonrcrd_dt is '征信判决立案日期(立案日期):ef020r01';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.csoatn is '案由:ef020q02';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.ltgtn_pos is '诉讼地位:ef020d01';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.trial_prgm is '审判程序:ef020d02';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_jdgmt_ltgtn_obj is '征信判决诉讼标的(诉讼标的):ef020q03';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.crjdgmt_ltgtn_obj_amt is '征信判决诉讼标的金额(诉讼标的金额):ef020j01';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_jdgmt_endcs_mtdcd is '征信判决结案方式代码(结案方式):ef020d03';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_jdgmt_jdgmt_efdt is '征信判决判决生效日期(判决/调解生效日期):ef020r02';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.cr_jdgmt_jdgmtrst is '征信判决判决结果(判决/调解结果):ef020q04';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf.etl_timestamp is 'ETL处理时间戳';
