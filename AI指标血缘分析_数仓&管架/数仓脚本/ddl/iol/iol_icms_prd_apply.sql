/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_apply(
    serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,rcdstatus varchar2(10) -- 零售内部评级系统发布状态
    ,checkpassdate date -- 审批通过日期
    ,inputorgid varchar2(64) -- 登记机构
    ,approvestatus varchar2(64) -- 审批状态
    ,inputdate date -- 登记日期
    ,dealtype varchar2(10) -- OA系统发布指令
    ,productid varchar2(64) -- 产品编号
    ,publishstatus varchar2(64) -- 发布状态
    ,ncbsstatus varchar2(10) -- 新核心系统发布状态
    ,policyid varchar2(64) -- 产品政策编号
    ,inputuserid varchar2(64) -- 登记人
    ,corporgid varchar2(64) -- 法人机构编号
    ,productstatus varchar2(1) -- 产品状态
    ,publishdate date -- 发布日期
    ,changetype varchar2(10) -- 申请类型,码值:PrdChangeType
    ,versionid varchar2(64) -- 产品政策版本编号
    ,updateuserid varchar2(64) -- 更新人
    ,omchangeid varchar2(32) -- 变更类型编号
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
grant select on ${iol_schema}.icms_prd_apply to ${iml_schema};
grant select on ${iol_schema}.icms_prd_apply to ${icl_schema};
grant select on ${iol_schema}.icms_prd_apply to ${idl_schema};
grant select on ${iol_schema}.icms_prd_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_apply is '产品申请产品申请';
comment on column ${iol_schema}.icms_prd_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_prd_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_apply.rcdstatus is '零售内部评级系统发布状态';
comment on column ${iol_schema}.icms_prd_apply.checkpassdate is '审批通过日期';
comment on column ${iol_schema}.icms_prd_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_prd_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_apply.dealtype is 'OA系统发布指令';
comment on column ${iol_schema}.icms_prd_apply.productid is '产品编号';
comment on column ${iol_schema}.icms_prd_apply.publishstatus is '发布状态';
comment on column ${iol_schema}.icms_prd_apply.ncbsstatus is '新核心系统发布状态';
comment on column ${iol_schema}.icms_prd_apply.policyid is '产品政策编号';
comment on column ${iol_schema}.icms_prd_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_apply.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_apply.productstatus is '产品状态';
comment on column ${iol_schema}.icms_prd_apply.publishdate is '发布日期';
comment on column ${iol_schema}.icms_prd_apply.changetype is '申请类型,码值:PrdChangeType';
comment on column ${iol_schema}.icms_prd_apply.versionid is '产品政策版本编号';
comment on column ${iol_schema}.icms_prd_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_apply.omchangeid is '变更类型编号';
comment on column ${iol_schema}.icms_prd_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_apply.etl_timestamp is 'ETL处理时间戳';
