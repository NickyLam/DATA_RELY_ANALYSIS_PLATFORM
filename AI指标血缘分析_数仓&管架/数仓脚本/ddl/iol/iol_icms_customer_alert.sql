/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_alert
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_alert
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_alert purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_alert(
    serialno varchar2(40) -- 流水号
    ,inputorgid varchar2(40) -- 登记机构
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(8) -- 更新人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputuserid varchar2(40) -- 登记人
    ,customername varchar2(200) -- 客户名称
    ,updateorgid varchar2(12) -- 更新机构
    ,username varchar2(200) -- 操作员名称
    ,certid varchar2(40) -- 证件编号
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_customer_alert to ${iml_schema};
grant select on ${iol_schema}.icms_customer_alert to ${icl_schema};
grant select on ${iol_schema}.icms_customer_alert to ${idl_schema};
grant select on ${iol_schema}.icms_customer_alert to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_alert is '客户预警';
comment on column ${iol_schema}.icms_customer_alert.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_alert.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_alert.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_alert.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_alert.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_alert.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_alert.customername is '客户名称';
comment on column ${iol_schema}.icms_customer_alert.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_alert.username is '操作员名称';
comment on column ${iol_schema}.icms_customer_alert.certid is '证件编号';
comment on column ${iol_schema}.icms_customer_alert.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_alert.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_alert.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_alert.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_alert.etl_timestamp is 'ETL处理时间戳';
