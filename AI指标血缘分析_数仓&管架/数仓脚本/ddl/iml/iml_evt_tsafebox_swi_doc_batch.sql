/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tsafebox_swi_doc_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tsafebox_swi_doc_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tsafebox_swi_doc_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_swi_doc_batch(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,rgst_dt date -- 登记日期
    ,doc_name varchar2(500) -- 文件名称
    ,tot number(30) -- 总笔数
    ,sucs_cnt number(30) -- 成功笔数
    ,fail_cnt number(30) -- 失败笔数
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,rest_descb varchar2(500) -- 处理结果描述
    ,proc_start_tm date -- 处理开始时间
    ,proc_end_tm date -- 处理结束时间
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
grant select on ${iml_schema}.evt_tsafebox_swi_doc_batch to ${icl_schema};
grant select on ${iml_schema}.evt_tsafebox_swi_doc_batch to ${idl_schema};
grant select on ${iml_schema}.evt_tsafebox_swi_doc_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tsafebox_swi_doc_batch is '保险箱开关箱文件批次';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.doc_name is '文件名称';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.tot is '总笔数';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.rest_descb is '处理结果描述';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.proc_start_tm is '处理开始时间';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.proc_end_tm is '处理结束时间';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tsafebox_swi_doc_batch.etl_timestamp is 'ETL处理时间戳';
