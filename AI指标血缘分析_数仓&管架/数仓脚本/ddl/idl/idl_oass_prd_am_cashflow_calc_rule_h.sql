/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_am_cashflow_calc_rule_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_am_cashflow_calc_rule_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_am_cashflow_calc_rule_h(
etl_dt date --数据日期
,effect_dt date --生效日期
,accti_type_cd varchar2(60) --核算类型代码
,base_type_cd varchar2(60) --基数类型代码
,base_dt_type_cd varchar2(60) --基数日期类型代码
,int_accr_base_cd varchar2(60) --计息基准代码
,int_rat number(30,8) --利率
,init_int_rat_flg varchar2(60) --初始利率标志
,prod_id varchar2(60) --产品编号
,src_prod_id varchar2(60) --源产品编号
,brch_seq_num number(10,0) --分支序号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,cashflow_id varchar2(60) --现金流编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_prd_am_cashflow_calc_rule_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_am_cashflow_calc_rule_h is '资管现金流计算规则历史';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.accti_type_cd is '核算类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.base_type_cd is '基数类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.base_dt_type_cd is '基数日期类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.int_rat is '利率';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.init_int_rat_flg is '初始利率标志';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.src_prod_id is '源产品编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.brch_seq_num is '分支序号';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.cashflow_id is '现金流编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_calc_rule_h.lp_id is '法人编号';

