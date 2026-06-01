/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_rtginf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_rtginf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_rtginf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_rtginf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:eh010i01
    ,rtg_inst_nm varchar2(360) -- 评级机构名称:eh010q01
    ,rtg_dt date -- 评级日期:eh010r01
    ,rtg_rslt varchar2(60) -- 评级结果:eh010d01
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
grant select on ${iol_schema}.cqss_e_r_rtginf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_rtginf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_rtginf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_rtginf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_rtginf is '评级信息';
comment on column ${iol_schema}.cqss_e_r_rtginf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_rtginf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_rtginf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_rtginf.cr_inf_id is '征信信息编号:eh010i01';
comment on column ${iol_schema}.cqss_e_r_rtginf.rtg_inst_nm is '评级机构名称:eh010q01';
comment on column ${iol_schema}.cqss_e_r_rtginf.rtg_dt is '评级日期:eh010r01';
comment on column ${iol_schema}.cqss_e_r_rtginf.rtg_rslt is '评级结果:eh010d01';
comment on column ${iol_schema}.cqss_e_r_rtginf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_rtginf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_rtginf.etl_timestamp is 'ETL处理时间戳';
