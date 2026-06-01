/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_baseasset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_baseasset_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_baseasset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_baseasset_info(
    serialno varchar2(32) -- 流水号
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,certtype varchar2(20) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,industry varchar2(10) -- 客户所在行业
    ,currency varchar2(3) -- 币种
    ,businesssum number(24,6) -- 金额（元）
    ,begindate varchar2(10) -- 起始日
    ,enddate varchar2(10) -- 到期日
    ,paycustomertype varchar2(10) -- 兑付方客户类型
    ,bookvalue number(22,4) -- 账面价值
    ,migtflag varchar2(80) -- 迁移标志
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
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
grant select on ${iol_schema}.icms_baseasset_info to ${iml_schema};
grant select on ${iol_schema}.icms_baseasset_info to ${icl_schema};
grant select on ${iol_schema}.icms_baseasset_info to ${idl_schema};
grant select on ${iol_schema}.icms_baseasset_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_baseasset_info is '底层资产信息';
comment on column ${iol_schema}.icms_baseasset_info.serialno is '流水号';
comment on column ${iol_schema}.icms_baseasset_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_baseasset_info.customername is '客户名称';
comment on column ${iol_schema}.icms_baseasset_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_baseasset_info.certid is '证件号码';
comment on column ${iol_schema}.icms_baseasset_info.industry is '客户所在行业';
comment on column ${iol_schema}.icms_baseasset_info.currency is '币种';
comment on column ${iol_schema}.icms_baseasset_info.businesssum is '金额（元）';
comment on column ${iol_schema}.icms_baseasset_info.begindate is '起始日';
comment on column ${iol_schema}.icms_baseasset_info.enddate is '到期日';
comment on column ${iol_schema}.icms_baseasset_info.paycustomertype is '兑付方客户类型';
comment on column ${iol_schema}.icms_baseasset_info.bookvalue is '账面价值';
comment on column ${iol_schema}.icms_baseasset_info.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_baseasset_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_baseasset_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_baseasset_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_baseasset_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_baseasset_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_baseasset_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_baseasset_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_baseasset_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_baseasset_info.etl_timestamp is 'ETL处理时间戳';
