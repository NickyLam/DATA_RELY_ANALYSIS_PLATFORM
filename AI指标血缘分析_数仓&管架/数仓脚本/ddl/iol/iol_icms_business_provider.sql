/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_provider
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_provider
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_provider purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_provider(
    serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,objectno varchar2(64) -- 申请流水号
    ,linkman varchar2(160) -- 联系人
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,providerrole varchar2(64) -- 银行角色
    ,inputuserid varchar2(64) -- 登记人
    ,corporgid varchar2(64) -- 法人机构编号
    ,linkmantel varchar2(64) -- 联系方式
    ,objecttype varchar2(64) -- 申请类型
    ,providerno varchar2(30) -- 银行编号
    ,providername varchar2(200) -- 银行名称
    ,businesscurrency varchar2(3) -- 承贷币种
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,isagency varchar2(2) -- 是否代理
    ,updateuserid varchar2(64) -- 更新人
    ,businesssum number(24,6) -- 承贷金额
    ,relativeduebillno varchar2(30) -- 关联借据号
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
grant select on ${iol_schema}.icms_business_provider to ${iml_schema};
grant select on ${iol_schema}.icms_business_provider to ${icl_schema};
grant select on ${iol_schema}.icms_business_provider to ${idl_schema};
grant select on ${iol_schema}.icms_business_provider to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_provider is '其它提供贷款人';
comment on column ${iol_schema}.icms_business_provider.serialno is '流水号';
comment on column ${iol_schema}.icms_business_provider.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_provider.objectno is '申请流水号';
comment on column ${iol_schema}.icms_business_provider.linkman is '联系人';
comment on column ${iol_schema}.icms_business_provider.remark is '备注';
comment on column ${iol_schema}.icms_business_provider.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_provider.providerrole is '银行角色';
comment on column ${iol_schema}.icms_business_provider.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_provider.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_provider.linkmantel is '联系方式';
comment on column ${iol_schema}.icms_business_provider.objecttype is '申请类型';
comment on column ${iol_schema}.icms_business_provider.providerno is '银行编号';
comment on column ${iol_schema}.icms_business_provider.providername is '银行名称';
comment on column ${iol_schema}.icms_business_provider.businesscurrency is '承贷币种';
comment on column ${iol_schema}.icms_business_provider.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_provider.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_provider.isagency is '是否代理';
comment on column ${iol_schema}.icms_business_provider.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_provider.businesssum is '承贷金额';
comment on column ${iol_schema}.icms_business_provider.relativeduebillno is '关联借据号';
comment on column ${iol_schema}.icms_business_provider.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_provider.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_provider.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_provider.etl_timestamp is 'ETL处理时间戳';
