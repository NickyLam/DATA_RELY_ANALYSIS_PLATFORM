/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_adjuct_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_adjuct_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_adjuct_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_adjuct_contract(
    serialno varchar2(64) -- 流水号
    ,batnum varchar2(64) -- 批次号
    ,crdtid varchar2(64) -- 授信编号
    ,crdtchn varchar2(64) -- 授信渠道
    ,oldcrdtestimatlmt varchar2(32) -- 调整前授信预估额度
    ,oldcrdtdayrate varchar2(16) -- 调整前授信日利率
    ,oldcrdtyearrate varchar2(16) -- 调整前授信年利率
    ,newcrdtestimatlmt varchar2(32) -- 调整后授信预估额度
    ,newcrdtdayrate varchar2(16) -- 调整后授信日利率
    ,newcrdtyearrate varchar2(16) -- 调整后授信年利率
    ,crdtadjtyp varchar2(32) -- 授信调整类型
    ,platfspecdataprd varchar2(2048) -- 平台特色数据产品
    ,reqid varchar2(64) -- 请求ID
    ,rspopinion varchar2(32) -- 审批意见
    ,rejectreason varchar2(4000) -- 拒绝意见
    ,inputuserid varchar2(32) -- 录入人
    ,inputorgid varchar2(32) -- 录入机构
    ,inputdate date -- 录入日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
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
grant select on ${iol_schema}.icms_zjbk_adjuct_contract to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_adjuct_contract to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_adjuct_contract to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_adjuct_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_adjuct_contract is '字节额度变更申请';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.batnum is '批次号';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.crdtid is '授信编号';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.crdtchn is '授信渠道';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.oldcrdtestimatlmt is '调整前授信预估额度';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.oldcrdtdayrate is '调整前授信日利率';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.oldcrdtyearrate is '调整前授信年利率';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.newcrdtestimatlmt is '调整后授信预估额度';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.newcrdtdayrate is '调整后授信日利率';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.newcrdtyearrate is '调整后授信年利率';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.crdtadjtyp is '授信调整类型';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.platfspecdataprd is '平台特色数据产品';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.reqid is '请求ID';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.rspopinion is '审批意见';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.rejectreason is '拒绝意见';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.inputuserid is '录入人';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.inputdate is '录入日期';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_adjuct_contract.etl_timestamp is 'ETL处理时间戳';
