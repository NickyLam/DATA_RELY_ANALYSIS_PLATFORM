/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_repdataldx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_repdataldx
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_repdataldx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_repdataldx(
    custid varchar2(30) -- 客户号
    ,repno varchar2(8) -- 报表期数
    ,caliber varchar2(6) -- 报表口径
    ,nando varchar2(1) -- 新旧会计准则
    ,typecode varchar2(2) -- 报表类型
    ,currenttype varchar2(3) -- 币种代码
    ,countinghouse varchar2(60) -- 会计师事务所名称
    ,auditrepno varchar2(60) -- 审计报告编号
    ,auditrst varchar2(2000) -- 审计意见
    ,auditdate varchar2(10) -- 审计日期
    ,auditor varchar2(60) -- 审计人员名称
    ,mergescope varchar2(100) -- 合并范围
    ,repcustmgr varchar2(20) -- 客户经理
    ,credibility varchar2(6) -- 财务可信度
    ,submitdate varchar2(10) -- 提交时间
    ,state varchar2(1) -- 状态
    ,regioncode varchar2(4) -- 地区号
    ,jsstate varchar2(1) -- 解锁状态0未解锁1解锁
    ,jzdate varchar2(10) -- 报表截止日期
    ,unit varchar2(10) -- 报表单位
    ,inputdate varchar2(10) -- 登记日期
    ,updatedate varchar2(10) -- 修改日期
    ,repperiod varchar2(1) -- 报表周期
    ,isaudit varchar2(1) -- 是否审计：1审计 0未审计
    ,inputorg varchar2(30) -- 登记机构
    ,inputuser varchar2(30) -- 登记人
    ,recordno varchar2(32) -- 报表流水号（信贷）
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_ci_repdataldx to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_repdataldx to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_repdataldx to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_repdataldx to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_repdataldx is '财务报表基本信息';
comment on column ${iol_schema}.nrrs_ci_repdataldx.custid is '客户号';
comment on column ${iol_schema}.nrrs_ci_repdataldx.repno is '报表期数';
comment on column ${iol_schema}.nrrs_ci_repdataldx.caliber is '报表口径';
comment on column ${iol_schema}.nrrs_ci_repdataldx.nando is '新旧会计准则';
comment on column ${iol_schema}.nrrs_ci_repdataldx.typecode is '报表类型';
comment on column ${iol_schema}.nrrs_ci_repdataldx.currenttype is '币种代码';
comment on column ${iol_schema}.nrrs_ci_repdataldx.countinghouse is '会计师事务所名称';
comment on column ${iol_schema}.nrrs_ci_repdataldx.auditrepno is '审计报告编号';
comment on column ${iol_schema}.nrrs_ci_repdataldx.auditrst is '审计意见';
comment on column ${iol_schema}.nrrs_ci_repdataldx.auditdate is '审计日期';
comment on column ${iol_schema}.nrrs_ci_repdataldx.auditor is '审计人员名称';
comment on column ${iol_schema}.nrrs_ci_repdataldx.mergescope is '合并范围';
comment on column ${iol_schema}.nrrs_ci_repdataldx.repcustmgr is '客户经理';
comment on column ${iol_schema}.nrrs_ci_repdataldx.credibility is '财务可信度';
comment on column ${iol_schema}.nrrs_ci_repdataldx.submitdate is '提交时间';
comment on column ${iol_schema}.nrrs_ci_repdataldx.state is '状态';
comment on column ${iol_schema}.nrrs_ci_repdataldx.regioncode is '地区号';
comment on column ${iol_schema}.nrrs_ci_repdataldx.jsstate is '解锁状态0未解锁1解锁';
comment on column ${iol_schema}.nrrs_ci_repdataldx.jzdate is '报表截止日期';
comment on column ${iol_schema}.nrrs_ci_repdataldx.unit is '报表单位';
comment on column ${iol_schema}.nrrs_ci_repdataldx.inputdate is '登记日期';
comment on column ${iol_schema}.nrrs_ci_repdataldx.updatedate is '修改日期';
comment on column ${iol_schema}.nrrs_ci_repdataldx.repperiod is '报表周期';
comment on column ${iol_schema}.nrrs_ci_repdataldx.isaudit is '是否审计：1审计 0未审计';
comment on column ${iol_schema}.nrrs_ci_repdataldx.inputorg is '登记机构';
comment on column ${iol_schema}.nrrs_ci_repdataldx.inputuser is '登记人';
comment on column ${iol_schema}.nrrs_ci_repdataldx.recordno is '报表流水号（信贷）';
comment on column ${iol_schema}.nrrs_ci_repdataldx.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_repdataldx.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_repdataldx.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_repdataldx.etl_timestamp is 'ETL处理时间戳';
