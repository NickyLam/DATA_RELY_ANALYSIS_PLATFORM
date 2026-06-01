/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_social
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_social
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_social purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_social(
    serialno varchar2(32) -- 流水号
    ,remark varchar2(500) -- 备注
    ,updatedate date -- 更新日期
    ,socialtype varchar2(18) -- 社交类型
    ,inputdate date -- 登记日期
    ,inputorgid varchar2(32) -- 登记机构
    ,updateorgid varchar2(32) -- 更新机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,socialno varchar2(400) -- 社交账号(网址)
    ,customerid varchar2(16) -- 客户编号
    ,updateuserid varchar2(32) -- 更新人
    ,inputuserid varchar2(32) -- 登记人
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
grant select on ${iol_schema}.icms_customer_social to ${iml_schema};
grant select on ${iol_schema}.icms_customer_social to ${icl_schema};
grant select on ${iol_schema}.icms_customer_social to ${idl_schema};
grant select on ${iol_schema}.icms_customer_social to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_social is '客户社交信息';
comment on column ${iol_schema}.icms_customer_social.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_social.remark is '备注';
comment on column ${iol_schema}.icms_customer_social.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_social.socialtype is '社交类型';
comment on column ${iol_schema}.icms_customer_social.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_social.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_social.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_social.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_social.socialno is '社交账号(网址)';
comment on column ${iol_schema}.icms_customer_social.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_social.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_social.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_social.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_social.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_social.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_social.etl_timestamp is 'ETL处理时间戳';
