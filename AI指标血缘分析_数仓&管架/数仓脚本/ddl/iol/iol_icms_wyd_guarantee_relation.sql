/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_guarantee_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_guarantee_relation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_guarantee_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_guarantee_relation(
    datadt varchar2(10) -- 数据日期
    ,contractno varchar2(64) -- 合同号
    ,lendingref varchar2(64) -- 借据号
    ,guarcontractno varchar2(64) -- 担保合同号
    ,orgid varchar2(20) -- 机构号
    ,loanbalance number(20,4) -- 贷款余额
    ,guarantyamt number(20,4) -- 此笔贷款担保金额（保证人担保金额）
    ,guarantystat varchar2(1) -- 担保关系状态
    ,inputtime varchar2(10) -- 担保关系建立时间
    ,maturitydate varchar2(10) -- 担保关系解除日期
    ,merchantid varchar2(32) -- 平台ID
    ,loanquota number(20,4) -- 借款额度
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_wyd_guarantee_relation to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_relation to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_relation to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_guarantee_relation is '借据与担保合同关系';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.contractno is '合同号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.guarcontractno is '担保合同号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.loanbalance is '贷款余额';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.guarantyamt is '此笔贷款担保金额（保证人担保金额）';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.guarantystat is '担保关系状态';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.inputtime is '担保关系建立时间';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.maturitydate is '担保关系解除日期';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.merchantid is '平台ID';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.loanquota is '借款额度';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_guarantee_relation.etl_timestamp is 'ETL处理时间戳';
