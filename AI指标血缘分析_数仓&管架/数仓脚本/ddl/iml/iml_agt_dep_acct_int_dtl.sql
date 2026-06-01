/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_int_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_int_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_int_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_int_dtl(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,int_provi_ped varchar2(10) -- 利息计提周期
    ,next_provi_dt date -- 下一计提日期
    ,last_provi_dt date -- 上一计提日期
    ,int_set_flg varchar2(10) -- 结息标志
    ,cap_flg varchar2(10) -- 资本化标志
    ,next_int_set_dt date -- 下一结息日期
    ,last_int_set_dt date -- 上一结息日期
    ,last_real_int_set_dt date -- 上一真实结息日期
    ,day_bf_last_int_set_dt date -- 日切前上一结息日期
    ,int_set_freq_cd varchar2(30) -- 结息频率代码
    ,provi_day number(10) -- 计提日
    ,pay_int_day number(10) -- 付息日
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,int_rat_effect_way_cd varchar2(30) -- 利率生效方式代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,int_rat_float_cate_cd varchar2(30) -- 利率浮动类别代码
    ,float_int_rat number(18,8) -- 浮动利率
    ,int_rat_float_ratio number(18,6) -- 利率浮动比例
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,exec_int_rat number(18,8) -- 执行利率
    ,deflt_int_rat number(18,8) -- 违约利率
    ,int_rat_seg_flg varchar2(10) -- 利率分段标志
    ,exec_int_rat_lolmi number(18,8) -- 执行利率下限
    ,exec_int_rat_uplmi number(18,8) -- 执行利率上限
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,acm_provi_int number(30,2) -- 累计计提利息
    ,accum number(30,2) -- 积数
    ,provi_day_provi_actl_amt number(30,2) -- 计提日计提实际金额
    ,provi_day_provi_int number(30,2) -- 计提日计提利息
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,ld_acm_provi_int number(30,2) -- 上日累计计提利息
    ,dep_term_provi_acm_int number(30,2) -- 存期计提累计利息
    ,int_adj_add_amt number(30,2) -- 利息调增金额
    ,provi_day_int_adj_amt number(30,2) -- 计提日利息调整金额
    ,ld_acm_int_adj_amt number(30,2) -- 上日累计利息调整金额
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,int_set_amt number(30,2) -- 结息金额
    ,int_set_day_int_amt number(30,2) -- 结息日利息金额
    ,int_accr_surp_days number(10) -- 计息剩余天数
    ,ld_bf_pay_int_amt number(30,2) -- 上日前付息金额
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,last_int_rat_start_use_way_cd varchar2(30) -- 上一利率启用方式代码
    ,int_rat_modif_day number(10) -- 利率变更日
    ,int_rat_modif_ped number(10) -- 利率变更周期
    ,accrd_nomal_int_rat_float_flg varchar2(10) -- 按正常利率浮动标志
    ,last_int_rat_modif_dt date -- 上一利率变更日期
    ,next_int_rat_modif_dt date -- 下一利率变更日期
    ,provi_begin_day number(10) -- 计提起始日
    ,currt_acm_int_accr_days number(10) -- 当期累计计息天数
    ,currt_last_provi_dt date -- 当期上一计提日期
    ,agt_prefr_amt number(30,2) -- 协议优惠金额
    ,int_amt number(30,2) -- 利息金额
    ,tax_category_cd varchar2(30) -- 税种代码
    ,tax_rat number(18,6) -- 税率
    ,sub_acct_fix_tax_rat number(18,6) -- 分户级固定税率
    ,sub_acct_tax_rat_float_ratio number(18,6) -- 分户级税率浮动比例
    ,sub_acct_tax_rat_float_point number(18,8) -- 分户级税率浮动点数
    ,curr_int_tax_acm_amt number(30,2) -- 本期利息税累计金额
    ,provi_day_int_tax_init_amt number(30,2) -- 计提日利息税原金额
    ,provi_day_int_tax number(30,2) -- 计提日利息税
    ,int_tax_bal number(30,8) -- 利息税差额
    ,int_set_day_int_tax number(30,2) -- 结息日利息税
    ,int_tax_acm_amt number(30,2) -- 利息税累计金额
    ,stock_int_tax number(30,2) -- 存量利息税
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
    ,agt_accum number(30,2) -- 协议积数
    ,agt_float_ratio number(18,6) -- 协议浮动比例
    ,sign_layered_int_rat_type_cd varchar2(30) -- 签约分层利率类型代码
    ,back_nature_day_days number(10) -- 回溯自然日天数
    ,back_wd_days number(10) -- 回溯工作日天数
    ,deduct_int_flg varchar2(10) -- 扣划利息标志
    ,cust_id varchar2(100) -- 客户编号
    ,tran_tm timestamp -- 交易时间
    ,int_rat_chg_flg varchar2(10) -- 利率变化标志
    ,discnt_int number(30,2) -- 折扣利息
    ,discnt_int_flg varchar2(10) -- 折扣利息标志
    ,int_rat_get_val_day number(10) -- 利率取值日
    ,acalc_flg varchar2(10) -- 重算标志
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,ld_acm_adj_dt date -- 上日累计调整日期
    ,ld_acm_paid_dt date -- 上日累计已付日期
    ,delay_pay_int_acm_amt number(30,2) -- 延迟付息累计金额
    ,up_ld_bf_pay_int number(30,2) -- 上上日前付息
    ,up_ld_acm_provi_int number(30,2) -- 上上日累计计提利息
    ,up_ld_int_adj number(30,2) -- 上上日利息调整
    ,delay_pay_int_acm_accti_amt number(30,2) -- 延迟付息累计供核算金额
    ,ld_delay_pay_int_acm_accti_amt number(30,2) -- 上日延迟付息累计供核算金额
    ,up_ld_delay_pay_int_acm_accti_amt number(30,2) -- 上上日延迟付息累计供核算金额
    ,curr_mon_daily_end_day_bal_sum number(30,2) -- 当前月份每日日终余额之和
    ,last_mon_daily_end_day_bal_sum number(30,2) -- 上月每日日终余额之和
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_dep_acct_int_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_int_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_int_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_int_dtl is '存款账户利息明细';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_provi_ped is '利息计提周期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.next_provi_dt is '下一计提日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_provi_dt is '上一计提日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_set_flg is '结息标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.cap_flg is '资本化标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_int_set_dt is '上一结息日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_real_int_set_dt is '上一真实结息日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.day_bf_last_int_set_dt is '日切前上一结息日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_set_freq_cd is '结息频率代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day is '计提日';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.pay_int_day is '付息日';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_effect_way_cd is '利率生效方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_float_cate_cd is '利率浮动类别代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_float_ratio is '利率浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.deflt_int_rat is '违约利率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_seg_flg is '利率分段标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.exec_int_rat_lolmi is '执行利率下限';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.exec_int_rat_uplmi is '执行利率上限';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.acm_provi_int is '累计计提利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.accum is '积数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day_provi_actl_amt is '计提日计提实际金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day_provi_int is '计提日计提利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_acm_provi_int is '上日累计计提利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.dep_term_provi_acm_int is '存期计提累计利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_adj_add_amt is '利息调增金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day_int_adj_amt is '计提日利息调整金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_acm_int_adj_amt is '上日累计利息调整金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_set_amt is '结息金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_set_day_int_amt is '结息日利息金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_accr_surp_days is '计息剩余天数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_bf_pay_int_amt is '上日前付息金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.value_dt is '起息日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_int_rat_start_use_way_cd is '上一利率启用方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_modif_day is '利率变更日';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_modif_ped is '利率变更周期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.accrd_nomal_int_rat_float_flg is '按正常利率浮动标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_int_rat_modif_dt is '上一利率变更日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.next_int_rat_modif_dt is '下一利率变更日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_begin_day is '计提起始日';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.currt_acm_int_accr_days is '当期累计计息天数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.currt_last_provi_dt is '当期上一计提日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.agt_prefr_amt is '协议优惠金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_amt is '利息金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.tax_category_cd is '税种代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.tax_rat is '税率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_fix_tax_rat is '分户级固定税率';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_tax_rat_float_ratio is '分户级税率浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sub_acct_tax_rat_float_point is '分户级税率浮动点数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.curr_int_tax_acm_amt is '本期利息税累计金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day_int_tax_init_amt is '计提日利息税原金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.provi_day_int_tax is '计提日利息税';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_tax_bal is '利息税差额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_set_day_int_tax is '结息日利息税';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_tax_acm_amt is '利息税累计金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.stock_int_tax is '存量利息税';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.agt_accum is '协议积数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.agt_float_ratio is '协议浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.sign_layered_int_rat_type_cd is '签约分层利率类型代码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.back_nature_day_days is '回溯自然日天数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.back_wd_days is '回溯工作日天数';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.deduct_int_flg is '扣划利息标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_chg_flg is '利率变化标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.discnt_int is '折扣利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.discnt_int_flg is '折扣利息标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.int_rat_get_val_day is '利率取值日';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.acalc_flg is '重算标志';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_acm_adj_dt is '上日累计调整日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_acm_paid_dt is '上日累计已付日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.delay_pay_int_acm_amt is '延迟付息累计金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.up_ld_bf_pay_int is '上上日前付息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.up_ld_acm_provi_int is '上上日累计计提利息';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.up_ld_int_adj is '上上日利息调整';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.delay_pay_int_acm_accti_amt is '延迟付息累计供核算金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.ld_delay_pay_int_acm_accti_amt is '上日延迟付息累计供核算金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.up_ld_delay_pay_int_acm_accti_amt is '上上日延迟付息累计供核算金额';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.curr_mon_daily_end_day_bal_sum is '当前月份每日日终余额之和';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.last_mon_daily_end_day_bal_sum is '上月每日日终余额之和';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_int_dtl.etl_timestamp is 'ETL处理时间戳';
