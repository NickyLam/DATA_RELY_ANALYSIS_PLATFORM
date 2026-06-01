/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dist_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dist_cd
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dist_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dist_cd(
    rg_cd varchar2(10) -- 地区代码
    ,rg_name varchar2(100) -- 地区名称
    ,city_cd varchar2(10) -- 市代码
    ,city_name varchar2(100) -- 城市名称
    ,prov_cd varchar2(10) -- 省代码
    ,prov_name varchar2(100) -- 省名称
    ,four_rg_cd varchar2(30) -- 四位地区代码
    ,pbc_rg_cd varchar2(30) -- 人行地区代码
    ,base_std_flg varchar2(10) -- 基础标准标志
    ,std_id varchar2(60) -- 标准编号
	,valid_flg varchar2(10) --有效标志
	,invalid_dt date --失效日期
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
;

-- grant
grant select on ${iml_schema}.ref_dist_cd to ${icl_schema};
grant select on ${iml_schema}.ref_dist_cd to ${idl_schema};
grant select on ${iml_schema}.ref_dist_cd to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dist_cd is '行政区划代码表';
comment on column ${iml_schema}.ref_dist_cd.rg_cd is '地区代码';
comment on column ${iml_schema}.ref_dist_cd.rg_name is '地区名称';
comment on column ${iml_schema}.ref_dist_cd.city_cd is '市代码';
comment on column ${iml_schema}.ref_dist_cd.city_name is '城市名称';
comment on column ${iml_schema}.ref_dist_cd.prov_cd is '省代码';
comment on column ${iml_schema}.ref_dist_cd.prov_name is '省名称';
comment on column ${iml_schema}.ref_dist_cd.four_rg_cd is '四位地区代码';
comment on column ${iml_schema}.ref_dist_cd.pbc_rg_cd is '人行地区代码';
comment on column ${iml_schema}.ref_dist_cd.base_std_flg is '基础标准标志';
comment on column ${iml_schema}.ref_dist_cd.std_id is '标准编号';
comment on column ${iml_schema}.ref_dist_cd.valid_flg is '有效标志';
comment on column ${iml_schema}.ref_dist_cd.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_dist_cd.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_dist_cd.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dist_cd.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dist_cd.etl_timestamp is 'ETL处理时间戳';
