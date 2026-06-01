/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_proce_reform
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_proce_reform
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_proce_reform purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_reform(
    reformno varchar2(64) -- 重整编号
    ,caseno varchar2(64) -- 关联案件项目编号
    ,inputuserid varchar2(64) -- 登记人编号
    ,decision varchar2(2000) -- 裁定书
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构编号
    ,saveflag varchar2(12) -- 保存状态
    ,remark varchar2(1000) -- 备注
    ,updateuserid varchar2(64) -- 更新人编号
    ,updatedate date -- 更新日期
    ,advice varchar2(2000) -- 银行审批意见
    ,startdate date -- 重整开始日期
    ,isreform varchar2(12) -- 是否启动破产重整程序
    ,applydate date -- 申请日期
    ,fileno varchar2(64) -- 影像平台编号
    ,enddate date -- 重整结束日期
    ,ruleid varchar2(160) -- 裁定书号
    ,reformresult varchar2(1000) -- 重整结果
    ,result varchar2(1000) -- 重整结果
    ,proposername varchar2(400) -- 申请人
    ,scheme varchar2(2000) -- 重整方案
    ,tmsp varchar2(64) -- 时间戳
    ,proposerid varchar2(64) -- 申请人编号
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
grant select on ${iol_schema}.icms_ap_proce_reform to ${iml_schema};
grant select on ${iol_schema}.icms_ap_proce_reform to ${icl_schema};
grant select on ${iol_schema}.icms_ap_proce_reform to ${idl_schema};
grant select on ${iol_schema}.icms_ap_proce_reform to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_proce_reform is '破产重整信息表';
comment on column ${iol_schema}.icms_ap_proce_reform.reformno is '重整编号';
comment on column ${iol_schema}.icms_ap_proce_reform.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_proce_reform.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_proce_reform.decision is '裁定书';
comment on column ${iol_schema}.icms_ap_proce_reform.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_proce_reform.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_proce_reform.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_proce_reform.saveflag is '保存状态';
comment on column ${iol_schema}.icms_ap_proce_reform.remark is '备注';
comment on column ${iol_schema}.icms_ap_proce_reform.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_proce_reform.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_proce_reform.advice is '银行审批意见';
comment on column ${iol_schema}.icms_ap_proce_reform.startdate is '重整开始日期';
comment on column ${iol_schema}.icms_ap_proce_reform.isreform is '是否启动破产重整程序';
comment on column ${iol_schema}.icms_ap_proce_reform.applydate is '申请日期';
comment on column ${iol_schema}.icms_ap_proce_reform.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_proce_reform.enddate is '重整结束日期';
comment on column ${iol_schema}.icms_ap_proce_reform.ruleid is '裁定书号';
comment on column ${iol_schema}.icms_ap_proce_reform.reformresult is '重整结果';
comment on column ${iol_schema}.icms_ap_proce_reform.result is '重整结果';
comment on column ${iol_schema}.icms_ap_proce_reform.proposername is '申请人';
comment on column ${iol_schema}.icms_ap_proce_reform.scheme is '重整方案';
comment on column ${iol_schema}.icms_ap_proce_reform.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_proce_reform.proposerid is '申请人编号';
comment on column ${iol_schema}.icms_ap_proce_reform.caseprogramstage is '程序阶段信息';
comment on column ${iol_schema}.icms_ap_proce_reform.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_proce_reform.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_proce_reform.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_proce_reform.etl_timestamp is 'ETL处理时间戳';
