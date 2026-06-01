/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_owtaxrcrdinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_owtaxrcrdinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_owtaxrcrdinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_owtaxrcrdinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef010i01
    ,spvs_tax_ahr_nm varchar2(360) -- 主管税务机关名称:ef010q01
    ,cr_inarr_tax_tamt number(38,0) -- 征信拖欠税总额(欠税总额):ef010j01
    ,ow_tax_stat_tm date -- 欠税统计时间:ef010r01
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
grant select on ${iol_schema}.cqss_e_r_owtaxrcrdinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_owtaxrcrdinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_owtaxrcrdinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_owtaxrcrdinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_owtaxrcrdinf is '欠税记录信息';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.cr_inf_id is '征信信息编号:ef010i01';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.spvs_tax_ahr_nm is '主管税务机关名称:ef010q01';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.cr_inarr_tax_tamt is '征信拖欠税总额(欠税总额):ef010j01';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.ow_tax_stat_tm is '欠税统计时间:ef010r01';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_owtaxrcrdinf.etl_timestamp is 'ETL处理时间戳';
