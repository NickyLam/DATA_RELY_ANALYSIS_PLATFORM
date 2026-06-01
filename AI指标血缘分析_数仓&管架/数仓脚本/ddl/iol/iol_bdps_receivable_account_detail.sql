/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_receivable_account_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_receivable_account_detail
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_receivable_account_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_receivable_account_detail(
    acctna varchar2(60) -- 户名
    ,acctou varchar2(60) -- 转出账号
    ,bail_acctno varchar2(60) -- 保证金账号
    ,balance_acctno varchar2(60) -- 结算账户
    ,crcycd varchar2(3) -- 交易币种
    ,cuime varchar2(15) -- 计息方法
    ,cust_no varchar2(30) -- 客户号
    ,dtitcd varchar2(30) -- 核算科目
    ,froztg varchar2(2) -- 冻结/解冻标志
    ,id number -- 主键Id
    ,instrt number(11,7) -- 协议利率
    ,matudt varchar2(12) -- 到期日
    ,pssbtp varchar2(2) -- 处理子类型
    ,termcd varchar2(5) -- 利率档次
    ,tranam number(18,2) -- 交易金额
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
grant select on ${iol_schema}.bdps_receivable_account_detail to ${iml_schema};
grant select on ${iol_schema}.bdps_receivable_account_detail to ${icl_schema};
grant select on ${iol_schema}.bdps_receivable_account_detail to ${idl_schema};
grant select on ${iol_schema}.bdps_receivable_account_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_receivable_account_detail is '默认回款账户明细表';
comment on column ${iol_schema}.bdps_receivable_account_detail.acctna is '户名';
comment on column ${iol_schema}.bdps_receivable_account_detail.acctou is '转出账号';
comment on column ${iol_schema}.bdps_receivable_account_detail.bail_acctno is '保证金账号';
comment on column ${iol_schema}.bdps_receivable_account_detail.balance_acctno is '结算账户';
comment on column ${iol_schema}.bdps_receivable_account_detail.crcycd is '交易币种';
comment on column ${iol_schema}.bdps_receivable_account_detail.cuime is '计息方法';
comment on column ${iol_schema}.bdps_receivable_account_detail.cust_no is '客户号';
comment on column ${iol_schema}.bdps_receivable_account_detail.dtitcd is '核算科目';
comment on column ${iol_schema}.bdps_receivable_account_detail.froztg is '冻结/解冻标志';
comment on column ${iol_schema}.bdps_receivable_account_detail.id is '主键Id';
comment on column ${iol_schema}.bdps_receivable_account_detail.instrt is '协议利率';
comment on column ${iol_schema}.bdps_receivable_account_detail.matudt is '到期日';
comment on column ${iol_schema}.bdps_receivable_account_detail.pssbtp is '处理子类型';
comment on column ${iol_schema}.bdps_receivable_account_detail.termcd is '利率档次';
comment on column ${iol_schema}.bdps_receivable_account_detail.tranam is '交易金额';
comment on column ${iol_schema}.bdps_receivable_account_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdps_receivable_account_detail.etl_timestamp is 'ETL处理时间戳';
