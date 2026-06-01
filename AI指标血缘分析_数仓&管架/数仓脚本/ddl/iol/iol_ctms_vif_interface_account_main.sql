/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_vif_interface_account_main
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_vif_interface_account_main
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_vif_interface_account_main purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vif_interface_account_main(
    src_cd varchar2(5) -- 
    ,settledate date -- 
    ,settletime varchar2(12) -- 
    ,bus_depart_id varchar2(9) -- 
    ,ope_depart_id varchar2(9) -- 
    ,handle_teller_id varchar2(15) -- 
    ,check_teller_id varchar2(15) -- 
    ,txn_num varchar2(8) -- 
    ,txn_desc varchar2(32) -- 
    ,alterbalance_id varchar2(390) -- 
    ,core_seq varchar2(384) -- 
    ,amount number(24,2) -- 
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
grant select on ${iol_schema}.ctms_vif_interface_account_main to ${iml_schema};
grant select on ${iol_schema}.ctms_vif_interface_account_main to ${icl_schema};
grant select on ${iol_schema}.ctms_vif_interface_account_main to ${idl_schema};
grant select on ${iol_schema}.ctms_vif_interface_account_main to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_vif_interface_account_main is '资金交易管理系统-业务量统计2';
comment on column ${iol_schema}.ctms_vif_interface_account_main.src_cd is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.settledate is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.settletime is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.bus_depart_id is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.ope_depart_id is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.handle_teller_id is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.check_teller_id is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.txn_num is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.txn_desc is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.alterbalance_id is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.core_seq is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.amount is '';
comment on column ${iol_schema}.ctms_vif_interface_account_main.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_vif_interface_account_main.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_vif_interface_account_main.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_vif_interface_account_main.etl_timestamp is 'ETL处理时间戳';
