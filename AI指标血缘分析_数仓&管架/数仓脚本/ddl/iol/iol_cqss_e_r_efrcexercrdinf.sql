/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_efrcexercrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_efrcexercrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_efrcexercrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_efrcexercrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef030i01
    ,exec_court_nm varchar2(360) -- 执行法院名称:ef030q01
    ,fileno varchar2(180) -- 案号:ef030i02
    ,putonrcrd_dt date -- 立案日期:ef030r01
    ,exec_csoatn varchar2(180) -- 执行案由:ef030q02
    ,cr_efrcexe_ayexc_obj varchar2(900) -- 征信强制执行申请执行标的(申请执行标的):ef030q03
    ,crefrcexeayexcobj_amt number(38,0) -- 征信强制执行申请执行标的金额(申请执行标的金额):ef030j01
    ,cr_efrcexe_cs_st varchar2(90) -- 征信强制执行案件状态(案件状态):ef030q04
    ,crefrcexe_endcs_mtdcd varchar2(900) -- 征信强制执行结案方式代码(结案方式):ef030d01
    ,crefrcexealrdyexecobj varchar2(900) -- 征信强制执行已执行标的(已执行标的):ef030q05
    ,crefrcexeayexecobjamt number(38,0) -- 征信强制执行已执行标的金额(已执行标的金额):ef030j02
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
grant select on ${iol_schema}.cqss_e_r_efrcexercrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_efrcexercrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_efrcexercrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_efrcexercrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_efrcexercrdinf is '强制执行记录信息';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.cr_inf_id is '征信信息编号:ef030i01';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.exec_court_nm is '执行法院名称:ef030q01';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.fileno is '案号:ef030i02';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.putonrcrd_dt is '立案日期:ef030r01';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.exec_csoatn is '执行案由:ef030q02';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.cr_efrcexe_ayexc_obj is '征信强制执行申请执行标的(申请执行标的):ef030q03';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.crefrcexeayexcobj_amt is '征信强制执行申请执行标的金额(申请执行标的金额):ef030j01';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.cr_efrcexe_cs_st is '征信强制执行案件状态(案件状态):ef030q04';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.crefrcexe_endcs_mtdcd is '征信强制执行结案方式代码(结案方式):ef030d01';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.crefrcexealrdyexecobj is '征信强制执行已执行标的(已执行标的):ef030q05';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.crefrcexeayexecobjamt is '征信强制执行已执行标的金额(已执行标的金额):ef030j02';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_efrcexercrdinf.etl_timestamp is 'ETL处理时间戳';
