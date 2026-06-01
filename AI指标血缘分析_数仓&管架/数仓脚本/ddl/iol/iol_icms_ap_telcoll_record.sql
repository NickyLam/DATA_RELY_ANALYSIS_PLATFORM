/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_telcoll_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_telcoll_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_telcoll_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_telcoll_record(
    recordno varchar2(64) -- 催收记录编号
    ,deliveryway varchar2(12) -- 送达方式
    ,customername varchar2(200) -- 催收客户名称
    ,collectusername varchar2(1000) -- 催收人员
    ,attachment varchar2(2000) -- 催收采集的相关照片、文件附件
    ,guarantyno varchar2(64) -- 担保合同编号
    ,updatedate varchar2(64) -- 更新日期
    ,contactway varchar2(64) -- 联系方式
    ,inputorgid varchar2(64) -- 登记机构
    ,customertype varchar2(36) -- 催收客户类型
    ,impawncondition varchar2(2000) -- 抵质押情况
    ,nextworkplan varchar2(2000) -- 下一步工作计划
    ,collectway varchar2(36) -- 催收方式
    ,receiptdate varchar2(64) -- 回执日期/公证送达日期
    ,tmsp varchar2(64) -- 时间戳
    ,inputdate varchar2(64) -- 登记日期
    ,deleteflag varchar2(12) -- 删除标志
    ,guaranteeway varchar2(2) -- 担保方式
    ,bankcontact varchar2(160) -- 银行方联系人
    ,updateorgid varchar2(64) -- 更新机构
    ,securitycondition varchar2(2000) -- 保全情况
    ,customerid varchar2(16) -- 催收客户ID
    ,collectdate varchar2(64) -- 催收日期
    ,collectuserid varchar2(1000) -- 催收人员编号
    ,collectprocess varchar2(4000) -- 催收过程
    ,updateuserid varchar2(64) -- 更新人
    ,assetno varchar2(64) -- 资产编号
    ,contractname varchar2(160) -- 合同名称
    ,receipttype varchar2(12) -- 回执/公证类型
    ,inputuserid varchar2(64) -- 登记人
    ,colleccontact varchar2(64) -- 催收人员联系方式
    ,collectresult varchar2(36) -- 催收结果
    ,latestpayment varchar2(64) -- 要求最迟还款日
    ,collectsite varchar2(2000) -- 催收地点
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
grant select on ${iol_schema}.icms_ap_telcoll_record to ${iml_schema};
grant select on ${iol_schema}.icms_ap_telcoll_record to ${icl_schema};
grant select on ${iol_schema}.icms_ap_telcoll_record to ${idl_schema};
grant select on ${iol_schema}.icms_ap_telcoll_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_telcoll_record is '催收记录表';
comment on column ${iol_schema}.icms_ap_telcoll_record.recordno is '催收记录编号';
comment on column ${iol_schema}.icms_ap_telcoll_record.deliveryway is '送达方式';
comment on column ${iol_schema}.icms_ap_telcoll_record.customername is '催收客户名称';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectusername is '催收人员';
comment on column ${iol_schema}.icms_ap_telcoll_record.attachment is '催收采集的相关照片、文件附件';
comment on column ${iol_schema}.icms_ap_telcoll_record.guarantyno is '担保合同编号';
comment on column ${iol_schema}.icms_ap_telcoll_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_telcoll_record.contactway is '联系方式';
comment on column ${iol_schema}.icms_ap_telcoll_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_telcoll_record.customertype is '催收客户类型';
comment on column ${iol_schema}.icms_ap_telcoll_record.impawncondition is '抵质押情况';
comment on column ${iol_schema}.icms_ap_telcoll_record.nextworkplan is '下一步工作计划';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectway is '催收方式';
comment on column ${iol_schema}.icms_ap_telcoll_record.receiptdate is '回执日期/公证送达日期';
comment on column ${iol_schema}.icms_ap_telcoll_record.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_telcoll_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_telcoll_record.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_telcoll_record.guaranteeway is '担保方式';
comment on column ${iol_schema}.icms_ap_telcoll_record.bankcontact is '银行方联系人';
comment on column ${iol_schema}.icms_ap_telcoll_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_telcoll_record.securitycondition is '保全情况';
comment on column ${iol_schema}.icms_ap_telcoll_record.customerid is '催收客户ID';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectdate is '催收日期';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectuserid is '催收人员编号';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectprocess is '催收过程';
comment on column ${iol_schema}.icms_ap_telcoll_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_telcoll_record.assetno is '资产编号';
comment on column ${iol_schema}.icms_ap_telcoll_record.contractname is '合同名称';
comment on column ${iol_schema}.icms_ap_telcoll_record.receipttype is '回执/公证类型';
comment on column ${iol_schema}.icms_ap_telcoll_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_telcoll_record.colleccontact is '催收人员联系方式';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectresult is '催收结果';
comment on column ${iol_schema}.icms_ap_telcoll_record.latestpayment is '要求最迟还款日';
comment on column ${iol_schema}.icms_ap_telcoll_record.collectsite is '催收地点';
comment on column ${iol_schema}.icms_ap_telcoll_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_telcoll_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_telcoll_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_telcoll_record.etl_timestamp is 'ETL处理时间戳';
