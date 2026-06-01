/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_share_expenses
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_share_expenses
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_share_expenses purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_share_expenses(
    shareno varchar2(64) -- 分摊记录编号
    ,expenseslist varchar2(36) -- 列支费用项目
    ,programno varchar2(64) -- 对应的处置方案编号
    ,expenses number(24,6) -- 列支费用金额
    ,expensesno varchar2(16) -- 费用支出记录编号
    ,programname varchar2(160) -- 对应的处置方案名称
    ,borrowerexpenses number(24,6) -- 属于当前借款人的列支费用金额
    ,contractno varchar2(64) -- 合同流水号
    ,guarantyname varchar2(1000) -- (拟)抵债资产名称
    ,currency varchar2(3) -- 列支费用币种
    ,guarantyid varchar2(64) -- (拟)抵债资产编号
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
grant select on ${iol_schema}.icms_ap_share_expenses to ${iml_schema};
grant select on ${iol_schema}.icms_ap_share_expenses to ${icl_schema};
grant select on ${iol_schema}.icms_ap_share_expenses to ${idl_schema};
grant select on ${iol_schema}.icms_ap_share_expenses to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_share_expenses is '费用支出分摊表';
comment on column ${iol_schema}.icms_ap_share_expenses.shareno is '分摊记录编号';
comment on column ${iol_schema}.icms_ap_share_expenses.expenseslist is '列支费用项目';
comment on column ${iol_schema}.icms_ap_share_expenses.programno is '对应的处置方案编号';
comment on column ${iol_schema}.icms_ap_share_expenses.expenses is '列支费用金额';
comment on column ${iol_schema}.icms_ap_share_expenses.expensesno is '费用支出记录编号';
comment on column ${iol_schema}.icms_ap_share_expenses.programname is '对应的处置方案名称';
comment on column ${iol_schema}.icms_ap_share_expenses.borrowerexpenses is '属于当前借款人的列支费用金额';
comment on column ${iol_schema}.icms_ap_share_expenses.contractno is '合同流水号';
comment on column ${iol_schema}.icms_ap_share_expenses.guarantyname is '(拟)抵债资产名称';
comment on column ${iol_schema}.icms_ap_share_expenses.currency is '列支费用币种';
comment on column ${iol_schema}.icms_ap_share_expenses.guarantyid is '(拟)抵债资产编号';
comment on column ${iol_schema}.icms_ap_share_expenses.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_share_expenses.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_share_expenses.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_share_expenses.etl_timestamp is 'ETL处理时间戳';
