/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tx_day_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tx_day_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tx_day_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tx_day_para(
    tx_dt date -- 交易日期
    ,rela_id varchar2(30) -- 关联编号
    ,dt_type_cd varchar2(30) -- 日期类别代码
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
grant select on ${iml_schema}.ref_tx_day_para to ${icl_schema};
grant select on ${iml_schema}.ref_tx_day_para to ${idl_schema};
grant select on ${iml_schema}.ref_tx_day_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tx_day_para is '交易日参数';
comment on column ${iml_schema}.ref_tx_day_para.tx_dt is '交易日期';
comment on column ${iml_schema}.ref_tx_day_para.rela_id is '关联编号';
comment on column ${iml_schema}.ref_tx_day_para.dt_type_cd is '日期类别代码';
comment on column ${iml_schema}.ref_tx_day_para.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_tx_day_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tx_day_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tx_day_para.etl_timestamp is 'ETL处理时间戳';
