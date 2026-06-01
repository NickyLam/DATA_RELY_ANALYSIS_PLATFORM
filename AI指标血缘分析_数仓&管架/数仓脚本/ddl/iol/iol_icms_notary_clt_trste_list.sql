/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_notary_clt_trste_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_notary_clt_trste_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_notary_clt_trste_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_notary_clt_trste_list(
    serialno varchar2(32) -- 流水号
    ,inputdate date -- 登记日期
    ,customerid varchar2(40) -- 客户编号
    ,customername varchar2(100) -- 客户名称
    ,customertype varchar2(2) -- 客户类型
    ,serno varchar2(32) -- 业务申请流水号
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
grant select on ${iol_schema}.icms_notary_clt_trste_list to ${iml_schema};
grant select on ${iol_schema}.icms_notary_clt_trste_list to ${icl_schema};
grant select on ${iol_schema}.icms_notary_clt_trste_list to ${idl_schema};
grant select on ${iol_schema}.icms_notary_clt_trste_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_notary_clt_trste_list is '赎楼贷公证委托人、受托人信息';
comment on column ${iol_schema}.icms_notary_clt_trste_list.serialno is '流水号';
comment on column ${iol_schema}.icms_notary_clt_trste_list.inputdate is '登记日期';
comment on column ${iol_schema}.icms_notary_clt_trste_list.customerid is '客户编号';
comment on column ${iol_schema}.icms_notary_clt_trste_list.customername is '客户名称';
comment on column ${iol_schema}.icms_notary_clt_trste_list.customertype is '客户类型';
comment on column ${iol_schema}.icms_notary_clt_trste_list.serno is '业务申请流水号';
comment on column ${iol_schema}.icms_notary_clt_trste_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_notary_clt_trste_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_notary_clt_trste_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_notary_clt_trste_list.etl_timestamp is 'ETL处理时间戳';
