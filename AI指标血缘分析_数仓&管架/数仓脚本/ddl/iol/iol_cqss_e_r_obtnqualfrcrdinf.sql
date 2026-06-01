/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_obtnqualfrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_obtnqualfrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_obtnqualfrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_obtnqualfrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef080i01
    ,afm_dept_nm varchar2(360) -- 认定部门名称:ef080q01
    ,qualf_tp varchar2(450) -- 资质类型:ef080q02
    ,ctfn_dt date -- 批准日期:ef080r01
    ,codt date -- 截止日期:ef080r02
    ,qualf_cntnt varchar2(900) -- 资质内容:ef080q03
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
grant select on ${iol_schema}.cqss_e_r_obtnqualfrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_obtnqualfrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnqualfrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_obtnqualfrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_obtnqualfrcrdinf is '获得资质记录信息';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.cr_inf_id is '征信信息编号:ef080i01';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.afm_dept_nm is '认定部门名称:ef080q01';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.qualf_tp is '资质类型:ef080q02';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.ctfn_dt is '批准日期:ef080r01';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.codt is '截止日期:ef080r02';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.qualf_cntnt is '资质内容:ef080q03';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_obtnqualfrcrdinf.etl_timestamp is 'ETL处理时间戳';
