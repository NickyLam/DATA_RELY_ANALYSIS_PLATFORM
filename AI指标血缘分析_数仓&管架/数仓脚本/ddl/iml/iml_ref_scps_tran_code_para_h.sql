/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_scps_tran_code_para_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_scps_tran_code_para_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_scps_tran_code_para_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_scps_tran_code_para_h(
    tran_code varchar2(30) -- 交易码
    ,lp_id varchar2(100) -- 法人编号
    ,tran_code_name varchar2(500) -- 交易码名称
    ,tran_code_descb varchar2(500) -- 交易码描述
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
grant select on ${iml_schema}.ref_scps_tran_code_para_h to ${icl_schema};
grant select on ${iml_schema}.ref_scps_tran_code_para_h to ${idl_schema};
grant select on ${iml_schema}.ref_scps_tran_code_para_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_scps_tran_code_para_h is '后援中心交易码参数历史';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.tran_code is '交易码';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.tran_code_name is '交易码名称';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.tran_code_descb is '交易码描述';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_scps_tran_code_para_h.etl_timestamp is 'ETL处理时间戳';
