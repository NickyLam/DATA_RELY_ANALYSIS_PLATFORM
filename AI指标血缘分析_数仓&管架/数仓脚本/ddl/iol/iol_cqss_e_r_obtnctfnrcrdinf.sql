/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_obtnctfnrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_obtnctfnrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_obtnctfnrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_obtnctfnrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef070i01
    ,ctfn_dept_nm varchar2(360) -- 认证部门名称:ef070q01
    ,ctfn_tp varchar2(450) -- 认证类型:ef070q02
    ,ctfn_dt date -- 认证日期:ef070r01
    ,codt date -- 截止日期:ef070r02
    ,ctfn_cntnt varchar2(900) -- 认证内容:ef070q03
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
grant select on ${iol_schema}.cqss_e_r_obtnctfnrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_obtnctfnrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnctfnrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnctfnrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_obtnctfnrcrdinf is '获得认证记录信息';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.cr_inf_id is '征信信息编号:ef070i01';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.ctfn_dept_nm is '认证部门名称:ef070q01';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.ctfn_tp is '认证类型:ef070q02';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.ctfn_dt is '认证日期:ef070r01';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.codt is '截止日期:ef070r02';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.ctfn_cntnt is '认证内容:ef070q03';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_obtnctfnrcrdinf.etl_timestamp is 'ETL处理时间戳';
