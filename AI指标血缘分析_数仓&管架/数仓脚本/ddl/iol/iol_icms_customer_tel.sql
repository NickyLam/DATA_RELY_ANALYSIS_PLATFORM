/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_tel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_tel
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_tel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_tel(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,updateorgid varchar2(64) -- 更新机构
    ,isinformation varchar2(2) -- 是否为短信接收号码
    ,inputdate date -- 登记日期
    ,intarea varchar2(36) -- 国际区号
    ,inputorgid varchar2(64) -- 登记机构
    ,informationtype varchar2(36) -- 接收短信语言类型
    ,telephone varchar2(75) -- 电话号码
    ,updatedate date -- 更新日期
    ,teltype varchar2(80) -- 电话类型
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,area varchar2(36) -- 区号
    ,remark varchar2(2000) -- 备注
    ,ext varchar2(64) -- 分机号
    ,isnew varchar2(2) -- 是否为最新
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_customer_tel to ${iml_schema};
grant select on ${iol_schema}.icms_customer_tel to ${icl_schema};
grant select on ${iol_schema}.icms_customer_tel to ${idl_schema};
grant select on ${iol_schema}.icms_customer_tel to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_tel is '客户电话';
comment on column ${iol_schema}.icms_customer_tel.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_tel.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_tel.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_tel.isinformation is '是否为短信接收号码';
comment on column ${iol_schema}.icms_customer_tel.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_tel.intarea is '国际区号';
comment on column ${iol_schema}.icms_customer_tel.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_tel.informationtype is '接收短信语言类型';
comment on column ${iol_schema}.icms_customer_tel.telephone is '电话号码';
comment on column ${iol_schema}.icms_customer_tel.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_tel.teltype is '电话类型';
comment on column ${iol_schema}.icms_customer_tel.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_tel.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_tel.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_tel.area is '区号';
comment on column ${iol_schema}.icms_customer_tel.remark is '备注';
comment on column ${iol_schema}.icms_customer_tel.ext is '分机号';
comment on column ${iol_schema}.icms_customer_tel.isnew is '是否为最新';
comment on column ${iol_schema}.icms_customer_tel.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_tel.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_tel.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_tel.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_tel.etl_timestamp is 'ETL处理时间戳';
