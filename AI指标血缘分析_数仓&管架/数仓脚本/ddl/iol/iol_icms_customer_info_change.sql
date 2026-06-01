/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_info_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_info_change
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_info_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_change(
    serialno varchar2(32) -- 流水号
    ,oldcerttype varchar2(18) -- 原证件类型
    ,oldcustomername varchar2(200) -- 原客户名称
    ,approveuserid varchar2(64) -- 终批人编号
    ,oldfictitiouspersoncertid varchar2(18) -- 原法定代表证件号码
    ,corporgid varchar2(32) -- 法人机构编号
    ,oldfictitiousperson varchar2(100) -- 原法定代表名称
    ,applyorgid varchar2(64) -- 申请人机构编号
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(32) -- 更新机构
    ,inputorgid varchar2(32) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,remark varchar2(500) -- 备注
    ,oldcertmaturity date -- 原证件到期日
    ,newcertid varchar2(18) -- 新证件号码
    ,approvestatus varchar2(64) -- 审批状态
    ,oldsubjectbusiness varchar2(800) -- 原主营业务
    ,newregisteradd varchar2(200) -- 新注册地址
    ,oldcertid varchar2(18) -- 原证件号码
    ,applyreason varchar2(400) -- 申请原因
    ,approvedate date -- 终批时间
    ,newsubjectbusiness varchar2(800) -- 新主营业务
    ,oldregisteradd varchar2(400) -- 原注册地址
    ,newcerttype varchar2(18) -- 新证件类型
    ,newloancardno varchar2(32) -- 新贷款卡编号
    ,updatedate date -- 更新日期
    ,oldfictitiouspersoncerttype varchar2(4) -- 原法定代表证件类型
    ,oldloancardno varchar2(32) -- 原贷款卡编号
    ,newfictitiouspersoncertid varchar2(18) -- 新法定代表证件号码
    ,newcustomername varchar2(200) -- 新客户名称
    ,applyuserid varchar2(64) -- 申请人编号
    ,newfictitiouspersoncerttype varchar2(4) -- 新法定代表证件类型
    ,inputuserid varchar2(32) -- 登记人
    ,applydate date -- 发起申请时间
    ,newcustomertype varchar2(18) -- 新客户类型
    ,approveorgid varchar2(64) -- 终批人机构编号
    ,newfictitiousperson varchar2(100) -- 新法定代表名称
    ,customerid varchar2(16) -- 客户编号
    ,customertype varchar2(18) -- 客户类型
    ,newcertmaturity date -- 新证件到期日
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
grant select on ${iol_schema}.icms_customer_info_change to ${iml_schema};
grant select on ${iol_schema}.icms_customer_info_change to ${icl_schema};
grant select on ${iol_schema}.icms_customer_info_change to ${idl_schema};
grant select on ${iol_schema}.icms_customer_info_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_info_change is '客户信息变更客户信息变更';
comment on column ${iol_schema}.icms_customer_info_change.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_info_change.oldcerttype is '原证件类型';
comment on column ${iol_schema}.icms_customer_info_change.oldcustomername is '原客户名称';
comment on column ${iol_schema}.icms_customer_info_change.approveuserid is '终批人编号';
comment on column ${iol_schema}.icms_customer_info_change.oldfictitiouspersoncertid is '原法定代表证件号码';
comment on column ${iol_schema}.icms_customer_info_change.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_info_change.oldfictitiousperson is '原法定代表名称';
comment on column ${iol_schema}.icms_customer_info_change.applyorgid is '申请人机构编号';
comment on column ${iol_schema}.icms_customer_info_change.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_info_change.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_info_change.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_info_change.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_info_change.remark is '备注';
comment on column ${iol_schema}.icms_customer_info_change.oldcertmaturity is '原证件到期日';
comment on column ${iol_schema}.icms_customer_info_change.newcertid is '新证件号码';
comment on column ${iol_schema}.icms_customer_info_change.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_customer_info_change.oldsubjectbusiness is '原主营业务';
comment on column ${iol_schema}.icms_customer_info_change.newregisteradd is '新注册地址';
comment on column ${iol_schema}.icms_customer_info_change.oldcertid is '原证件号码';
comment on column ${iol_schema}.icms_customer_info_change.applyreason is '申请原因';
comment on column ${iol_schema}.icms_customer_info_change.approvedate is '终批时间';
comment on column ${iol_schema}.icms_customer_info_change.newsubjectbusiness is '新主营业务';
comment on column ${iol_schema}.icms_customer_info_change.oldregisteradd is '原注册地址';
comment on column ${iol_schema}.icms_customer_info_change.newcerttype is '新证件类型';
comment on column ${iol_schema}.icms_customer_info_change.newloancardno is '新贷款卡编号';
comment on column ${iol_schema}.icms_customer_info_change.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_info_change.oldfictitiouspersoncerttype is '原法定代表证件类型';
comment on column ${iol_schema}.icms_customer_info_change.oldloancardno is '原贷款卡编号';
comment on column ${iol_schema}.icms_customer_info_change.newfictitiouspersoncertid is '新法定代表证件号码';
comment on column ${iol_schema}.icms_customer_info_change.newcustomername is '新客户名称';
comment on column ${iol_schema}.icms_customer_info_change.applyuserid is '申请人编号';
comment on column ${iol_schema}.icms_customer_info_change.newfictitiouspersoncerttype is '新法定代表证件类型';
comment on column ${iol_schema}.icms_customer_info_change.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_info_change.applydate is '发起申请时间';
comment on column ${iol_schema}.icms_customer_info_change.newcustomertype is '新客户类型';
comment on column ${iol_schema}.icms_customer_info_change.approveorgid is '终批人机构编号';
comment on column ${iol_schema}.icms_customer_info_change.newfictitiousperson is '新法定代表名称';
comment on column ${iol_schema}.icms_customer_info_change.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_info_change.customertype is '客户类型';
comment on column ${iol_schema}.icms_customer_info_change.newcertmaturity is '新证件到期日';
comment on column ${iol_schema}.icms_customer_info_change.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_info_change.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_info_change.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_info_change.etl_timestamp is 'ETL处理时间戳';
