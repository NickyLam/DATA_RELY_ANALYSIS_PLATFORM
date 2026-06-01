/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_ref_tran_bank_code_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ref_tran_bank_code_para
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ref_tran_bank_code_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ref_tran_bank_code_para(
    etl_dt date
    ,tran_code varchar2(100)
    ,tran_name varchar2(500)
    ,create_dt date
    ,update_dt date
    ,id_mark varchar2(10)
    ,fin_tran_flg varchar2(30)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ref_tran_bank_code_para to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ref_tran_bank_code_para is '交易银行交易码参数';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.tran_code is '交易码';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.tran_name is '交易名称';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.create_dt is '创建日期';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.update_dt is '更新日期';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.id_mark is '删除标识';
comment on column ${msl_schema}.msl_edw_ref_tran_bank_code_para.fin_tran_flg is '金融交易标志';
