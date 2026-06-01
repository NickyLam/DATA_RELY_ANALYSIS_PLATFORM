/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_cash_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_cash_plan
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_cash_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_cash_plan(
    cash_id varchar2(32) -- 现金流代码
    ,cash_num number(10) -- 现金流序号，从1开始
    ,cash_type varchar2(50) -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
    ,vdate_unadjust date -- 未调整的计算开始日
    ,mdate_unadjust date -- 未调整的计算结束日
    ,pay_date_unadjust date -- 未调整的计划支付日
    ,vdate date -- 调整后的计算开始日
    ,mdate date -- 调整后的计算结束日
    ,pay_date date -- 调整后的计划支付日
    ,termdays number(10) -- 计算周期天数
    ,vdate_y date -- 理论计息年度开始日，a/a_bond适用
    ,vdate_term date -- 完整周期开始日
    ,mdate_term date -- 完整周期结束日
    ,termdays_term number(10) -- 完整周期天数
    ,prin_amt number(30,14) -- 计划支付本金，针对现金流类型为本金的
    ,int_prin_amt number(30,14) -- 计息本金，存计划支付利息对应的本金
    ,int_amt number(30,14) -- 计划支付利息，还本计息区间对应的利息
    ,is_pay_int varchar2(50) -- 是否支付利息，针对现金流类型为本金的
    ,cash_amt number(30,14) -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
    ,cash_baseamt number(30,2) -- 现金流基数，存100或者总金额的具体数值
    ,cash_unit_type varchar2(50) -- 现金流单位，单位、百元、 总金额
    ,calc_function varchar2(50) -- 计息算法，分摊法、累计法，目前无
    ,frequency number(10) -- 年付息次数
    ,finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,branch number(10) -- 分支序号
    ,pay_type varchar2(50) -- 支付方式，现金、红利再投等
    ,range_yield number(30,14) -- 区间净收益率
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,repay_without_int number(30,14) -- 区间还本未付利息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_cash_plan to ${iml_schema};
grant select on ${iol_schema}.fams_fin_cash_plan to ${icl_schema};
grant select on ${iol_schema}.fams_fin_cash_plan to ${idl_schema};
grant select on ${iol_schema}.fams_fin_cash_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_cash_plan is '现金流计划表';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_id is '现金流代码';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_num is '现金流序号，从1开始';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_type is '现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等';
comment on column ${iol_schema}.fams_fin_cash_plan.vdate_unadjust is '未调整的计算开始日';
comment on column ${iol_schema}.fams_fin_cash_plan.mdate_unadjust is '未调整的计算结束日';
comment on column ${iol_schema}.fams_fin_cash_plan.pay_date_unadjust is '未调整的计划支付日';
comment on column ${iol_schema}.fams_fin_cash_plan.vdate is '调整后的计算开始日';
comment on column ${iol_schema}.fams_fin_cash_plan.mdate is '调整后的计算结束日';
comment on column ${iol_schema}.fams_fin_cash_plan.pay_date is '调整后的计划支付日';
comment on column ${iol_schema}.fams_fin_cash_plan.termdays is '计算周期天数';
comment on column ${iol_schema}.fams_fin_cash_plan.vdate_y is '理论计息年度开始日，a/a_bond适用';
comment on column ${iol_schema}.fams_fin_cash_plan.vdate_term is '完整周期开始日';
comment on column ${iol_schema}.fams_fin_cash_plan.mdate_term is '完整周期结束日';
comment on column ${iol_schema}.fams_fin_cash_plan.termdays_term is '完整周期天数';
comment on column ${iol_schema}.fams_fin_cash_plan.prin_amt is '计划支付本金，针对现金流类型为本金的';
comment on column ${iol_schema}.fams_fin_cash_plan.int_prin_amt is '计息本金，存计划支付利息对应的本金';
comment on column ${iol_schema}.fams_fin_cash_plan.int_amt is '计划支付利息，还本计息区间对应的利息';
comment on column ${iol_schema}.fams_fin_cash_plan.is_pay_int is '是否支付利息，针对现金流类型为本金的';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_amt is '计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_baseamt is '现金流基数，存100或者总金额的具体数值';
comment on column ${iol_schema}.fams_fin_cash_plan.cash_unit_type is '现金流单位，单位、百元、 总金额';
comment on column ${iol_schema}.fams_fin_cash_plan.calc_function is '计息算法，分摊法、累计法，目前无';
comment on column ${iol_schema}.fams_fin_cash_plan.frequency is '年付息次数';
comment on column ${iol_schema}.fams_fin_cash_plan.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_cash_plan.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_cash_plan.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_cash_plan.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_cash_plan.pay_type is '支付方式，现金、红利再投等';
comment on column ${iol_schema}.fams_fin_cash_plan.range_yield is '区间净收益率';
comment on column ${iol_schema}.fams_fin_cash_plan.remark is '备注';
comment on column ${iol_schema}.fams_fin_cash_plan.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_cash_plan.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_cash_plan.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_cash_plan.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_cash_plan.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_cash_plan.repay_without_int is '区间还本未付利息';
comment on column ${iol_schema}.fams_fin_cash_plan.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_cash_plan.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_cash_plan.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_cash_plan.etl_timestamp is 'ETL处理时间戳';
