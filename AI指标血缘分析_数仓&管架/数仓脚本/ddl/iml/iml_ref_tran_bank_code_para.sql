/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tran_bank_code_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tran_bank_code_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tran_bank_code_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tran_bank_code_para(
    tran_code varchar2(100) -- 交易码
    ,tran_name varchar2(500) -- 交易名称
    ,fin_tran_flg varchar2(30) -- 金融交易标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.ref_tran_bank_code_para to ${icl_schema};
grant select on ${iml_schema}.ref_tran_bank_code_para to ${idl_schema};
grant select on ${iml_schema}.ref_tran_bank_code_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tran_bank_code_para is '交易银行交易码参数';
comment on column ${iml_schema}.ref_tran_bank_code_para.tran_code is '交易码';
comment on column ${iml_schema}.ref_tran_bank_code_para.tran_name is '交易名称';
comment on column ${iml_schema}.ref_tran_bank_code_para.fin_tran_flg is '金融交易标志';
comment on column ${iml_schema}.ref_tran_bank_code_para.create_dt is '创建日期';
comment on column ${iml_schema}.ref_tran_bank_code_para.update_dt is '更新日期';
comment on column ${iml_schema}.ref_tran_bank_code_para.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_tran_bank_code_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tran_bank_code_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tran_bank_code_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tran_bank_code_para.etl_timestamp is 'ETL处理时间戳';
