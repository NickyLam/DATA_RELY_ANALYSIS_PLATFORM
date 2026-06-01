/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_vouchtype_lgd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_vouchtype_lgd
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_vouchtype_lgd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_vouchtype_lgd(
    v_vouchtype_cd varchar2(75) -- 主担保方式
    ,lgd_basics number(5,4) -- 基础lgd
    ,v_vouchtype_id varchar2(96) -- 唯一ID
    ,official_trial number -- 批次区分代码1为正式批
    ,trial_active number -- 是否启用，1启用
    ,sid number -- ID
    ,lgd_discount number(5,4) -- LGD折扣率
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
grant select on ${iol_schema}.ifrs_sf_vouchtype_lgd to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_vouchtype_lgd to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_vouchtype_lgd to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_vouchtype_lgd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_vouchtype_lgd is '主担保方式映射基础LGD表';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.v_vouchtype_cd is '主担保方式';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.lgd_basics is '基础lgd';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.v_vouchtype_id is '唯一ID';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.official_trial is '批次区分代码1为正式批';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.trial_active is '是否启用，1启用';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.sid is 'ID';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.lgd_discount is 'LGD折扣率';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_sf_vouchtype_lgd.etl_timestamp is 'ETL处理时间戳';
