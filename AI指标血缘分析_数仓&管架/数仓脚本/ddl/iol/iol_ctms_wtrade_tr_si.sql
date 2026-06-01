/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_wtrade_tr_si
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_wtrade_tr_si
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_wtrade_tr_si purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_wtrade_tr_si(
    aspclient_id number(22,0) -- 
    ,serial_number varchar2(23) -- 
    ,bs varchar2(3) -- 
    ,cash_acc_ename varchar2(384) -- 
    ,cash_acc_cname varchar2(384) -- 
    ,cash_acc_bank varchar2(384) -- 
    ,cash_acc_no varchar2(384) -- 
    ,cash_acc_bank_ex varchar2(384) -- 
    ,bond_acc_name varchar2(384) -- 
    ,bond_acc_bank varchar2(384) -- 
    ,bond_acc_no varchar2(384) -- 
    ,g_cash_amt varchar2(384) -- 
    ,g_bond_id varchar2(384) -- 
    ,g_bond_name varchar2(384) -- 
    ,g_bond_amt varchar2(384) -- 
    ,g_bond_total_amt varchar2(384) -- 
    ,g_ca_name varchar2(384) -- 
    ,g_ca_bank varchar2(384) -- 
    ,g_ca_no varchar2(384) -- 
    ,g_ca_bank_ex varchar2(384) -- 
    ,g_ba_name varchar2(384) -- 
    ,g_ba_bank varchar2(384) -- 
    ,g_ba_no varchar2(384) -- 
    ,g_stl_date varchar2(384) -- 
    ,g_mgr_bank varchar2(384) -- 
    ,lastmodified timestamp -- 
    ,datasymbol_id number(22,0) -- 
    ,settle_instr_name varchar2(768) -- 清算路径名称
    ,swift_code varchar2(768) -- Swift Code编码
    ,bond_owner varchar2(768) -- 托管账号开户人
    ,custody_institution_type varchar2(384) -- 托管机构类型
    ,bond_settle_instr_name varchar2(768) -- 托管清算路径名称
    ,bond_escrow_opening_bank varchar2(768) -- 债券托管开户行
    ,escrow_agency varchar2(768) -- 托管机构
    ,bond_acc_ename varchar2(768) -- 债券托管账户英文户名
    ,bond_escrow_manage_agency varchar2(768) -- 债券托管管理机构
    ,bond_swift_code varchar2(192) -- 托管机构SWIFT CODE
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
grant select on ${iol_schema}.ctms_wtrade_tr_si to ${iml_schema};
grant select on ${iol_schema}.ctms_wtrade_tr_si to ${icl_schema};
grant select on ${iol_schema}.ctms_wtrade_tr_si to ${idl_schema};
grant select on ${iol_schema}.ctms_wtrade_tr_si to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_wtrade_tr_si is '清算账户信息表';
comment on column ${iol_schema}.ctms_wtrade_tr_si.aspclient_id is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.serial_number is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bs is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.cash_acc_ename is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.cash_acc_cname is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.cash_acc_bank is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.cash_acc_no is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.cash_acc_bank_ex is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_acc_name is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_acc_bank is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_acc_no is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_cash_amt is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_bond_id is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_bond_name is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_bond_amt is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_bond_total_amt is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ca_name is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ca_bank is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ca_no is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ca_bank_ex is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ba_name is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ba_bank is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_ba_no is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_stl_date is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.g_mgr_bank is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.lastmodified is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.datasymbol_id is '';
comment on column ${iol_schema}.ctms_wtrade_tr_si.settle_instr_name is '清算路径名称';
comment on column ${iol_schema}.ctms_wtrade_tr_si.swift_code is 'Swift Code编码';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_owner is '托管账号开户人';
comment on column ${iol_schema}.ctms_wtrade_tr_si.custody_institution_type is '托管机构类型';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_settle_instr_name is '托管清算路径名称';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_escrow_opening_bank is '债券托管开户行';
comment on column ${iol_schema}.ctms_wtrade_tr_si.escrow_agency is '托管机构';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_acc_ename is '债券托管账户英文户名';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_escrow_manage_agency is '债券托管管理机构';
comment on column ${iol_schema}.ctms_wtrade_tr_si.bond_swift_code is '托管机构SWIFT CODE';
comment on column ${iol_schema}.ctms_wtrade_tr_si.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_wtrade_tr_si.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_wtrade_tr_si.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_wtrade_tr_si.etl_timestamp is 'ETL处理时间戳';
