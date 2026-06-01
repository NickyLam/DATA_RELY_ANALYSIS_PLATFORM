/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fee_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fee_rat_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fee_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fee_rat_h(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,init_prod_id varchar2(60) -- 原产品编号
    ,fee_rat_type_cd varchar2(30) -- 费率类型代码
    ,prod_fee_rat number(30,8) -- 产品费率
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,fee_rat_update_dt date -- 费率更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_fee_rat_h to ${icl_schema};
grant select on ${iml_schema}.prd_fee_rat_h to ${idl_schema};
grant select on ${iml_schema}.prd_fee_rat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fee_rat_h is '产品费率历史';
comment on column ${iml_schema}.prd_fee_rat_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_fee_rat_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fee_rat_h.init_prod_id is '原产品编号';
comment on column ${iml_schema}.prd_fee_rat_h.fee_rat_type_cd is '费率类型代码';
comment on column ${iml_schema}.prd_fee_rat_h.prod_fee_rat is '产品费率';
comment on column ${iml_schema}.prd_fee_rat_h.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_fee_rat_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_fee_rat_h.fee_rat_update_dt is '费率更新日期';
comment on column ${iml_schema}.prd_fee_rat_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_fee_rat_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_fee_rat_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fee_rat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fee_rat_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fee_rat_h.etl_timestamp is 'ETL处理时间戳';
