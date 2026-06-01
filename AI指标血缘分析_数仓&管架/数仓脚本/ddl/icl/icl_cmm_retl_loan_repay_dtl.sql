/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_repay_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_repay_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,loan_num varchar2(60) -- 贷款号
    ,cust_id varchar2(60) -- 客户编号
    ,repay_acct_id varchar2(60) -- 还款账户编号
    ,repay_flow_id varchar2(60) -- 还款流水编号
    ,repay_dt date -- 还款日期
    ,repaybl_dt date -- 应还款日期
    ,repay_perds number(10,0) -- 还款期数
    ,repay_sub_perds number(10,0) -- 还款子期数
    ,adv_repay_flg varchar2(10) -- 提前还款标志
    ,ovdue_repay_flg varchar2(10) -- 逾期还款标志
    ,comp_repay_flg varchar2(10) -- 代偿还款标志
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,bf_repay_status_cd varchar2(10) -- 还款前还款状态代码
    ,repay_post_repay_status_cd varchar2(10) -- 还款后还款状态代码
    ,acru_non_acru_cd varchar2(10) -- 应计非应计代码
    ,tran_cd varchar2(10) -- 交易代码
    ,curr_cd varchar2(10) -- 币种代码
    ,dtl_seq_num varchar2(60) -- 明细序号
    ,callbk_mode_cd varchar2(30) -- 回收模式代码
    ,repay_evt_cd varchar2(10) -- 还款事件代码
    ,repay_evt_descb varchar2(60) -- 还款事件描述
    ,currt_repay_recvbl_acru_int number(30,2) -- 当期还款应收应计利息
    ,currt_repay_coll_acru_int number(30,2) -- 当期还款催收应计利息
    ,currt_repay_recvbl_over_int number(30,2) -- 当期还款应收欠息
    ,currt_repay_coll_over_int number(30,2) -- 当期还款催收欠息
    ,currt_repay_recvbl_acru_pnlt number(30,2) -- 当期还款应收应计罚息
    ,currt_repay_coll_acru_pnlt number(30,2) -- 当期还款催收应计罚息
    ,currt_repay_recvbl_pnlt number(30,2) -- 当期还款应收罚息
    ,currt_repay_coll_pnlt number(30,2) -- 当期还款催收罚息
    ,currt_repay_acru_comp_int number(30,2) -- 当期还款应计复息
    ,currt_repay_recvbl_comp_int number(30,2) -- 当期还款应收复息
    ,currt_fine number(30,2) -- 当期罚金
    ,currt_wrt_off_int number(30,2) -- 当期核销利息
    ,curr_nomal_pric_bal number(30,2) -- 当前正常本金余额
    ,currt_repay_pric number(30,2) -- 当期还款本金
    ,currt_repay_int number(30,2) -- 当期还款利息
    ,currt_repay_pnlt number(30,2) -- 当期还款罚息
    ,currt_repay_comp_int number(30,2) -- 当期还款复利
    ,currt_repay_fee number(30,2) -- 当期还款费用
    ,unbd_int number(30,2) -- 未入账利息
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_retl_loan_repay_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_repay_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_repay_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_repay_dtl is '零售贷款还款明细';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.loan_num is '贷款号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_acct_id is '还款账户编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_flow_id is '还款流水编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_dt is '还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repaybl_dt is '应还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_perds is '还款期数';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_sub_perds is '还款子期数';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.adv_repay_flg is '提前还款标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.ovdue_repay_flg is '逾期还款标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.comp_repay_flg is '代偿还款标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.strk_bal_flg is '冲账标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.bf_repay_status_cd is '还款前还款状态代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_post_repay_status_cd is '还款后还款状态代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.acru_non_acru_cd is '应计非应计代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.tran_cd is '交易代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.dtl_seq_num is '明细序号';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.callbk_mode_cd is '回收模式代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_evt_cd is '还款事件代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.repay_evt_descb is '还款事件描述';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_recvbl_acru_int is '当期还款应收应计利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_coll_acru_int is '当期还款催收应计利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_recvbl_over_int is '当期还款应收欠息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_coll_over_int is '当期还款催收欠息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_recvbl_acru_pnlt is '当期还款应收应计罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_coll_acru_pnlt is '当期还款催收应计罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_recvbl_pnlt is '当期还款应收罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_coll_pnlt is '当期还款催收罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_acru_comp_int is '当期还款应计复息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_recvbl_comp_int is '当期还款应收复息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_fine is '当期罚金';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_wrt_off_int is '当期核销利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.curr_nomal_pric_bal is '当前正常本金余额';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_pric is '当期还款本金';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_int is '当期还款利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_pnlt is '当期还款罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_comp_int is '当期还款复利';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.currt_repay_fee is '当期还款费用';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.unbd_int is '未入账利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_retl_loan_repay_dtl.etl_timestamp is 'ETL处理时间戳';
