/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_report
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_report
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_report purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_report(
    reportno varchar2(32) -- 财报号
    ,reportflag varchar2(1) -- 报表检查标志
    ,currency varchar2(3) -- 币种
    ,inputorgid varchar2(32) -- 登记机构
    ,accountingmonth varchar2(18) -- 会计月
    ,hxtyzlsource varchar2(1000) -- 资料来源
    ,auditingagency varchar2(200) -- 审计机构
    ,remark varchar2(500) -- 注释
    ,inputuserid varchar2(32) -- 登记人
    ,accordingflag varchar2(10) -- 依据标志
    ,reportstatus varchar2(18) -- 状态
    ,auditopinion varchar2(1000) -- 审计意见
    ,warningresult varchar2(18) -- 预警结果
    ,updateorgid varchar2(32) -- 更新机构
    ,updateuserid varchar2(32) -- 更新人
    ,islock varchar2(1) -- 是否内评系统锁定：0-锁定1-正常
    ,auditflag varchar2(1) -- 审计标志
    ,updatedate date -- 更新日期
    ,reporttypeno varchar2(32) -- 财报类型编号
    ,reportscope varchar2(18) -- 报表口径
    ,monetaryunit varchar2(200) -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
    ,corporgid varchar2(32) -- 法人机构编号
    ,reportperiod varchar2(18) -- 报表周期
    ,auditdate date -- 审计时间
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputdate date -- 登记日期登记日期时间
    ,customerid varchar2(32) -- 客户编号
    ,deleteflag varchar2(1) -- 删除标志
    ,reportopinion varchar2(300) -- 报表注释
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
grant select on ${iol_schema}.icms_fina_report to ${iml_schema};
grant select on ${iol_schema}.icms_fina_report to ${icl_schema};
grant select on ${iol_schema}.icms_fina_report to ${idl_schema};
grant select on ${iol_schema}.icms_fina_report to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_report is '财报簿财报,财报簿 (每位客户可以拥有多个财报簿每个财报簿拥有多个财报表,如资产负债表,现金流量表) 原表名:customer_report';
comment on column ${iol_schema}.icms_fina_report.reportno is '财报号';
comment on column ${iol_schema}.icms_fina_report.reportflag is '报表检查标志';
comment on column ${iol_schema}.icms_fina_report.currency is '币种';
comment on column ${iol_schema}.icms_fina_report.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_report.accountingmonth is '会计月';
comment on column ${iol_schema}.icms_fina_report.hxtyzlsource is '资料来源';
comment on column ${iol_schema}.icms_fina_report.auditingagency is '审计机构';
comment on column ${iol_schema}.icms_fina_report.remark is '注释';
comment on column ${iol_schema}.icms_fina_report.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_report.accordingflag is '依据标志';
comment on column ${iol_schema}.icms_fina_report.reportstatus is '状态';
comment on column ${iol_schema}.icms_fina_report.auditopinion is '审计意见';
comment on column ${iol_schema}.icms_fina_report.warningresult is '预警结果';
comment on column ${iol_schema}.icms_fina_report.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_report.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_report.islock is '是否内评系统锁定：0-锁定1-正常';
comment on column ${iol_schema}.icms_fina_report.auditflag is '审计标志';
comment on column ${iol_schema}.icms_fina_report.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_report.reporttypeno is '财报类型编号';
comment on column ${iol_schema}.icms_fina_report.reportscope is '报表口径';
comment on column ${iol_schema}.icms_fina_report.monetaryunit is '货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.';
comment on column ${iol_schema}.icms_fina_report.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_fina_report.reportperiod is '报表周期';
comment on column ${iol_schema}.icms_fina_report.auditdate is '审计时间';
comment on column ${iol_schema}.icms_fina_report.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_fina_report.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_report.customerid is '客户编号';
comment on column ${iol_schema}.icms_fina_report.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_fina_report.reportopinion is '报表注释';
comment on column ${iol_schema}.icms_fina_report.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_report.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_report.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_report.etl_timestamp is 'ETL处理时间戳';
