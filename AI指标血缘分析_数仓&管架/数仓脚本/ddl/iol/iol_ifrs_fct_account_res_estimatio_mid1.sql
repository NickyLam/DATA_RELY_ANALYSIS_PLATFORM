/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_fct_account_res_estimatio_mid1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1(
    dt date -- 数据日期
    ,three_cd varchar2(150) -- 三分类
    ,org varchar2(30) -- 机构
    ,ccy varchar2(15) -- 币种
    ,sub_name varchar2(75) -- 科目名
    ,sub varchar2(60) -- 科目号
    ,dac varchar2(15) -- 借贷标识
    ,report_acc_cur_debit number(26,4) -- 报表：总账借方本期余额
    ,report_acc_cur_credit number(26,4) -- 报表：总账贷方本期余额
    ,debit_pv_cur number(26,4) -- 借方公允价值变动（t1-t2）rh
    ,credit_pv_cur number(26,4) -- 方公允价值变动（t1-t2）rh
    ,report_acc_cur_deibt_dis number(26,4) -- 报表：轧差借方
    ,report_acc_cur_credit_dis number(26,4) -- 报表：轧差贷方
    ,to_acc_cur_debit number(26,4) -- 总账借方本期余额
    ,to_acc_cur_credit number(26,4) -- 总账贷方本期余额
    ,to_acc_cur_debit_dis number(26,4) -- 入账：轧差借方r
    ,to_acc_cur_credit_dis number(26,4) -- 入账：轧差贷方r
    ,v_sub_before varchar2(75) -- 拼接科目码
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
grant select on ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 to ${iml_schema};
grant select on ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 to ${icl_schema};
grant select on ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 to ${idl_schema};
grant select on ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 is 'I9估值分录结果表';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.dt is '数据日期';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.three_cd is '三分类';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.org is '机构';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.ccy is '币种';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.sub_name is '科目名';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.sub is '科目号';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.dac is '借贷标识';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.report_acc_cur_debit is '报表：总账借方本期余额';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.report_acc_cur_credit is '报表：总账贷方本期余额';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.debit_pv_cur is '借方公允价值变动（t1-t2）rh';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.credit_pv_cur is '方公允价值变动（t1-t2）rh';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.report_acc_cur_deibt_dis is '报表：轧差借方';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.report_acc_cur_credit_dis is '报表：轧差贷方';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.to_acc_cur_debit is '总账借方本期余额';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.to_acc_cur_credit is '总账贷方本期余额';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.to_acc_cur_debit_dis is '入账：轧差借方r';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.to_acc_cur_credit_dis is '入账：轧差贷方r';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.v_sub_before is '拼接科目码';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_fct_account_res_estimatio_mid1.etl_timestamp is 'ETL处理时间戳';
