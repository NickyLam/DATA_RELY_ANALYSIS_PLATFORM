/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_prod_init_amt_def_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_prod_init_amt_def_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_prod_init_amt_def_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_init_amt_def_h(
    lp_id varchar2(100) -- 法人编号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,max_bal number(30,2) -- 最大余额
    ,min_bal number(30,2) -- 最小余额
    ,sig_subscr_max_amt number(30,2) -- 单笔认购最大金额
    ,sig_min_wdraw_amt number(30,2) -- 单笔最小支取金额
    ,make_copy_amt number(30,2) -- 留底金额
    ,init_amt number(30,2) -- 起存金额
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
grant select on ${iml_schema}.prd_prod_init_amt_def_h to ${icl_schema};
grant select on ${iml_schema}.prd_prod_init_amt_def_h to ${idl_schema};
grant select on ${iml_schema}.prd_prod_init_amt_def_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_prod_init_amt_def_h is '产品起存金额定义历史';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.max_bal is '最大余额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.min_bal is '最小余额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.sig_subscr_max_amt is '单笔认购最大金额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.sig_min_wdraw_amt is '单笔最小支取金额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.make_copy_amt is '留底金额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.init_amt is '起存金额';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_prod_init_amt_def_h.etl_timestamp is 'ETL处理时间戳';
