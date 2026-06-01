
/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_idx_index_data_rdw_bl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_idx_index_data_rdw_bl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_idx_index_data_rdw_bl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_idx_index_data_rdw_bl(
     index_no          VARCHAR2(60),
     org_no            VARCHAR2(60),
     biz_strip_line_cd VARCHAR2(30),
     dim_cd1           VARCHAR2(30),
     dim_cd2           VARCHAR2(30),
     dim_cd3           VARCHAR2(30),
     batch_freq        VARCHAR2(30),
     index_measure     VARCHAR2(30),
     curr_cd           VARCHAR2(30),
     index_val         NUMBER(30,8),
     etl_dt            DATE,
     etl_timestamp     TIMESTAMP(6)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

