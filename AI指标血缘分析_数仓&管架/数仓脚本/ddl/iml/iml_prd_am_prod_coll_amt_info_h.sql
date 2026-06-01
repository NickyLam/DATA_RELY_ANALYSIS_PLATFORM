/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_am_prod_coll_amt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_am_prod_coll_amt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_am_prod_coll_amt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_prod_coll_amt_info_h(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,calc_start_dt date -- 计算开始日期
    ,begin_dt date -- 起始日期
    ,coll_amt number(38,8) -- 募集金额
    ,td_coll_amt number(38,8) -- 当日募集金额
    ,prft_type_cd varchar2(60) -- 收益类型代码
    ,creator_name varchar2(500) -- 创建人名称
    ,create_dept varchar2(500) -- 创建部门
    ,init_create_dt date -- 最初创建日期
    ,updater_name varchar2(500) -- 更新人名称
    ,latest_update_dt date -- 最新更新日期
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
grant select on ${iml_schema}.prd_am_prod_coll_amt_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_am_prod_coll_amt_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_am_prod_coll_amt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_am_prod_coll_amt_info_h is '资管产品募集金额信息历史';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.calc_start_dt is '计算开始日期';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.begin_dt is '起始日期';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.coll_amt is '募集金额';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.td_coll_amt is '当日募集金额';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.prft_type_cd is '收益类型代码';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.creator_name is '创建人名称';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.create_dept is '创建部门';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.updater_name is '更新人名称';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_am_prod_coll_amt_info_h.etl_timestamp is 'ETL处理时间戳';
