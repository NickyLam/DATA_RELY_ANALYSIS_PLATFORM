/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_obtnprmsnrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef060i01
    ,prmsn_dept_nm varchar2(360) -- 许可部门名称:ef060q01
    ,prmsn_tp varchar2(180) -- 许可类型:ef060q02
    ,ctfn_dt date -- 许可日期:ef060r01
    ,codt date -- 截止日期:ef060r02
    ,prmsn_cntnt varchar2(4000) -- 许可内容:ef060q03
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
grant select on ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf is '获得许可记录信息';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.cr_inf_id is '征信信息编号:ef060i01';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.prmsn_dept_nm is '许可部门名称:ef060q01';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.prmsn_tp is '许可类型:ef060q02';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.ctfn_dt is '许可日期:ef060r01';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.codt is '截止日期:ef060r02';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.prmsn_cntnt is '许可内容:ef060q03';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_obtnprmsnrcrdinf.etl_timestamp is 'ETL处理时间戳';
