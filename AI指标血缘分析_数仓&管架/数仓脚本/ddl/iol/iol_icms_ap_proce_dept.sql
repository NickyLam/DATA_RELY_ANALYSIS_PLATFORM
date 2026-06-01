/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_proce_dept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_proce_dept
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_proce_dept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_dept(
    deptno varchar2(64) -- 抵债回款编号
    ,updateorgid varchar2(64) -- 更新机构编号
    ,deptdate date -- 抵债日期
    ,ruleorgdate date -- 出具裁定日期
    ,caseno varchar2(64) -- 关联案件项目编号
    ,updatedate varchar2(64) -- 更新日期
    ,inputdate date -- 登记日期
    ,ruleno varchar2(160) -- 裁定书编号
    ,inputuserid varchar2(64) -- 登记人编号
    ,inputorgid varchar2(64) -- 登记机构编号
    ,fileno varchar2(64) -- 影像平台编号
    ,updateuserid varchar2(64) -- 更新人编号
    ,saveflag varchar2(12) -- 以物抵债回款信息保存状态
    ,tmsp varchar2(64) -- 时间戳
    ,ruleorgname varchar2(1000) -- 出具裁定机构名称
    ,deptsum number(24,6) -- 抵债金额
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
grant select on ${iol_schema}.icms_ap_proce_dept to ${iml_schema};
grant select on ${iol_schema}.icms_ap_proce_dept to ${icl_schema};
grant select on ${iol_schema}.icms_ap_proce_dept to ${idl_schema};
grant select on ${iol_schema}.icms_ap_proce_dept to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_proce_dept is '以物抵债回款信息表';
comment on column ${iol_schema}.icms_ap_proce_dept.deptno is '抵债回款编号';
comment on column ${iol_schema}.icms_ap_proce_dept.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_proce_dept.deptdate is '抵债日期';
comment on column ${iol_schema}.icms_ap_proce_dept.ruleorgdate is '出具裁定日期';
comment on column ${iol_schema}.icms_ap_proce_dept.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_proce_dept.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_proce_dept.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_proce_dept.ruleno is '裁定书编号';
comment on column ${iol_schema}.icms_ap_proce_dept.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_proce_dept.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_proce_dept.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_proce_dept.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_proce_dept.saveflag is '以物抵债回款信息保存状态';
comment on column ${iol_schema}.icms_ap_proce_dept.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_proce_dept.ruleorgname is '出具裁定机构名称';
comment on column ${iol_schema}.icms_ap_proce_dept.deptsum is '抵债金额';
comment on column ${iol_schema}.icms_ap_proce_dept.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_proce_dept.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_proce_dept.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_proce_dept.etl_timestamp is 'ETL处理时间戳';
