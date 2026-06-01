/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_prod_nv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_prod_nv
whenever sqlerror continue none;
drop table ${iml_schema}.prd_prod_nv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_nv(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,nv_id varchar2(100) -- 净值编号
    ,nv_dt date -- 净值日期
    ,corp_nv number(20,8) -- 单位净值
    ,acm_nv number(20,8) -- 累计净值
    ,aual_yld number(18,6) -- 年化收益率
    ,sevn_aual_yld number(18,6) -- 七日年化收益率
    ,ten_thous_prft number(18,6) -- 万份收益
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_prod_nv to ${icl_schema};
grant select on ${iml_schema}.prd_prod_nv to ${idl_schema};
grant select on ${iml_schema}.prd_prod_nv to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_prod_nv is '家族信托产品净值';
comment on column ${iml_schema}.prd_prod_nv.prod_id is '产品编号';
comment on column ${iml_schema}.prd_prod_nv.lp_id is '法人编号';
comment on column ${iml_schema}.prd_prod_nv.nv_id is '净值编号';
comment on column ${iml_schema}.prd_prod_nv.nv_dt is '净值日期';
comment on column ${iml_schema}.prd_prod_nv.corp_nv is '单位净值';
comment on column ${iml_schema}.prd_prod_nv.acm_nv is '累计净值';
comment on column ${iml_schema}.prd_prod_nv.aual_yld is '年化收益率';
comment on column ${iml_schema}.prd_prod_nv.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_prod_nv.ten_thous_prft is '万份收益';
comment on column ${iml_schema}.prd_prod_nv.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_prod_nv.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_prod_nv.job_cd is '任务编码';
comment on column ${iml_schema}.prd_prod_nv.etl_timestamp is 'ETL处理时间戳';
