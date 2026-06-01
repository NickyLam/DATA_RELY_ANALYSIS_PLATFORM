/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_onl_bank_tran_code_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_onl_bank_tran_code_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_onl_bank_tran_code_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_onl_bank_tran_code_h(
    serv_type_cd varchar2(30) -- 服务类型代码
    ,tran_code varchar2(60) -- 交易码
    ,tran_name varchar2(500) -- 交易名称
    ,tran_flg_comb varchar2(30) -- 交易标志组合
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
grant select on ${iml_schema}.ref_onl_bank_tran_code_h to ${icl_schema};
grant select on ${iml_schema}.ref_onl_bank_tran_code_h to ${idl_schema};
grant select on ${iml_schema}.ref_onl_bank_tran_code_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_onl_bank_tran_code_h is '网上银行交易码参数历史';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.serv_type_cd is '服务类型代码';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.tran_code is '交易码';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.tran_name is '交易名称';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.tran_flg_comb is '交易标志组合';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_onl_bank_tran_code_h.etl_timestamp is 'ETL处理时间戳';
