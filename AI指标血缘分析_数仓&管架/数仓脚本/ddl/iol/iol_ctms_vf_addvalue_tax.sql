/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_vf_addvalue_tax
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_vf_addvalue_tax
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_vf_addvalue_tax purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vf_addvalue_tax(
    accentry2id number(22,0) -- 分录ID
    ,accountingcode varchar2(768) -- 科目
    ,accountingdesc varchar2(150) -- 科目名称
    ,productcode varchar2(36) -- 产品
    ,business varchar2(2) -- 业务场景
    ,taxtype varchar2(12) -- 计税方法
    ,rate varchar2(6) -- 税率
    ,taxcode varchar2(24) -- 税目
    ,feecode varchar2(192) -- 免税代码
    ,countnm number -- 期间收入累计数
    ,amount number -- 发生额
    ,fee varchar2(4000) -- 期间累计税额
    ,org_id varchar2(30) -- 记账机构
    ,settledate number(22,0) -- 报表日期
    ,currency varchar2(12) -- 币种
    ,source varchar2(6) -- 来源系统
    ,bundlecode number(22,0) -- 
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
grant select on ${iol_schema}.ctms_vf_addvalue_tax to ${iml_schema};
grant select on ${iol_schema}.ctms_vf_addvalue_tax to ${icl_schema};
grant select on ${iol_schema}.ctms_vf_addvalue_tax to ${idl_schema};
grant select on ${iol_schema}.ctms_vf_addvalue_tax to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_vf_addvalue_tax is '增值税报表视图';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.accentry2id is '分录ID';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.accountingcode is '科目';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.accountingdesc is '科目名称';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.productcode is '产品';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.business is '业务场景';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.taxtype is '计税方法';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.rate is '税率';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.taxcode is '税目';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.feecode is '免税代码';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.countnm is '期间收入累计数';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.amount is '发生额';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.fee is '期间累计税额';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.org_id is '记账机构';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.settledate is '报表日期';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.currency is '币种';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.source is '来源系统';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.bundlecode is '';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_vf_addvalue_tax.etl_timestamp is 'ETL处理时间戳';
