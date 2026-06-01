/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,name varchar2(500) -- 姓名
    ,gender_cd varchar2(30) -- 性别代码
    ,cust_lmt_id varchar2(100) -- 额度编号
    ,loan_prod_id varchar2(100) -- 贷款产品编号
    ,syn_id varchar2(100) -- 银团编号
    ,card_no varchar2(60) -- 卡号
    ,curr_cd varchar2(30) -- 币种代码
    ,lmt number(30) -- 授信额度
    ,curr_bal number(38,8) -- 当前余额
    ,pric_bal number(30,2) -- 本金余额
    ,last_exp_day_bal number(30,2) -- 上一到期日余额
    ,duf_mons number(10) -- 拖欠月数
    ,unbd_debit_amt number(30,2) -- 未入账借记金额
    ,unbd_crdt_amt number(30,2) -- 未入账贷记金额
    ,apot_repay_type_cd varchar2(30) -- 约定还款类型代码
    ,apot_repay_bank_name varchar2(500) -- 约定还款银行名称
    ,apot_repay_open_bank_num varchar2(60) -- 约定还款开户行号
    ,apot_repay_deduct_acct_num varchar2(60) -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name varchar2(500) -- 约定还款扣款账户名称
    ,repay_day varchar2(10) -- 还款日
    ,last_enter_acct_batch_dt date -- 上一次入账的批量日期
    ,prev_repay_dt date -- 上个还款日期
    ,prev_exp_repay_dt date -- 上个到期还款日期
    ,prev_ovdue_repay_dt date -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt date -- 上个逾期月数提升日期
    ,in_coll_dt date -- 入催日期
    ,out_coll_que_dt date -- 出催收队列日期
    ,next_exp_repay_dt date -- 下个到期还款日期
    ,exp_repay_dt date -- 到期还款日期
    ,apot_repay_dt date -- 约定还款日期
    ,grace_dt_term date -- 宽限日期
    ,fir_exp_repay_dt date -- 首个到期还款日期
    ,clos_acct_dt date -- 销户日期
    ,tran_bad_debt_acct_dt date -- 转呆账日期
    ,last_repay_amt number(30,2) -- 上笔还款金额
    ,currt_consm_amt number(30,2) -- 当期消费金额
    ,currt_consm_cnt number(10) -- 当期消费笔数
    ,currt_repay_amt number(30,2) -- 当期还款金额
    ,currt_repay_cnt number(10) -- 当期还款笔数
    ,currt_debit_adj_amt number(30,2) -- 当期借记调整金额
    ,currt_debit_adj_cnt number(10) -- 当期借记调整笔数
    ,currt_crdt_adj_amt number(30,2) -- 当期贷记调整金额
    ,currt_crdt_adj_cnt number(10) -- 当期贷记调整笔数
    ,currt_fee_amt number(30,2) -- 当期费用金额
    ,currt_fee_cnt number(10) -- 当期费用笔数
    ,currt_int_amt number(30,2) -- 当期利息金额
    ,currt_int_cnt number(10) -- 当期利息笔数
    ,th_mon_consm_amt number(30,2) -- 本月消费金额
    ,th_mon_consm_cnt number(10) -- 本月消费笔数
    ,th_year_consm_amt number(30,2) -- 本年消费金额
    ,th_year_consm_cnt number(10) -- 本年消费笔数
    ,curr_mon_repay_amt number(30,2) -- 当月还款金额
    ,curr_mon_repay_cnt number(10) -- 当月还款笔数
    ,th_year_repay_amt number(30,2) -- 当年还款金额
    ,th_year_repay_cnt number(10) -- 当年还款笔数
    ,h_repay_amt number(30,2) -- 历史还款金额
    ,h_repay_cnt number(10) -- 历史还款笔数
    ,bank_contri_ratio number(18,6) -- 银行出资比例
    ,out_line_cust_id varchar2(100) -- 行外客户编号
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
grant select on ${iml_schema}.agt_wld_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_wld_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_wld_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_acct_h is '微粒贷账户信息历史';
comment on column ${iml_schema}.agt_wld_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_acct_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_acct_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wld_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wld_acct_h.name is '姓名';
comment on column ${iml_schema}.agt_wld_acct_h.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_wld_acct_h.cust_lmt_id is '额度编号';
comment on column ${iml_schema}.agt_wld_acct_h.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.agt_wld_acct_h.syn_id is '银团编号';
comment on column ${iml_schema}.agt_wld_acct_h.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_acct_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wld_acct_h.lmt is '授信额度';
comment on column ${iml_schema}.agt_wld_acct_h.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_wld_acct_h.pric_bal is '本金余额';
comment on column ${iml_schema}.agt_wld_acct_h.last_exp_day_bal is '上一到期日余额';
comment on column ${iml_schema}.agt_wld_acct_h.duf_mons is '拖欠月数';
comment on column ${iml_schema}.agt_wld_acct_h.unbd_debit_amt is '未入账借记金额';
comment on column ${iml_schema}.agt_wld_acct_h.unbd_crdt_amt is '未入账贷记金额';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_type_cd is '约定还款类型代码';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_bank_name is '约定还款银行名称';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_open_bank_num is '约定还款开户行号';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_deduct_acct_num is '约定还款扣款账号';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_deduct_acct_name is '约定还款扣款账户名称';
comment on column ${iml_schema}.agt_wld_acct_h.repay_day is '还款日';
comment on column ${iml_schema}.agt_wld_acct_h.last_enter_acct_batch_dt is '上一次入账的批量日期';
comment on column ${iml_schema}.agt_wld_acct_h.prev_repay_dt is '上个还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.prev_exp_repay_dt is '上个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.prev_ovdue_repay_dt is '上个逾期还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.prev_ovdue_mons_promt_dt is '上个逾期月数提升日期';
comment on column ${iml_schema}.agt_wld_acct_h.in_coll_dt is '入催日期';
comment on column ${iml_schema}.agt_wld_acct_h.out_coll_que_dt is '出催收队列日期';
comment on column ${iml_schema}.agt_wld_acct_h.next_exp_repay_dt is '下个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.exp_repay_dt is '到期还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.apot_repay_dt is '约定还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.grace_dt_term is '宽限日期';
comment on column ${iml_schema}.agt_wld_acct_h.fir_exp_repay_dt is '首个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct_h.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.agt_wld_acct_h.tran_bad_debt_acct_dt is '转呆账日期';
comment on column ${iml_schema}.agt_wld_acct_h.last_repay_amt is '上笔还款金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_consm_amt is '当期消费金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_consm_cnt is '当期消费笔数';
comment on column ${iml_schema}.agt_wld_acct_h.currt_repay_amt is '当期还款金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_repay_cnt is '当期还款笔数';
comment on column ${iml_schema}.agt_wld_acct_h.currt_debit_adj_amt is '当期借记调整金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_debit_adj_cnt is '当期借记调整笔数';
comment on column ${iml_schema}.agt_wld_acct_h.currt_crdt_adj_amt is '当期贷记调整金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_crdt_adj_cnt is '当期贷记调整笔数';
comment on column ${iml_schema}.agt_wld_acct_h.currt_fee_amt is '当期费用金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_fee_cnt is '当期费用笔数';
comment on column ${iml_schema}.agt_wld_acct_h.currt_int_amt is '当期利息金额';
comment on column ${iml_schema}.agt_wld_acct_h.currt_int_cnt is '当期利息笔数';
comment on column ${iml_schema}.agt_wld_acct_h.th_mon_consm_amt is '本月消费金额';
comment on column ${iml_schema}.agt_wld_acct_h.th_mon_consm_cnt is '本月消费笔数';
comment on column ${iml_schema}.agt_wld_acct_h.th_year_consm_amt is '本年消费金额';
comment on column ${iml_schema}.agt_wld_acct_h.th_year_consm_cnt is '本年消费笔数';
comment on column ${iml_schema}.agt_wld_acct_h.curr_mon_repay_amt is '当月还款金额';
comment on column ${iml_schema}.agt_wld_acct_h.curr_mon_repay_cnt is '当月还款笔数';
comment on column ${iml_schema}.agt_wld_acct_h.th_year_repay_amt is '当年还款金额';
comment on column ${iml_schema}.agt_wld_acct_h.th_year_repay_cnt is '当年还款笔数';
comment on column ${iml_schema}.agt_wld_acct_h.h_repay_amt is '历史还款金额';
comment on column ${iml_schema}.agt_wld_acct_h.h_repay_cnt is '历史还款笔数';
comment on column ${iml_schema}.agt_wld_acct_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_wld_acct_h.out_line_cust_id is '行外客户编号';
comment on column ${iml_schema}.agt_wld_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wld_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wld_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_acct_h.etl_timestamp is 'ETL处理时间戳';
