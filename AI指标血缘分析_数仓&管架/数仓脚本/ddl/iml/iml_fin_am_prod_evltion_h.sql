/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_prod_evltion_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_prod_evltion_h
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_prod_evltion_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_evltion_h(
    sob_id varchar2(60) -- 账套编号
    ,lp_id varchar2(60) -- 法人编号
    ,sob_name varchar2(250) -- 账套名称
    ,evltion_type_cd varchar2(60) -- 估值类型代码
    ,evltion_descb varchar2(500) -- 估值描述
    ,evltion number(30,8) -- 估值
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
grant select on ${iml_schema}.fin_am_prod_evltion_h to ${icl_schema};
grant select on ${iml_schema}.fin_am_prod_evltion_h to ${idl_schema};
grant select on ${iml_schema}.fin_am_prod_evltion_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_prod_evltion_h is '资管产品净值收益历史';
comment on column ${iml_schema}.fin_am_prod_evltion_h.sob_id is '账套编号';
comment on column ${iml_schema}.fin_am_prod_evltion_h.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_prod_evltion_h.sob_name is '账套名称';
comment on column ${iml_schema}.fin_am_prod_evltion_h.evltion_type_cd is '估值类型代码';
comment on column ${iml_schema}.fin_am_prod_evltion_h.evltion_descb is '估值描述';
comment on column ${iml_schema}.fin_am_prod_evltion_h.evltion is '估值';
comment on column ${iml_schema}.fin_am_prod_evltion_h.start_dt is '开始时间';
comment on column ${iml_schema}.fin_am_prod_evltion_h.end_dt is '结束时间';
comment on column ${iml_schema}.fin_am_prod_evltion_h.id_mark is '增删标志';
comment on column ${iml_schema}.fin_am_prod_evltion_h.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_prod_evltion_h.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_prod_evltion_h.etl_timestamp is 'ETL处理时间戳';
