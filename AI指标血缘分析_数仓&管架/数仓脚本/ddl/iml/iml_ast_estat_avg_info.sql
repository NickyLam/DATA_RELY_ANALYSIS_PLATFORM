/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_estat_avg_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_estat_avg_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_estat_avg_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_estat_avg_info(
    batch_dt varchar2(30) -- 批次日期
    ,estat_id varchar2(60) -- 楼盘编号
    ,lp_id varchar2(60) -- 法人编号
    ,local_prov_cd varchar2(60) -- 所在省代码
    ,local_city_cd varchar2(60) -- 所在市代码
    ,local_rg_cd varchar2(60) -- 所在区代码
    ,estat_name varchar2(150) -- 楼盘名称
    ,ext_estim_price number(30,2) -- 外部评估价格
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
grant select on ${iml_schema}.ast_estat_avg_info to ${icl_schema};
grant select on ${iml_schema}.ast_estat_avg_info to ${idl_schema};
grant select on ${iml_schema}.ast_estat_avg_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_estat_avg_info is '楼盘均价信息';
comment on column ${iml_schema}.ast_estat_avg_info.batch_dt is '批次日期';
comment on column ${iml_schema}.ast_estat_avg_info.estat_id is '楼盘编号';
comment on column ${iml_schema}.ast_estat_avg_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_estat_avg_info.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ast_estat_avg_info.local_city_cd is '所在市代码';
comment on column ${iml_schema}.ast_estat_avg_info.local_rg_cd is '所在区代码';
comment on column ${iml_schema}.ast_estat_avg_info.estat_name is '楼盘名称';
comment on column ${iml_schema}.ast_estat_avg_info.ext_estim_price is '外部评估价格';
comment on column ${iml_schema}.ast_estat_avg_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_estat_avg_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_estat_avg_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_estat_avg_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_estat_avg_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_estat_avg_info.etl_timestamp is 'ETL处理时间戳';
