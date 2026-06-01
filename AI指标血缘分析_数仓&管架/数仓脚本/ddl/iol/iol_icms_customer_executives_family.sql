/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_executives_family
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_executives_family
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_executives_family purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_executives_family(
    serialno varchar2(64) -- 流水号
    ,inputorgid varchar2(32) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,certtype varchar2(4) -- 证件类型
    ,mainrelaname varchar2(200) -- 主要关系人姓名
    ,maincustomerid varchar2(32) -- 主借款人客户号
    ,mainrelanum varchar2(30) -- 主要关系人证件号码
    ,relaserialno varchar2(32) -- 关联流水号
    ,inputuserid varchar2(32) -- 登记人
    ,certid varchar2(60) -- 证件号码
    ,updateorgid varchar2(32) -- 更新机构
    ,status varchar2(6) -- 是否有效
    ,customername varchar2(100) -- 家族成员姓名
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,mainrelatype varchar2(40) -- 主要关系人证件类型
    ,remark varchar2(500) -- 备注
    ,corporgid varchar2(32) -- 法人机构编号
    ,customerid varchar2(32) -- 家族成员编号
    ,relationship varchar2(18) -- 关系
    ,loancardno varchar2(32) -- 贷款卡号
    ,describe varchar2(400) -- 家族成员所在企业名称
    ,workname varchar2(500) -- 工作单位
    ,inputdate date -- 登记日期
    ,migtoldvalue varchar2(250) -- 备份原字段值
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
grant select on ${iol_schema}.icms_customer_executives_family to ${iml_schema};
grant select on ${iol_schema}.icms_customer_executives_family to ${icl_schema};
grant select on ${iol_schema}.icms_customer_executives_family to ${idl_schema};
grant select on ${iol_schema}.icms_customer_executives_family to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_executives_family is '客户高管家族成员信息';
comment on column ${iol_schema}.icms_customer_executives_family.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_executives_family.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_executives_family.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_executives_family.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_executives_family.mainrelaname is '主要关系人姓名';
comment on column ${iol_schema}.icms_customer_executives_family.maincustomerid is '主借款人客户号';
comment on column ${iol_schema}.icms_customer_executives_family.mainrelanum is '主要关系人证件号码';
comment on column ${iol_schema}.icms_customer_executives_family.relaserialno is '关联流水号';
comment on column ${iol_schema}.icms_customer_executives_family.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_executives_family.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_executives_family.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_executives_family.status is '是否有效';
comment on column ${iol_schema}.icms_customer_executives_family.customername is '家族成员姓名';
comment on column ${iol_schema}.icms_customer_executives_family.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_executives_family.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_executives_family.mainrelatype is '主要关系人证件类型';
comment on column ${iol_schema}.icms_customer_executives_family.remark is '备注';
comment on column ${iol_schema}.icms_customer_executives_family.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_executives_family.customerid is '家族成员编号';
comment on column ${iol_schema}.icms_customer_executives_family.relationship is '关系';
comment on column ${iol_schema}.icms_customer_executives_family.loancardno is '贷款卡号';
comment on column ${iol_schema}.icms_customer_executives_family.describe is '家族成员所在企业名称';
comment on column ${iol_schema}.icms_customer_executives_family.workname is '工作单位';
comment on column ${iol_schema}.icms_customer_executives_family.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_executives_family.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_executives_family.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_executives_family.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_executives_family.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_executives_family.etl_timestamp is 'ETL处理时间戳';
