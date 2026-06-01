/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_dzhx_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_dzhx_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_dzhx_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dzhx_apply(
    serialno varchar2(32) -- 流水号
    ,hxtype varchar2(32) -- 核销类别
    ,customerid varchar2(32) -- 客户编号
    ,approvehxdate date -- 审批核销日期
    ,approvehxmoney number(24,6) -- 审批核销本金
    ,hxdfmoney number(24,6) -- 核销垫付费用
    ,resum number(24,6) -- 复息
    ,customername varchar2(200) -- 客户名称
    ,approvehxininterest number(24,6) -- 审批核销表内利息
    ,hxdate date -- 核销日期
    ,attribute1 number(24,6) -- 诉讼等垫付费用
    ,inputorgid varchar2(32) -- 登记机构
    ,approvehxoutinterest number(24,6) -- 审批核销表外利息
    ,balance number(24,6) -- 贷款余额
    ,commitflag varchar2(2) -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
    ,hxininterest number(24,6) -- 核销表内利息
    ,hxmoney number(24,6) -- 核销本金
    ,updatedate date -- 更新时间
    ,ifsearch varchar2(2) -- 是否保留对债务人的追索权
    ,interest number(24,6) -- 欠息
    ,inputuserid varchar2(32) -- 登记人
    ,duebillserialno varchar2(32) -- 借据编号
    ,currentuserid varchar2(32) -- 分发岗
    ,certtype varchar2(5) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,finebalance number(24,6) -- 罚息
    ,manager varchar2(32) -- 客户经理（管护人）
    ,businesstype varchar2(20) -- 业务品种
    ,approvehxinterest number(24,6) -- 审批核销利息
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(8) -- 更新人
    ,hxoutinterest number(24,6) -- 核销表外利息
    ,updateorgid varchar2(12) -- 更新人机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_dzhx_apply to ${iml_schema};
grant select on ${iol_schema}.icms_dzhx_apply to ${icl_schema};
grant select on ${iol_schema}.icms_dzhx_apply to ${idl_schema};
grant select on ${iol_schema}.icms_dzhx_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_dzhx_apply is '呆账核销申请表';
comment on column ${iol_schema}.icms_dzhx_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_dzhx_apply.hxtype is '核销类别';
comment on column ${iol_schema}.icms_dzhx_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_dzhx_apply.approvehxdate is '审批核销日期';
comment on column ${iol_schema}.icms_dzhx_apply.approvehxmoney is '审批核销本金';
comment on column ${iol_schema}.icms_dzhx_apply.hxdfmoney is '核销垫付费用';
comment on column ${iol_schema}.icms_dzhx_apply.resum is '复息';
comment on column ${iol_schema}.icms_dzhx_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_dzhx_apply.approvehxininterest is '审批核销表内利息';
comment on column ${iol_schema}.icms_dzhx_apply.hxdate is '核销日期';
comment on column ${iol_schema}.icms_dzhx_apply.attribute1 is '诉讼等垫付费用';
comment on column ${iol_schema}.icms_dzhx_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_dzhx_apply.approvehxoutinterest is '审批核销表外利息';
comment on column ${iol_schema}.icms_dzhx_apply.balance is '贷款余额';
comment on column ${iol_schema}.icms_dzhx_apply.commitflag is '提交状态（0客户经理1保全分发岗2保全经理及以上）';
comment on column ${iol_schema}.icms_dzhx_apply.hxininterest is '核销表内利息';
comment on column ${iol_schema}.icms_dzhx_apply.hxmoney is '核销本金';
comment on column ${iol_schema}.icms_dzhx_apply.updatedate is '更新时间';
comment on column ${iol_schema}.icms_dzhx_apply.ifsearch is '是否保留对债务人的追索权';
comment on column ${iol_schema}.icms_dzhx_apply.interest is '欠息';
comment on column ${iol_schema}.icms_dzhx_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_dzhx_apply.duebillserialno is '借据编号';
comment on column ${iol_schema}.icms_dzhx_apply.currentuserid is '分发岗';
comment on column ${iol_schema}.icms_dzhx_apply.certtype is '证件类型';
comment on column ${iol_schema}.icms_dzhx_apply.certid is '证件号码';
comment on column ${iol_schema}.icms_dzhx_apply.finebalance is '罚息';
comment on column ${iol_schema}.icms_dzhx_apply.manager is '客户经理（管护人）';
comment on column ${iol_schema}.icms_dzhx_apply.businesstype is '业务品种';
comment on column ${iol_schema}.icms_dzhx_apply.approvehxinterest is '审批核销利息';
comment on column ${iol_schema}.icms_dzhx_apply.inputdate is '登记时间';
comment on column ${iol_schema}.icms_dzhx_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_dzhx_apply.hxoutinterest is '核销表外利息';
comment on column ${iol_schema}.icms_dzhx_apply.updateorgid is '更新人机构';
comment on column ${iol_schema}.icms_dzhx_apply.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_dzhx_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_dzhx_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_dzhx_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_dzhx_apply.etl_timestamp is 'ETL处理时间戳';
