/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_civiljudgement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_civiljudgement
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_civiljudgement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_civiljudgement(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,crjdgmtputorcdcourtnm varchar2(360) -- 征信判决立案法院名称:pf02aq01
    ,cr_jdgmt_cs_rsn varchar2(180) -- 征信判决案件原因:pf02aq02
    ,cr_jdgmt_putonrcrd_dt date -- 征信判决立案日期:pf02ar01
    ,cr_jdgmt_endcs_mtdcd varchar2(90) -- 征信判决结案方式代码:pf02ad01
    ,cr_jdgmt_jdgmtrst varchar2(900) -- 征信判决判决结果:pf02aq03
    ,cr_jdgmt_jdgmt_efdt date -- 征信判决判决生效日期:pf02ar02
    ,cr_jdgmt_ltgtn_obj varchar2(900) -- 征信判决诉讼标的:pf02aq04
    ,crjdgmt_ltgtn_obj_amt number(38,0) -- 征信判决诉讼标的金额:pf02aj01
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf02zs01
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
grant select on ${iol_schema}.cqss_i_r_civiljudgement to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_civiljudgement to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_civiljudgement to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_civiljudgement to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_civiljudgement is '二代民事判决记录';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.crjdgmtputorcdcourtnm is '征信判决立案法院名称:pf02aq01';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_cs_rsn is '征信判决案件原因:pf02aq02';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_putonrcrd_dt is '征信判决立案日期:pf02ar01';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_endcs_mtdcd is '征信判决结案方式代码:pf02ad01';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_jdgmtrst is '征信判决判决结果:pf02aq03';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_jdgmt_efdt is '征信判决判决生效日期:pf02ar02';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.cr_jdgmt_ltgtn_obj is '征信判决诉讼标的:pf02aq04';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.crjdgmt_ltgtn_obj_amt is '征信判决诉讼标的金额:pf02aj01';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.annttn_and_sttmnt_num is '标注及声明个数:pf02zs01';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_civiljudgement.etl_timestamp is 'ETL处理时间戳';
