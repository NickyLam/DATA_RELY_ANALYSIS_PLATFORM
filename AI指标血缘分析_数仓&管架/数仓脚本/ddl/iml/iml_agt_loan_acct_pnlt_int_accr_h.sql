/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_pnlt_int_accr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_pnlt_int_accr_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_pnlt_int_accr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_pnlt_int_accr_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,curr_pd number(10) -- 当前期次
    ,cust_id varchar2(100) -- 客户编号
    ,last_int_set_dt date -- 上一结息日期
    ,next_int_set_dt date -- 下一结息日期
    ,value_dt date -- 起息日期
    ,last_provi_dt date -- 上一计提日期
    ,exp_dt date -- 到期日期
    ,int_amt number(30,2) -- 利息金额
    ,provi_day_provi_actl_amt number(30,2) -- 计提日计提实际金额
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,acm_int_adj_amt number(30,2) -- 累计利息调整金额
    ,provi_day_provi_int number(30,2) -- 计提日计提利息
    ,ld_acm_provi_int number(30,2) -- 上日累计计提利息
    ,int_set_day_int_amt number(30,2) -- 结息日利息金额
    ,provi_day_int_adj number(30,2) -- 计提日利息调整
    ,ld_acm_int_adj number(30,2) -- 上日累计利息调整
    ,int_set_amt number(30,2) -- 结息金额
    ,acm_provi_int number(30,2) -- 累计计提利息
    ,int_set_day_int_tax number(30,2) -- 结息日利息税
    ,tax_rat number(18,6) -- 税率
    ,tax_category_cd varchar2(30) -- 税种代码
    ,int_tax_acm_amt number(30,2) -- 利息税累计金额
    ,wrt_off_pric number(30,2) -- 核销本金
    ,tran_teller_id varchar2(60) -- 交易柜员编号
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
grant select on ${iml_schema}.agt_loan_acct_pnlt_int_accr_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_pnlt_int_accr_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_pnlt_int_accr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_pnlt_int_accr_h is '贷款账户罚息计息历史';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.curr_pd is '当前期次';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.last_int_set_dt is '上一结息日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.last_provi_dt is '上一计提日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.provi_day_provi_actl_amt is '计提日计提实际金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.acm_int_adj_amt is '累计利息调整金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.provi_day_provi_int is '计提日计提利息';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.ld_acm_provi_int is '上日累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_set_day_int_amt is '结息日利息金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.provi_day_int_adj is '计提日利息调整';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.ld_acm_int_adj is '上日累计利息调整';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_set_amt is '结息金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.acm_provi_int is '累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_set_day_int_tax is '结息日利息税';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.tax_rat is '税率';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.tax_category_cd is '税种代码';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.int_tax_acm_amt is '利息税累计金额';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.last_activ_acct_dt is '上次动户日期';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.up_ld_acm_provi_int is '上上日累计计提利息';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.up_ld_int_acm_provi_adj is '上上日利息累计计提调整';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_pnlt_int_accr_h.etl_timestamp is 'ETL处理时间戳';
