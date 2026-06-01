/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_int_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_int_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_int_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_int_dtl_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,next_int_set_dt date -- 下一结息日期
    ,last_int_set_dt date -- 上一结息日期
    ,last_real_int_set_dt date -- 上一真实结息日期
    ,provi_day_provi_int number(30,2) -- 计提日计提利息
    ,curr_acm_provi_int number(30,2) -- 本期累计计提利息
    ,ld_acm_provi_int number(30,2) -- 上日累计计提利息
    ,provi_day_int_adj_amt number(30,2) -- 计提日利息调整金额
    ,acm_int_adj_amt number(30,2) -- 累计利息调整金额
    ,ld_acm_int_adj_amt number(30,2) -- 上日累计利息调整金额
    ,int_set_day_int_amt number(30,2) -- 结息日利息金额
    ,int_set_amt number(30,2) -- 结息金额
    ,ovdue_int number(30,2) -- 逾期利息
    ,ld_ovdue_int number(30,2) -- 上日逾期利息
    ,int_cap_amt number(30,2) -- 利息资本化金额
    ,last_int_provi_dt date -- 上一利息计提日期
    ,unrliz_int number(30,2) -- 未实现利息
    ,discnt_int_flg varchar2(10) -- 折扣利息标志
    ,discnt_pay_int number(30,2) -- 折扣付出利息
    ,discnt_pnlt_amt number(30,2) -- 折扣罚息金额
    ,discnt_int number(30,2) -- 折扣利息
    ,ld_bf_pay_int_amt number(30,2) -- 上日前付息金额
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,int_accr_surp_days number(10) -- 计息剩余天数
    ,provi_day_int_tax number(30,2) -- 计提日利息税
    ,currt_int_tax_acm_amt number(30,2) -- 当期利息税累计金额
    ,int_set_day_int_tax number(30,2) -- 结息日利息税
    ,int_tax_acm_amt number(30,2) -- 利息税累计金额
    ,day_cut_bf_last_int_set_dt date -- 日切前上一结息日期
    ,next_provi_dt date -- 下一计提日期
    ,provi_accum number(30,2) -- 计提积数
    ,agt_accum number(30,2) -- 协议积数
    ,provi_actl_amt number(30,2) -- 计提实际金额
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,int_amt number(30,2) -- 利息金额
    ,int_tax_lmt number(30,2) -- 利息税金额
    ,int_tax_bal number(30,8) -- 利息税差额
    ,currt_acm_int_accr_days number(10) -- 当期累计计息天数
    ,currt_acm_amorted_provi_amt number(30,2) -- 当期累计已摊销计提金额
    ,last_provi_dt date -- 上一计提日期
    ,back_nature_day_days number(10) -- 回溯自然日天数
    ,back_wd_days number(10) -- 回溯工作日天数
    ,acct_stl_dt date -- 账户结算日期
    ,stock_int_tax number(30,2) -- 存量利息税
    ,provi_begin_day number(10) -- 计提起始日
    ,agt_prefr_amt number(30,2) -- 协议优惠金额
    ,agt_int number(30,2) -- 协议利息
    ,last_int_calc_dt date -- 上一利息计算日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,last_activ_acct_dt date -- 上次动户日期
    ,up_ld_acm_provi_int number(30,2) -- 上上日累计计提利息
    ,up_ld_int_acm_provi_adj number(30,2) -- 上上日利息累计计提调整
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_acct_int_dtl_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_int_dtl_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_int_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_int_dtl_h is '贷款账户利息明细历史';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_int_set_dt is '上一结息日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_real_int_set_dt is '上一真实结息日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_day_provi_int is '计提日计提利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.curr_acm_provi_int is '本期累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.ld_acm_provi_int is '上日累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_day_int_adj_amt is '计提日利息调整金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.acm_int_adj_amt is '累计利息调整金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.ld_acm_int_adj_amt is '上日累计利息调整金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_set_day_int_amt is '结息日利息金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_set_amt is '结息金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.ld_ovdue_int is '上日逾期利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_cap_amt is '利息资本化金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_int_provi_dt is '上一利息计提日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.unrliz_int is '未实现利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.discnt_int_flg is '折扣利息标志';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.discnt_pay_int is '折扣付出利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.discnt_pnlt_amt is '折扣罚息金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.discnt_int is '折扣利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.ld_bf_pay_int_amt is '上日前付息金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_accr_surp_days is '计息剩余天数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_day_int_tax is '计提日利息税';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.currt_int_tax_acm_amt is '当期利息税累计金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_set_day_int_tax is '结息日利息税';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_tax_acm_amt is '利息税累计金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.day_cut_bf_last_int_set_dt is '日切前上一结息日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.next_provi_dt is '下一计提日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_accum is '计提积数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.agt_accum is '协议积数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_actl_amt is '计提实际金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_tax_lmt is '利息税金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.int_tax_bal is '利息税差额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.currt_acm_int_accr_days is '当期累计计息天数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.currt_acm_amorted_provi_amt is '当期累计已摊销计提金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_provi_dt is '上一计提日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.back_nature_day_days is '回溯自然日天数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.back_wd_days is '回溯工作日天数';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.acct_stl_dt is '账户结算日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.stock_int_tax is '存量利息税';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.provi_begin_day is '计提起始日';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.agt_prefr_amt is '协议优惠金额';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.agt_int is '协议利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_int_calc_dt is '上一利息计算日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.last_activ_acct_dt is '上次动户日期';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.up_ld_acm_provi_int is '上上日累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.up_ld_int_acm_provi_adj is '上上日利息累计计提调整';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_int_dtl_h.etl_timestamp is 'ETL处理时间戳';
