/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_substitute_lawsuit_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_substitute_lawsuit_bill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_substitute_lawsuit_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_substitute_lawsuit_bill(
    serialno varchar2(64) -- 主键
    ,documentno varchar2(64) -- 借款单据号
    ,transtype varchar2(200) -- 单据交易类型
    ,borrowdate date -- 诉讼费借款单单据日期
    ,approvedate date -- 诉讼费借款单审核日期
    ,finishdate date -- 诉讼费借款单结算日期
    ,bdserialno varchar2(200) -- 借据号
    ,customerid varchar2(64) -- 客户号
    ,customername varchar2(200) -- 客户名
    ,amount number(24,6) -- 诉讼费金额
    ,balance number(24,6) -- 诉讼费余额
    ,inputuserid varchar2(8) -- 登记人
    ,inputorgid varchar2(12) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(8) -- 更新人
    ,updateorgid varchar2(12) -- 更新机构
    ,updatedate date -- 更新日期
    ,suitcancelfee number(24,6) -- 诉讼费核销金额
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
grant select on ${iol_schema}.icms_substitute_lawsuit_bill to ${iml_schema};
grant select on ${iol_schema}.icms_substitute_lawsuit_bill to ${icl_schema};
grant select on ${iol_schema}.icms_substitute_lawsuit_bill to ${idl_schema};
grant select on ${iol_schema}.icms_substitute_lawsuit_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_substitute_lawsuit_bill is '代垫诉讼费借据信息';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.serialno is '主键';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.documentno is '借款单据号';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.transtype is '单据交易类型';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.borrowdate is '诉讼费借款单单据日期';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.approvedate is '诉讼费借款单审核日期';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.finishdate is '诉讼费借款单结算日期';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.bdserialno is '借据号';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.customerid is '客户号';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.customername is '客户名';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.amount is '诉讼费金额';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.balance is '诉讼费余额';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.suitcancelfee is '诉讼费核销金额';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_substitute_lawsuit_bill.etl_timestamp is 'ETL处理时间戳';
