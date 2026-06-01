/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_chb_month_report_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_chb_month_report_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_chb_month_report_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_chb_month_report_detail(
    termid varchar2(40) -- 期数
    ,reporttype varchar2(20) -- 报表类型：prod-产品，balance-资产负债表，deposit-结构性存款
    ,propertycode varchar2(40) -- 属性代码
    ,prodcounts number(10) -- 本期产品只数
    ,prodamount number(24,6) -- 本期总募集金额
    ,prodnetamount number(24,6) -- 本期净募集金额
    ,durationprodcounts number(10) -- 期末存续产品只数
    ,balance number(24,6) -- 期末余额
    ,bottombalance number(24,6) -- 期末余额（穿透后）
    ,customerprofit number(24,6) -- 本期客户收益
    ,bankprofit number(24,6) -- 本期银行收益
    ,prodyield number(24,6) -- 本期产品收益率
    ,detailuuid varchar2(72) -- 
    ,org_code varchar2(40) -- 机构代码
    ,dept_code varchar2(40) -- 部门代码
    ,reportuuid varchar2(72) -- 月报主表主键
    ,prodpayamount number(24,6) -- 本期兑付金额
    ,xgdurationprodcounts number(10,0) -- 合规新产品期末存续只数
    ,xgbalance number(24,6) -- 合规新产品期末余额
    ,xgbottombalance number(24,6) -- 合规新产品期末余额（穿透后）
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
grant select on ${iol_schema}.fams_chb_month_report_detail to ${iml_schema};
grant select on ${iol_schema}.fams_chb_month_report_detail to ${icl_schema};
grant select on ${iol_schema}.fams_chb_month_report_detail to ${idl_schema};
grant select on ${iol_schema}.fams_chb_month_report_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_chb_month_report_detail is '月报明细表';
comment on column ${iol_schema}.fams_chb_month_report_detail.termid is '期数';
comment on column ${iol_schema}.fams_chb_month_report_detail.reporttype is '报表类型：prod-产品，balance-资产负债表，deposit-结构性存款';
comment on column ${iol_schema}.fams_chb_month_report_detail.propertycode is '属性代码';
comment on column ${iol_schema}.fams_chb_month_report_detail.prodcounts is '本期产品只数';
comment on column ${iol_schema}.fams_chb_month_report_detail.prodamount is '本期总募集金额';
comment on column ${iol_schema}.fams_chb_month_report_detail.prodnetamount is '本期净募集金额';
comment on column ${iol_schema}.fams_chb_month_report_detail.durationprodcounts is '期末存续产品只数';
comment on column ${iol_schema}.fams_chb_month_report_detail.balance is '期末余额';
comment on column ${iol_schema}.fams_chb_month_report_detail.bottombalance is '期末余额（穿透后）';
comment on column ${iol_schema}.fams_chb_month_report_detail.customerprofit is '本期客户收益';
comment on column ${iol_schema}.fams_chb_month_report_detail.bankprofit is '本期银行收益';
comment on column ${iol_schema}.fams_chb_month_report_detail.prodyield is '本期产品收益率';
comment on column ${iol_schema}.fams_chb_month_report_detail.detailuuid is '';
comment on column ${iol_schema}.fams_chb_month_report_detail.org_code is '机构代码';
comment on column ${iol_schema}.fams_chb_month_report_detail.dept_code is '部门代码';
comment on column ${iol_schema}.fams_chb_month_report_detail.reportuuid is '月报主表主键';
comment on column ${iol_schema}.fams_chb_month_report_detail.prodpayamount is '本期兑付金额';
comment on column ${iol_schema}.fams_chb_month_report_detail.xgdurationprodcounts is '合规新产品期末存续只数';
comment on column ${iol_schema}.fams_chb_month_report_detail.xgbalance is '合规新产品期末余额';
comment on column ${iol_schema}.fams_chb_month_report_detail.xgbottombalance is '合规新产品期末余额（穿透后）';
comment on column ${iol_schema}.fams_chb_month_report_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_chb_month_report_detail.etl_timestamp is 'ETL处理时间戳';
