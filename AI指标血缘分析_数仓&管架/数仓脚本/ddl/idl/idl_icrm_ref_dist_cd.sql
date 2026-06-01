/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_dist_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_dist_cd
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_dist_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_dist_cd(
    etl_dt date -- 数据日期
    ,rg_cd varchar2(10) -- 地区代码
    ,rg_name varchar2(100) -- 地区名称
    ,city_cd varchar2(10) -- 市代码
    ,city_name varchar2(100) -- 城市名称
    ,prov_cd varchar2(10) -- 省代码
    ,prov_name varchar2(100) -- 省名称
    ,base_std_flg varchar2(10) -- 基础标准标志
    ,std_id varchar2(60) -- 标准编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_dist_cd to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_dist_cd is '行政区划代码表';
comment on column ${idl_schema}.icrm_ref_dist_cd.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_dist_cd.rg_cd is '地区代码';
comment on column ${idl_schema}.icrm_ref_dist_cd.rg_name is '地区名称';
comment on column ${idl_schema}.icrm_ref_dist_cd.city_cd is '市代码';
comment on column ${idl_schema}.icrm_ref_dist_cd.city_name is '城市名称';
comment on column ${idl_schema}.icrm_ref_dist_cd.prov_cd is '省代码';
comment on column ${idl_schema}.icrm_ref_dist_cd.prov_name is '省名称';
comment on column ${idl_schema}.icrm_ref_dist_cd.base_std_flg is '基础标准标志';
comment on column ${idl_schema}.icrm_ref_dist_cd.std_id is '标准编号';
comment on column ${idl_schema}.icrm_ref_dist_cd.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_dist_cd.etl_timestamp is '数据处理时间';
