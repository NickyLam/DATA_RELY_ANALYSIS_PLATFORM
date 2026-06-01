/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ref_tran_bank_code_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ref_tran_bank_code_para
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ref_tran_bank_code_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ref_tran_bank_code_para(
    etl_dt date -- 数据日期
    ,tran_code varchar2(100) -- 交易码
    ,tran_name varchar2(500) -- 交易名称
    ,fin_tran_flg varchar2(30) -- 金融交易标志
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ref_tran_bank_code_para to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ref_tran_bank_code_para is '交易银行交易码参数';
comment on column ${itl_schema}.itl_edw_ref_tran_bank_code_para.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_ref_tran_bank_code_para.tran_code is '交易码';
comment on column ${itl_schema}.itl_edw_ref_tran_bank_code_para.tran_name is '交易名称';
comment on column ${itl_schema}.itl_edw_ref_tran_bank_code_para.fin_tran_flg is '金融交易标志';
comment on column ${itl_schema}.itl_edw_ref_tran_bank_code_para.etl_timestamp is 'ETL处理时间戳';