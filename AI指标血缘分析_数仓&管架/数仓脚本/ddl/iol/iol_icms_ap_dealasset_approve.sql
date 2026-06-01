/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_dealasset_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_dealasset_approve
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_dealasset_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_dealasset_approve(
    serialno varchar2(64) -- 流水号
    ,assetsource varchar2(36) -- 抵债资产来源
    ,landtype varchar2(2000) -- 用地性质
    ,guarantyrightname varchar2(160) -- 抵债资产权证名称
    ,buildingdate date -- 建成日期
    ,programname varchar2(1000) -- 方案名称
    ,evalorgid varchar2(64) -- 评估机构
    ,guarantylocation varchar2(1000) -- 抵债资产地址
    ,totalbalance number(24,6) -- 合同余额合计
    ,inputorgid varchar2(64) -- 登记机构
    ,approvereport varchar2(2000) -- 抵债资产处置审批书
    ,ownertax number(24,6) -- 买方应承担税费
    ,updatedate date -- 更新日期
    ,guarantyscale number(18,2) -- 抵债资产面积
    ,evalvalue number(24,6) -- 评估价值
    ,updateorgid varchar2(64) -- 更新机构
    ,assetspayway varchar2(36) -- 抵债方式
    ,guarantytype varchar2(64) -- 抵债物类型
    ,banktax number(24,6) -- 我行过户应承担税费
    ,ownername varchar2(160) -- 抵债资产所有权人名称
    ,deleteflag varchar2(12) -- 删除标识
    ,programno varchar2(64) -- 方案编号
    ,ownerid varchar2(64) -- 抵债资产所有权人
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,approveno varchar2(64) -- 批复编号
    ,inputdate date -- 登记日期
    ,guarantyname varchar2(1000) -- 抵债资产名称
    ,guarantyrightid varchar2(64) -- 抵债资产权证号
    ,handletype varchar2(36) -- 处置类型
    ,approvestatus varchar2(36) -- 审批状态
    ,remark varchar2(1000) -- 备注
    ,guarantyid varchar2(64) -- 抵债资产编号
    ,buildingstructure varchar2(1000) -- 建筑结构
    ,applyreport varchar2(2000) -- 抵债资产处置申请报告
    ,guarantycondition varchar2(4000) -- 抵债资产现状
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
grant select on ${iol_schema}.icms_ap_dealasset_approve to ${iml_schema};
grant select on ${iol_schema}.icms_ap_dealasset_approve to ${icl_schema};
grant select on ${iol_schema}.icms_ap_dealasset_approve to ${idl_schema};
grant select on ${iol_schema}.icms_ap_dealasset_approve to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_dealasset_approve is '处置抵债资产方案批复表';
comment on column ${iol_schema}.icms_ap_dealasset_approve.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_dealasset_approve.assetsource is '抵债资产来源';
comment on column ${iol_schema}.icms_ap_dealasset_approve.landtype is '用地性质';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantyrightname is '抵债资产权证名称';
comment on column ${iol_schema}.icms_ap_dealasset_approve.buildingdate is '建成日期';
comment on column ${iol_schema}.icms_ap_dealasset_approve.programname is '方案名称';
comment on column ${iol_schema}.icms_ap_dealasset_approve.evalorgid is '评估机构';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantylocation is '抵债资产地址';
comment on column ${iol_schema}.icms_ap_dealasset_approve.totalbalance is '合同余额合计';
comment on column ${iol_schema}.icms_ap_dealasset_approve.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_dealasset_approve.approvereport is '抵债资产处置审批书';
comment on column ${iol_schema}.icms_ap_dealasset_approve.ownertax is '买方应承担税费';
comment on column ${iol_schema}.icms_ap_dealasset_approve.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantyscale is '抵债资产面积';
comment on column ${iol_schema}.icms_ap_dealasset_approve.evalvalue is '评估价值';
comment on column ${iol_schema}.icms_ap_dealasset_approve.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_dealasset_approve.assetspayway is '抵债方式';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantytype is '抵债物类型';
comment on column ${iol_schema}.icms_ap_dealasset_approve.banktax is '我行过户应承担税费';
comment on column ${iol_schema}.icms_ap_dealasset_approve.ownername is '抵债资产所有权人名称';
comment on column ${iol_schema}.icms_ap_dealasset_approve.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_dealasset_approve.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_dealasset_approve.ownerid is '抵债资产所有权人';
comment on column ${iol_schema}.icms_ap_dealasset_approve.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_dealasset_approve.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_dealasset_approve.approveno is '批复编号';
comment on column ${iol_schema}.icms_ap_dealasset_approve.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantyname is '抵债资产名称';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantyrightid is '抵债资产权证号';
comment on column ${iol_schema}.icms_ap_dealasset_approve.handletype is '处置类型';
comment on column ${iol_schema}.icms_ap_dealasset_approve.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_dealasset_approve.remark is '备注';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantyid is '抵债资产编号';
comment on column ${iol_schema}.icms_ap_dealasset_approve.buildingstructure is '建筑结构';
comment on column ${iol_schema}.icms_ap_dealasset_approve.applyreport is '抵债资产处置申请报告';
comment on column ${iol_schema}.icms_ap_dealasset_approve.guarantycondition is '抵债资产现状';
comment on column ${iol_schema}.icms_ap_dealasset_approve.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_dealasset_approve.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_dealasset_approve.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_dealasset_approve.etl_timestamp is 'ETL处理时间戳';
