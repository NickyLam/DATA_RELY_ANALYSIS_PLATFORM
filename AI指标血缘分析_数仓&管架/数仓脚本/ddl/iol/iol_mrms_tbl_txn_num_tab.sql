/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_txn_num_tab
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_txn_num_tab
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_txn_num_tab purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_txn_num_tab(
    txn_num varchar2(90) -- 
    ,txn_name varchar2(300) -- 
    ,fin_txn_flg varchar2(2) -- 
    ,data_src_cd varchar2(6) -- 
    ,del_flg varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_tbl_txn_num_tab to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_txn_num_tab to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_txn_num_tab to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_txn_num_tab to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_txn_num_tab is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.txn_num is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.txn_name is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.fin_txn_flg is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.data_src_cd is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.del_flg is '';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_txn_num_tab.etl_timestamp is 'ETL处理时间戳';
