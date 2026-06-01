/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_impexpcmdtyttclreginf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef130i01
    ,reg_dept_nm varchar2(360) -- 监管部门名称:ef130q01
    ,domn_sbsd_offc varchar2(360) -- 管辖直属局 :ef130q02
    ,reg_lvl varchar2(2) -- 监管级别:ef130d01
    ,efdt date -- 生效日期:ef130r01
    ,endto_dt date -- 截至日期:ef130r02
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
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf is '进出口商品检验分类监管信息';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.cr_inf_id is '征信信息编号:ef130i01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.reg_dept_nm is '监管部门名称:ef130q01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.domn_sbsd_offc is '管辖直属局 :ef130q02';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.reg_lvl is '监管级别:ef130d01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.efdt is '生效日期:ef130r01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.endto_dt is '截至日期:ef130r02';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyttclreginf.etl_timestamp is 'ETL处理时间戳';
