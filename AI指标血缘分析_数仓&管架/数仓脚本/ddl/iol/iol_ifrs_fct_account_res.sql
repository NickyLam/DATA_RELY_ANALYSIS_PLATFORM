/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_fct_account_res
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_fct_account_res
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_fct_account_res purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_fct_account_res(
    dt date -- 数据日期
    ,org varchar2(15) -- 入账机构号
    ,ccy varchar2(15) -- 币种
    ,sub_name varchar2(90) -- 入账科目名称
    ,sub varchar2(30) -- 入账科目号(转换为借贷科目)
    ,dac varchar2(15) -- 借/贷方
    ,debit_cur number(26,5) -- 总账科目借方余额
    ,credit_cur number(26,5) -- 总账科目贷方余额
    ,debit_happen_cur number(26,5) -- 减值借方发生额
    ,credit_happen_cur number(26,5) -- 减值贷方发生额
    ,debit_currently_cur number(26,5) -- 科目借方余额
    ,credit_currently_cur number(26,5) -- 科目贷方余额
    ,v_asset_type_cd varchar2(15) -- 三分类
    ,v_sub_cd_before varchar2(30) -- 科目(旧)
    ,rep_debit_cur number(30,2) -- 报表借方余额
    ,rep_credit_cur number(30,2) -- 报表贷方余额
    ,rep_debit_currently_cur number(30,2) -- 报表科目借方余额
    ,rep_credit_currently_cur number(30,2) -- 报表科目贷方余额
    ,orderby_id number(22) -- 正常:1,国别风险:2
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
grant select on ${iol_schema}.ifrs_fct_account_res to ${iml_schema};
grant select on ${iol_schema}.ifrs_fct_account_res to ${icl_schema};
grant select on ${iol_schema}.ifrs_fct_account_res to ${idl_schema};
grant select on ${iol_schema}.ifrs_fct_account_res to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_fct_account_res is 'I9减值分录结果表';
comment on column ${iol_schema}.ifrs_fct_account_res.dt is '数据日期';
comment on column ${iol_schema}.ifrs_fct_account_res.org is '入账机构号';
comment on column ${iol_schema}.ifrs_fct_account_res.ccy is '币种';
comment on column ${iol_schema}.ifrs_fct_account_res.sub_name is '入账科目名称';
comment on column ${iol_schema}.ifrs_fct_account_res.sub is '入账科目号(转换为借贷科目)';
comment on column ${iol_schema}.ifrs_fct_account_res.dac is '借/贷方';
comment on column ${iol_schema}.ifrs_fct_account_res.debit_cur is '总账科目借方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.credit_cur is '总账科目贷方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.debit_happen_cur is '减值借方发生额';
comment on column ${iol_schema}.ifrs_fct_account_res.credit_happen_cur is '减值贷方发生额';
comment on column ${iol_schema}.ifrs_fct_account_res.debit_currently_cur is '科目借方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.credit_currently_cur is '科目贷方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.v_asset_type_cd is '三分类';
comment on column ${iol_schema}.ifrs_fct_account_res.v_sub_cd_before is '科目(旧)';
comment on column ${iol_schema}.ifrs_fct_account_res.rep_debit_cur is '报表借方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.rep_credit_cur is '报表贷方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.rep_debit_currently_cur is '报表科目借方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.rep_credit_currently_cur is '报表科目贷方余额';
comment on column ${iol_schema}.ifrs_fct_account_res.orderby_id is '正常:1,国别风险:2';
comment on column ${iol_schema}.ifrs_fct_account_res.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_fct_account_res.etl_timestamp is 'ETL处理时间戳';
