/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_cert
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_cert
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_cert purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_cert(
    serialno varchar2(64) -- 流水号
    ,inputorgid varchar2(12) -- 登记机构
    ,ismaincert varchar2(2) -- 是否主证件
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,idorgname varchar2(200) -- 证件签发机关名称
    ,customerid varchar2(16) -- 客户编号
    ,status varchar2(12) -- 证件状态
    ,certtype varchar2(4) -- 证件类型
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,certcountry varchar2(3) -- 证件国别
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,certmaturity date -- 证件到期日
    ,iddist varchar2(6) -- 证件签发机关所在地行政区划
    ,certid varchar2(60) -- 证件号码
    ,certstartdate date -- 证件起始日
    ,certcity varchar2(36) -- 证件签发城市
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_customer_cert to ${iml_schema};
grant select on ${iol_schema}.icms_customer_cert to ${icl_schema};
grant select on ${iol_schema}.icms_customer_cert to ${idl_schema};
grant select on ${iol_schema}.icms_customer_cert to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_cert is '公司客户证件信息';
comment on column ${iol_schema}.icms_customer_cert.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_cert.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_cert.ismaincert is '是否主证件';
comment on column ${iol_schema}.icms_customer_cert.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_cert.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_cert.idorgname is '证件签发机关名称';
comment on column ${iol_schema}.icms_customer_cert.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_cert.status is '证件状态';
comment on column ${iol_schema}.icms_customer_cert.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_cert.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_cert.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_cert.certcountry is '证件国别';
comment on column ${iol_schema}.icms_customer_cert.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_cert.remark is '备注';
comment on column ${iol_schema}.icms_customer_cert.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_cert.certmaturity is '证件到期日';
comment on column ${iol_schema}.icms_customer_cert.iddist is '证件签发机关所在地行政区划';
comment on column ${iol_schema}.icms_customer_cert.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_cert.certstartdate is '证件起始日';
comment on column ${iol_schema}.icms_customer_cert.certcity is '证件签发城市';
comment on column ${iol_schema}.icms_customer_cert.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_cert.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_cert.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_cert.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_cert.etl_timestamp is 'ETL处理时间戳';
