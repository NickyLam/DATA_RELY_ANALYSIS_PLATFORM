/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_coll_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_coll_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_coll_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_coll_record(
    recordno varchar2(64) -- 催收记录编号
    ,guaranteetel varchar2(64) -- 担保人联系方式
    ,customername varchar2(200) -- 催收客户名称
    ,deliveryway varchar2(36) -- 送达方式
    ,projectno varchar2(64) -- 项目编号
    ,customertel varchar2(64) -- 催收客户联系方式
    ,guaranteeid varchar2(64) -- 担保人编号
    ,letterdate varchar2(64) -- 发函日期
    ,customerid varchar2(16) -- 催收客户ID
    ,debitsum number(24,6) -- 截止本日所欠本息金额总额
    ,latestpayment varchar2(36) -- 要求最迟还款日
    ,inputorgid varchar2(64) -- 登记机构
    ,guaranteename varchar2(400) -- 担保人名称
    ,updatedate varchar2(64) -- 更新日期
    ,guaranteeaddress varchar2(1000) -- 担保人地址
    ,tmsp varchar2(64) -- 时间戳
    ,recordtype varchar2(36) -- 记录类型
    ,guaranteesum number(24,6) -- 担保金额
    ,receipttype varchar2(36) -- 回执/公证类型
    ,customeraddress varchar2(1000) -- 催收客户地址
    ,deleteflag varchar2(12) -- 删除标志
    ,fileno varchar2(64) -- 影像平台编号
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,receiptdate varchar2(36) -- 回执日期/公证送达日期
    ,inputdate varchar2(64) -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,contractbalancesum number(24,6) -- 合同余额
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
grant select on ${iol_schema}.icms_ap_coll_record to ${iml_schema};
grant select on ${iol_schema}.icms_ap_coll_record to ${icl_schema};
grant select on ${iol_schema}.icms_ap_coll_record to ${idl_schema};
grant select on ${iol_schema}.icms_ap_coll_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_coll_record is '催收记录表';
comment on column ${iol_schema}.icms_ap_coll_record.recordno is '催收记录编号';
comment on column ${iol_schema}.icms_ap_coll_record.guaranteetel is '担保人联系方式';
comment on column ${iol_schema}.icms_ap_coll_record.customername is '催收客户名称';
comment on column ${iol_schema}.icms_ap_coll_record.deliveryway is '送达方式';
comment on column ${iol_schema}.icms_ap_coll_record.projectno is '项目编号';
comment on column ${iol_schema}.icms_ap_coll_record.customertel is '催收客户联系方式';
comment on column ${iol_schema}.icms_ap_coll_record.guaranteeid is '担保人编号';
comment on column ${iol_schema}.icms_ap_coll_record.letterdate is '发函日期';
comment on column ${iol_schema}.icms_ap_coll_record.customerid is '催收客户ID';
comment on column ${iol_schema}.icms_ap_coll_record.debitsum is '截止本日所欠本息金额总额';
comment on column ${iol_schema}.icms_ap_coll_record.latestpayment is '要求最迟还款日';
comment on column ${iol_schema}.icms_ap_coll_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_coll_record.guaranteename is '担保人名称';
comment on column ${iol_schema}.icms_ap_coll_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_coll_record.guaranteeaddress is '担保人地址';
comment on column ${iol_schema}.icms_ap_coll_record.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_coll_record.recordtype is '记录类型';
comment on column ${iol_schema}.icms_ap_coll_record.guaranteesum is '担保金额';
comment on column ${iol_schema}.icms_ap_coll_record.receipttype is '回执/公证类型';
comment on column ${iol_schema}.icms_ap_coll_record.customeraddress is '催收客户地址';
comment on column ${iol_schema}.icms_ap_coll_record.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_coll_record.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_coll_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_coll_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_coll_record.receiptdate is '回执日期/公证送达日期';
comment on column ${iol_schema}.icms_ap_coll_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_coll_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_coll_record.contractbalancesum is '合同余额';
comment on column ${iol_schema}.icms_ap_coll_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_coll_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_coll_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_coll_record.etl_timestamp is 'ETL处理时间戳';
