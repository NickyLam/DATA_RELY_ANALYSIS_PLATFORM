/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_am_cashflow_plan_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_am_cashflow_plan_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_am_cashflow_plan_h(
etl_dt date --数据日期
,cashflow_seq_num varchar2(100) --现金流序号
,cashflow_cate_cd varchar2(30) --现金流类别代码
,nadj_calc_start_dt date --未调整计算开始日期
,nadj_calc_end_dt date --未调整计算结束日期
,nadj_plan_pay_dt date --未调整计划支付日期
,a_adjust_calc_start_dt date --调整后计算开始日期
,a_adjust_calc_end_dt date --调整后计算结束日期
,a_adjust_plan_pay_dt date --调整后计划支付日期
,calc_ped_days number(10,0) --计算周期天数
,integy_ped_start_dt date --完整周期开始日期
,integy_ped_end_dt date --完整周期结束日期
,integy_ped_days number(10,0) --完整周期天数
,plan_pay_pric number(30,14) --计划支付本金
,int_accr_pric number(30,14) --计息本金
,plan_pay_int number(30,14) --计划支付利息
,pay_int_flg varchar2(10) --支付利息标志
,plan_pay_amt number(30,14) --计划支付金额
,cashflow_base number(30,2) --现金流基数
,base_corp_type_cd varchar2(30) --基数单位类型代码
,year_pay_int_cnt number(10,0) --年付息次数
,fin_prod_id varchar2(100) --金融产品编号
,prod_cate_cd varchar2(30) --产品类别代码
,brch_seq_num varchar2(100) --分支序号
,pay_type_cd varchar2(30) --支付类型代码
,intrv_net_yld_rat number(30,14) --区间净收益率
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,cashflow_id varchar2(100) --现金流编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_prd_am_cashflow_plan_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_am_cashflow_plan_h is '资管现金流计划历史';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.cashflow_seq_num is '现金流序号';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.cashflow_cate_cd is '现金流类别代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.nadj_calc_start_dt is '未调整计算开始日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.nadj_calc_end_dt is '未调整计算结束日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.nadj_plan_pay_dt is '未调整计划支付日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.a_adjust_calc_start_dt is '调整后计算开始日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.a_adjust_calc_end_dt is '调整后计算结束日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.a_adjust_plan_pay_dt is '调整后计划支付日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.calc_ped_days is '计算周期天数';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.integy_ped_start_dt is '完整周期开始日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.integy_ped_end_dt is '完整周期结束日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.integy_ped_days is '完整周期天数';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.plan_pay_pric is '计划支付本金';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.int_accr_pric is '计息本金';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.plan_pay_int is '计划支付利息';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.pay_int_flg is '支付利息标志';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.plan_pay_amt is '计划支付金额';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.cashflow_base is '现金流基数';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.base_corp_type_cd is '基数单位类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.year_pay_int_cnt is '年付息次数';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.fin_prod_id is '金融产品编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.prod_cate_cd is '产品类别代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.brch_seq_num is '分支序号';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.pay_type_cd is '支付类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.intrv_net_yld_rat is '区间净收益率';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.cashflow_id is '现金流编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_plan_h.lp_id is '法人编号';

