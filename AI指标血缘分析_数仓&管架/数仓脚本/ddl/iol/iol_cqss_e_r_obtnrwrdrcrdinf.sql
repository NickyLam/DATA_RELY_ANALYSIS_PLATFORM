/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_obtnrwrdrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef090i01
    ,rwrd_dept_nm varchar2(360) -- 奖励部门名称:ef090q01
    ,rwrd_nm varchar2(450) -- 奖励名称:ef090q02
    ,awrd_dt date -- 授予日期:ef090r01
    ,codt date -- 截止日期:ef090r02
    ,rwrd_fct varchar2(900) -- 奖励事实:ef090q03
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
grant select on ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf is '获得奖励记录信息';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.cr_inf_id is '征信信息编号:ef090i01';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.rwrd_dept_nm is '奖励部门名称:ef090q01';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.rwrd_nm is '奖励名称:ef090q02';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.awrd_dt is '授予日期:ef090r01';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.codt is '截止日期:ef090r02';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.rwrd_fct is '奖励事实:ef090q03';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_obtnrwrdrcrdinf.etl_timestamp is 'ETL处理时间戳';
