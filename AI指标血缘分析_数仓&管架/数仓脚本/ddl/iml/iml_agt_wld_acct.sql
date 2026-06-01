/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_acct(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,name varchar2(150) -- 姓名
    ,gender_cd varchar2(10) -- 性别代码
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,syn_id varchar2(60) -- 银团编号
    ,card_no varchar2(60) -- 卡号
    ,curr_cd varchar2(10) -- 币种代码
    ,lmt number(30,2) -- 额度
    ,curr_bal number(30,2) -- 当前余额
    ,pric_bal number(30,2) -- 本金余额
    ,last_exp_day_bal number(30,2) -- 上一到期日余额
    ,duf_mons number(10) -- 拖欠月数
    ,unbd_debit_amt number(30,2) -- 未入账借记金额
    ,unbd_crdt_amt number(30,2) -- 未入账贷记金额
    ,apot_repay_type_cd varchar2(10) -- 约定还款类型代码
    ,apot_repay_bank_name varchar2(150) -- 约定还款银行名称
    ,apot_repay_open_bank_num varchar2(60) -- 约定还款开户行号
    ,apot_repay_deduct_acct_num varchar2(60) -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name varchar2(150) -- 约定还款扣款账户名称
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
    ,fir_consm_dt date -- 首次消费日期
    ,last_repay_amt number(30,2) -- 上笔还款金额
    ,fir_consm_amt number(38,8) -- 首次消费金额
    ,min_second_marke number(38,8) -- 最小还款额
    ,currt_min_second_marke number(38,8) -- 当期最小还款额
    ,currt_cash_amt number(38,8) -- 当期取现金额
    ,currt_cash_cnt number(10) -- 当期取现笔数
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
    ,currt_int_amt number(30,8) -- 当期利息金额
    ,currt_int_cnt number(10) -- 当期利息笔数
    ,currt_rtn_goods_amt number(38,8) -- 当期退货金额
    ,currt_rtn_goods_cnt number(10) -- 当期退货笔数
    ,currt_higt_over_lmt_amt_lmt number(38,8) -- 当期最高超限金额
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
    ,acct_ovdue_amt number(30,2) -- 账户逾期金额
    ,bank_contri_ratio number(18,6) -- 银行出资比例
    ,batch_doc_name varchar2(150) -- 批量文件名称
    ,ser_num varchar2(60) -- 序列号
    ,ext_cust_id varchar2(60) -- 外部客户编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_wld_acct to ${icl_schema};
grant select on ${iml_schema}.agt_wld_acct to ${idl_schema};
grant select on ${iml_schema}.agt_wld_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_acct is '微粒贷账户';
comment on column ${iml_schema}.agt_wld_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_acct.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_acct.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wld_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wld_acct.name is '姓名';
comment on column ${iml_schema}.agt_wld_acct.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_wld_acct.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.agt_wld_acct.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.agt_wld_acct.syn_id is '银团编号';
comment on column ${iml_schema}.agt_wld_acct.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_acct.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wld_acct.lmt is '额度';
comment on column ${iml_schema}.agt_wld_acct.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_wld_acct.pric_bal is '本金余额';
comment on column ${iml_schema}.agt_wld_acct.last_exp_day_bal is '上一到期日余额';
comment on column ${iml_schema}.agt_wld_acct.duf_mons is '拖欠月数';
comment on column ${iml_schema}.agt_wld_acct.unbd_debit_amt is '未入账借记金额';
comment on column ${iml_schema}.agt_wld_acct.unbd_crdt_amt is '未入账贷记金额';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_type_cd is '约定还款类型代码';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_bank_name is '约定还款银行名称';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_open_bank_num is '约定还款开户行号';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_deduct_acct_num is '约定还款扣款账号';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_deduct_acct_name is '约定还款扣款账户名称';
comment on column ${iml_schema}.agt_wld_acct.repay_day is '还款日';
comment on column ${iml_schema}.agt_wld_acct.last_enter_acct_batch_dt is '上一次入账的批量日期';
comment on column ${iml_schema}.agt_wld_acct.prev_repay_dt is '上个还款日期';
comment on column ${iml_schema}.agt_wld_acct.prev_exp_repay_dt is '上个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct.prev_ovdue_repay_dt is '上个逾期还款日期';
comment on column ${iml_schema}.agt_wld_acct.prev_ovdue_mons_promt_dt is '上个逾期月数提升日期';
comment on column ${iml_schema}.agt_wld_acct.in_coll_dt is '入催日期';
comment on column ${iml_schema}.agt_wld_acct.out_coll_que_dt is '出催收队列日期';
comment on column ${iml_schema}.agt_wld_acct.next_exp_repay_dt is '下个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct.exp_repay_dt is '到期还款日期';
comment on column ${iml_schema}.agt_wld_acct.apot_repay_dt is '约定还款日期';
comment on column ${iml_schema}.agt_wld_acct.grace_dt_term is '宽限日期';
comment on column ${iml_schema}.agt_wld_acct.fir_exp_repay_dt is '首个到期还款日期';
comment on column ${iml_schema}.agt_wld_acct.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.agt_wld_acct.tran_bad_debt_acct_dt is '转呆账日期';
comment on column ${iml_schema}.agt_wld_acct.fir_consm_dt is '首次消费日期';
comment on column ${iml_schema}.agt_wld_acct.last_repay_amt is '上笔还款金额';
comment on column ${iml_schema}.agt_wld_acct.fir_consm_amt is '首次消费金额';
comment on column ${iml_schema}.agt_wld_acct.min_second_marke is '最小还款额';
comment on column ${iml_schema}.agt_wld_acct.currt_min_second_marke is '当期最小还款额';
comment on column ${iml_schema}.agt_wld_acct.currt_cash_amt is '当期取现金额';
comment on column ${iml_schema}.agt_wld_acct.currt_cash_cnt is '当期取现笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_consm_amt is '当期消费金额';
comment on column ${iml_schema}.agt_wld_acct.currt_consm_cnt is '当期消费笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_repay_amt is '当期还款金额';
comment on column ${iml_schema}.agt_wld_acct.currt_repay_cnt is '当期还款笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_debit_adj_amt is '当期借记调整金额';
comment on column ${iml_schema}.agt_wld_acct.currt_debit_adj_cnt is '当期借记调整笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_crdt_adj_amt is '当期贷记调整金额';
comment on column ${iml_schema}.agt_wld_acct.currt_crdt_adj_cnt is '当期贷记调整笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_fee_amt is '当期费用金额';
comment on column ${iml_schema}.agt_wld_acct.currt_fee_cnt is '当期费用笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_int_amt is '当期利息金额';
comment on column ${iml_schema}.agt_wld_acct.currt_int_cnt is '当期利息笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_rtn_goods_amt is '当期退货金额';
comment on column ${iml_schema}.agt_wld_acct.currt_rtn_goods_cnt is '当期退货笔数';
comment on column ${iml_schema}.agt_wld_acct.currt_higt_over_lmt_amt_lmt is '当期最高超限金额';
comment on column ${iml_schema}.agt_wld_acct.th_mon_consm_amt is '本月消费金额';
comment on column ${iml_schema}.agt_wld_acct.th_mon_consm_cnt is '本月消费笔数';
comment on column ${iml_schema}.agt_wld_acct.th_year_consm_amt is '本年消费金额';
comment on column ${iml_schema}.agt_wld_acct.th_year_consm_cnt is '本年消费笔数';
comment on column ${iml_schema}.agt_wld_acct.curr_mon_repay_amt is '当月还款金额';
comment on column ${iml_schema}.agt_wld_acct.curr_mon_repay_cnt is '当月还款笔数';
comment on column ${iml_schema}.agt_wld_acct.th_year_repay_amt is '当年还款金额';
comment on column ${iml_schema}.agt_wld_acct.th_year_repay_cnt is '当年还款笔数';
comment on column ${iml_schema}.agt_wld_acct.h_repay_amt is '历史还款金额';
comment on column ${iml_schema}.agt_wld_acct.h_repay_cnt is '历史还款笔数';
comment on column ${iml_schema}.agt_wld_acct.acct_ovdue_amt is '账户逾期金额';
comment on column ${iml_schema}.agt_wld_acct.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_wld_acct.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.agt_wld_acct.ser_num is '序列号';
comment on column ${iml_schema}.agt_wld_acct.ext_cust_id is '外部客户编号';
comment on column ${iml_schema}.agt_wld_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_wld_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_wld_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wld_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_acct.etl_timestamp is 'ETL处理时间戳';
