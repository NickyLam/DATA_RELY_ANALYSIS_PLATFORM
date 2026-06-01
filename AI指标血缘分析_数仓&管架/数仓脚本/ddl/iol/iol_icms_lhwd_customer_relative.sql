/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_customer_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_customer_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_customer_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_customer_relative(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,relationship varchar2(10) -- 关联关系
    ,certtype varchar2(4) -- 证件类型
    ,certid varchar2(64) -- 证件号码
    ,relativename varchar2(200) -- 关联人名称
    ,mobile varchar2(32) -- 手机号码
    ,creditchannel varchar2(32) -- 授信渠道
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_lhwd_customer_relative to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_customer_relative to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_relative to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_customer_relative is '联合网贷关联人信息表';
comment on column ${iol_schema}.icms_lhwd_customer_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_customer_relative.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_customer_relative.relationship is '关联关系';
comment on column ${iol_schema}.icms_lhwd_customer_relative.certtype is '证件类型';
comment on column ${iol_schema}.icms_lhwd_customer_relative.certid is '证件号码';
comment on column ${iol_schema}.icms_lhwd_customer_relative.relativename is '关联人名称';
comment on column ${iol_schema}.icms_lhwd_customer_relative.mobile is '手机号码';
comment on column ${iol_schema}.icms_lhwd_customer_relative.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_customer_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_customer_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_customer_relative.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lhwd_customer_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_customer_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_customer_relative.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_customer_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_customer_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_customer_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_customer_relative.etl_timestamp is 'ETL处理时间戳';
