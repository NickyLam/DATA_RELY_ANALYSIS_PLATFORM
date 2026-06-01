/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_city_cd_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_city_cd_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_city_cd_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_city_cd_para(
    lp_id varchar2(100) -- 法人编号
    ,belong_cty_rg_cd varchar2(30) -- 所属国家和地区代码
    ,belong_prov_cd varchar2(30) -- 所属省代码
    ,city_cd varchar2(30) -- 城市代码
    ,city_name varchar2(500) -- 城市名称
    ,super_city_cd varchar2(30) -- 上级城市代码
    ,tel_zone_cd varchar2(60) -- 电话区号
    ,zip_code varchar2(60) -- 邮政编码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_city_cd_para to ${icl_schema};
grant select on ${iml_schema}.ref_city_cd_para to ${idl_schema};
grant select on ${iml_schema}.ref_city_cd_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_city_cd_para is '城市代码参数表';
comment on column ${iml_schema}.ref_city_cd_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_city_cd_para.belong_cty_rg_cd is '所属国家和地区代码';
comment on column ${iml_schema}.ref_city_cd_para.belong_prov_cd is '所属省代码';
comment on column ${iml_schema}.ref_city_cd_para.city_cd is '城市代码';
comment on column ${iml_schema}.ref_city_cd_para.city_name is '城市名称';
comment on column ${iml_schema}.ref_city_cd_para.super_city_cd is '上级城市代码';
comment on column ${iml_schema}.ref_city_cd_para.tel_zone_cd is '电话区号';
comment on column ${iml_schema}.ref_city_cd_para.zip_code is '邮政编码';
comment on column ${iml_schema}.ref_city_cd_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_city_cd_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_city_cd_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_city_cd_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_city_cd_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_city_cd_para.etl_timestamp is 'ETL处理时间戳';
