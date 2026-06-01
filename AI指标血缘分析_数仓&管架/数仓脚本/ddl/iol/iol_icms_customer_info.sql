/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info(
    customerid varchar2(16) -- 客户编号
    ,certmaturity date -- 证件到期日
    ,manageuserid varchar2(32) -- 主办客户经理
    ,inputdate date -- 登记日期
    ,isalarmsign varchar2(2) -- 是否预警客户
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,completeflag varchar2(1) -- 数据录入完整性标识
    ,certcountry varchar2(18) -- 证件国别
    ,certid varchar2(60) -- 证件号码
    ,inputuserid varchar2(32) -- 登记人
    ,status varchar2(6) -- 状态
    ,isassign varchar2(1) -- 是否分配(0未分配1已分配)
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(12) -- 登记机构
    ,yxcustomerid varchar2(10) -- 影像客户号
    ,updateorgid varchar2(32) -- 更新机构
    ,customername varchar2(200) -- 客户名称
    ,corporgid varchar2(32) -- 法人机构编号
    ,isselfbizcust varchar2(1) -- 是否自营客户
    ,certtype varchar2(4) -- 证件类型
    ,remark varchar2(500) -- 备注
    ,loancardno varchar2(50) -- 贷款卡号
    ,custflag varchar2(8) -- 客户标志：BZ-标准对公客户
    ,isimpoversee varchar2(2) -- 是否重点监测客户
    ,manageorgid varchar2(32) -- 管护机构
    ,isrelated varchar2(2) -- 是否我行关联方
    ,customertype varchar2(1) -- 客户分类
    ,updateuserid varchar2(32) -- 更新人
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,customertypelb varchar2(1) -- 客户类型
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
grant select on ${iol_schema}.icms_customer_info to ${iml_schema};
grant select on ${iol_schema}.icms_customer_info to ${icl_schema};
grant select on ${iol_schema}.icms_customer_info to ${idl_schema};
grant select on ${iol_schema}.icms_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_info is '客户基本信息';
comment on column ${iol_schema}.icms_customer_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_info.certmaturity is '证件到期日';
comment on column ${iol_schema}.icms_customer_info.manageuserid is '主办客户经理';
comment on column ${iol_schema}.icms_customer_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_info.isalarmsign is '是否预警客户';
comment on column ${iol_schema}.icms_customer_info.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_customer_info.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_customer_info.certcountry is '证件国别';
comment on column ${iol_schema}.icms_customer_info.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_info.status is '状态';
comment on column ${iol_schema}.icms_customer_info.isassign is '是否分配(0未分配1已分配)';
comment on column ${iol_schema}.icms_customer_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_info.yxcustomerid is '影像客户号';
comment on column ${iol_schema}.icms_customer_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_info.customername is '客户名称';
comment on column ${iol_schema}.icms_customer_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_info.isselfbizcust is '是否自营客户';
comment on column ${iol_schema}.icms_customer_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_info.remark is '备注';
comment on column ${iol_schema}.icms_customer_info.loancardno is '贷款卡号';
comment on column ${iol_schema}.icms_customer_info.custflag is '客户标志：BZ-标准对公客户';
comment on column ${iol_schema}.icms_customer_info.isimpoversee is '是否重点监测客户';
comment on column ${iol_schema}.icms_customer_info.manageorgid is '管护机构';
comment on column ${iol_schema}.icms_customer_info.isrelated is '是否我行关联方';
comment on column ${iol_schema}.icms_customer_info.customertype is '客户分类';
comment on column ${iol_schema}.icms_customer_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_info.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_customer_info.customertypelb is '客户类型';
comment on column ${iol_schema}.icms_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_info.etl_timestamp is 'ETL处理时间戳';
