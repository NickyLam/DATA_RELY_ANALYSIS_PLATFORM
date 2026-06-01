/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_bankloan5lclassification
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_bankloan5lclassification
whenever sqlerror continue none;
drop table ${iol_schema}.wind_bankloan5lclassification purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_bankloan5lclassification(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,report_period varchar2(12) -- 报告期
    ,loan_type varchar2(60) -- 贷款类型
    ,total_amount number(20,4) -- 合计金额
    ,loans_excl_discount number(20,4) -- 贷款(不含贴现)
    ,discount number(20,4) -- 贴现
    ,pastdueitems number(20,4) -- 逾期拆放同业及金融类公司
    ,othercreditasset number(20,4) -- 其他信贷资产
    ,proportion_of_ta number(20,4) -- 贷款占贷款总额比例(%)
    ,llimit_of_llr_accrualratio number(20,4) -- 贷款损失准备金计提比例下限(%)
    ,ulimit_of_llr_accrualratio number(20,4) -- 贷款损失准备金计提比例上限(%)
    ,proportion_of_sll number(20,4) -- 标准贷款损失计提比例(%)
    ,migration_rate number(20,4) -- 迁徙率(%)
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
grant select on ${iol_schema}.wind_bankloan5lclassification to ${iml_schema};
grant select on ${iol_schema}.wind_bankloan5lclassification to ${icl_schema};
grant select on ${iol_schema}.wind_bankloan5lclassification to ${idl_schema};
grant select on ${iol_schema}.wind_bankloan5lclassification to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_bankloan5lclassification is '银行五级分类贷款明细';
comment on column ${iol_schema}.wind_bankloan5lclassification.object_id is '对象ID';
comment on column ${iol_schema}.wind_bankloan5lclassification.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_bankloan5lclassification.report_period is '报告期';
comment on column ${iol_schema}.wind_bankloan5lclassification.loan_type is '贷款类型';
comment on column ${iol_schema}.wind_bankloan5lclassification.total_amount is '合计金额';
comment on column ${iol_schema}.wind_bankloan5lclassification.loans_excl_discount is '贷款(不含贴现)';
comment on column ${iol_schema}.wind_bankloan5lclassification.discount is '贴现';
comment on column ${iol_schema}.wind_bankloan5lclassification.pastdueitems is '逾期拆放同业及金融类公司';
comment on column ${iol_schema}.wind_bankloan5lclassification.othercreditasset is '其他信贷资产';
comment on column ${iol_schema}.wind_bankloan5lclassification.proportion_of_ta is '贷款占贷款总额比例(%)';
comment on column ${iol_schema}.wind_bankloan5lclassification.llimit_of_llr_accrualratio is '贷款损失准备金计提比例下限(%)';
comment on column ${iol_schema}.wind_bankloan5lclassification.ulimit_of_llr_accrualratio is '贷款损失准备金计提比例上限(%)';
comment on column ${iol_schema}.wind_bankloan5lclassification.proportion_of_sll is '标准贷款损失计提比例(%)';
comment on column ${iol_schema}.wind_bankloan5lclassification.migration_rate is '迁徙率(%)';
comment on column ${iol_schema}.wind_bankloan5lclassification.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_bankloan5lclassification.etl_timestamp is 'ETL处理时间戳';
