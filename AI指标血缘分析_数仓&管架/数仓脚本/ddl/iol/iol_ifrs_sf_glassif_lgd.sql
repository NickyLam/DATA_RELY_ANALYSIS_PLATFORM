/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_glassif_lgd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_glassif_lgd
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_glassif_lgd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_glassif_lgd(
    v_regul_classif_cd varchar2(15) -- 五级分类代码
    ,n_reg_factor_nums number(5,4) -- 调整系数
    ,v_regul_classif_id varchar2(96) -- 唯一ID
    ,status number -- 0,正常，1停用
    ,official_trial number -- 批次区分代码1为正式批
    ,trial_active number -- 是否启用，1启用
    ,sid number -- 规则组id
    ,cust_type varchar2(30) -- 减值计量主体类型
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
grant select on ${iol_schema}.ifrs_sf_glassif_lgd to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_glassif_lgd to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_glassif_lgd to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_glassif_lgd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_glassif_lgd is 'LGD五级分类调整配置表';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.v_regul_classif_cd is '五级分类代码';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.n_reg_factor_nums is '调整系数';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.v_regul_classif_id is '唯一ID';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.status is '0,正常，1停用';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.official_trial is '批次区分代码1为正式批';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.trial_active is '是否启用，1启用';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.sid is '规则组id';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.cust_type is '减值计量主体类型';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_sf_glassif_lgd.etl_timestamp is 'ETL处理时间戳';
