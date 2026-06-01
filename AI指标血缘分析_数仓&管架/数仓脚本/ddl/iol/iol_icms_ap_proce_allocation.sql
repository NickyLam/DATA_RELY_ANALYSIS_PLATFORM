/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_proce_allocation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_proce_allocation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_proce_allocation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_allocation(
    allocationno varchar2(64) -- 分配编号
    ,updatedate date -- 更新日期
    ,caseno varchar2(64) -- 关联案件项目编号
    ,allocationsum number(24,6) -- 分配比例/分配金额
    ,allocatableinfo varchar2(2000) -- 破产人剩余可分配信息
    ,ruleid varchar2(400) -- 裁定书号
    ,updateuserid varchar2(64) -- 更新人编号
    ,updateorgid varchar2(64) -- 更新机构编号
    ,decision varchar2(2000) -- 裁定书
    ,tmsp varchar2(64) -- 时间戳
    ,fileno varchar2(64) -- 影像平台编号
    ,ruledate date -- 裁定日期
    ,saveflag varchar2(12) -- 保存状态
    ,decisionid varchar2(400) -- 裁定文书号
    ,allocationdate date -- 分配日期
    ,inputdate date -- 登记日期
    ,remark varchar2(1000) -- 备注
    ,inputuserid varchar2(64) -- 登记人编号
    ,scheme varchar2(1000) -- 分配方案
    ,right varchar2(4000) -- 债权人特别权力
    ,inputorgid varchar2(64) -- 登记机构编号
    ,caseprogramstage varchar2(36) -- 程序阶段信息
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
grant select on ${iol_schema}.icms_ap_proce_allocation to ${iml_schema};
grant select on ${iol_schema}.icms_ap_proce_allocation to ${icl_schema};
grant select on ${iol_schema}.icms_ap_proce_allocation to ${idl_schema};
grant select on ${iol_schema}.icms_ap_proce_allocation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_proce_allocation is '破产分配信息表';
comment on column ${iol_schema}.icms_ap_proce_allocation.allocationno is '分配编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_proce_allocation.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.allocationsum is '分配比例/分配金额';
comment on column ${iol_schema}.icms_ap_proce_allocation.allocatableinfo is '破产人剩余可分配信息';
comment on column ${iol_schema}.icms_ap_proce_allocation.ruleid is '裁定书号';
comment on column ${iol_schema}.icms_ap_proce_allocation.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.decision is '裁定书';
comment on column ${iol_schema}.icms_ap_proce_allocation.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_proce_allocation.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.ruledate is '裁定日期';
comment on column ${iol_schema}.icms_ap_proce_allocation.saveflag is '保存状态';
comment on column ${iol_schema}.icms_ap_proce_allocation.decisionid is '裁定文书号';
comment on column ${iol_schema}.icms_ap_proce_allocation.allocationdate is '分配日期';
comment on column ${iol_schema}.icms_ap_proce_allocation.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_proce_allocation.remark is '备注';
comment on column ${iol_schema}.icms_ap_proce_allocation.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.scheme is '分配方案';
comment on column ${iol_schema}.icms_ap_proce_allocation.right is '债权人特别权力';
comment on column ${iol_schema}.icms_ap_proce_allocation.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_proce_allocation.caseprogramstage is '程序阶段信息';
comment on column ${iol_schema}.icms_ap_proce_allocation.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_proce_allocation.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_proce_allocation.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_proce_allocation.etl_timestamp is 'ETL处理时间戳';
