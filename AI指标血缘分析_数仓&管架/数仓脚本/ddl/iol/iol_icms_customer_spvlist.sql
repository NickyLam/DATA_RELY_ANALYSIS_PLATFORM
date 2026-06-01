/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_spvlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_spvlist
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_spvlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_spvlist(
    serialno varchar2(32) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,customertype varchar2(32) -- SPV客户类型
    ,trustcustid varchar2(32) -- 托管人编号
    ,inputdate date -- 登记时间
    ,updatedate date -- 更新时间
    ,customername varchar2(200) -- 客户名称
    ,inputorgid varchar2(12) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,migtflag varchar2(80) -- 
    ,certtype varchar2(20) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,inputuserid varchar2(32) -- 登记人
    ,managecustid varchar2(32) -- 管理人编号
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
grant select on ${iol_schema}.icms_customer_spvlist to ${iml_schema};
grant select on ${iol_schema}.icms_customer_spvlist to ${icl_schema};
grant select on ${iol_schema}.icms_customer_spvlist to ${idl_schema};
grant select on ${iol_schema}.icms_customer_spvlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_spvlist is 'spv客户清单';
comment on column ${iol_schema}.icms_customer_spvlist.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_spvlist.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_spvlist.customertype is 'SPV客户类型';
comment on column ${iol_schema}.icms_customer_spvlist.trustcustid is '托管人编号';
comment on column ${iol_schema}.icms_customer_spvlist.inputdate is '登记时间';
comment on column ${iol_schema}.icms_customer_spvlist.updatedate is '更新时间';
comment on column ${iol_schema}.icms_customer_spvlist.customername is '客户名称';
comment on column ${iol_schema}.icms_customer_spvlist.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_spvlist.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_spvlist.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_spvlist.migtflag is '';
comment on column ${iol_schema}.icms_customer_spvlist.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_spvlist.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_spvlist.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_spvlist.managecustid is '管理人编号';
comment on column ${iol_schema}.icms_customer_spvlist.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_spvlist.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_spvlist.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_spvlist.etl_timestamp is 'ETL处理时间戳';
