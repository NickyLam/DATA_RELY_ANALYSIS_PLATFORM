/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_curr_mode_cash_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_curr_mode_cash_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_curr_mode_cash_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_curr_mode_cash_h(
    prod_id varchar2(100) -- 产品编号
    ,cash_dt date -- 兑付日期
    ,lp_id varchar2(60) -- 法人编号
    ,intfc_proc_flg varchar2(10) -- 接口处理标志
    ,proc_dt date -- 处理日期
    ,remark varchar2(375) -- 备注
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
grant select on ${iml_schema}.prd_curr_mode_cash_h to ${icl_schema};
grant select on ${iml_schema}.prd_curr_mode_cash_h to ${idl_schema};
grant select on ${iml_schema}.prd_curr_mode_cash_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_curr_mode_cash_h is '货币式产品兑付历史';
comment on column ${iml_schema}.prd_curr_mode_cash_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_curr_mode_cash_h.cash_dt is '兑付日期';
comment on column ${iml_schema}.prd_curr_mode_cash_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_curr_mode_cash_h.intfc_proc_flg is '接口处理标志';
comment on column ${iml_schema}.prd_curr_mode_cash_h.proc_dt is '处理日期';
comment on column ${iml_schema}.prd_curr_mode_cash_h.remark is '备注';
comment on column ${iml_schema}.prd_curr_mode_cash_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_curr_mode_cash_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_curr_mode_cash_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_curr_mode_cash_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_curr_mode_cash_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_curr_mode_cash_h.etl_timestamp is 'ETL处理时间戳';
