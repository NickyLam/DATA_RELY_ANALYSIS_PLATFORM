/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_wl_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_wl_repay_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,prod_id varchar2(60) -- 产品编号
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,repay_flow_id varchar2(250) -- 还款流水编号
    ,repay_dt date -- 还款日期
    ,intnal_carr_flg varchar2(10) -- 内部结转标志
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,adv_repay_flg varchar2(10) -- 提前还款标志
    ,ovdue_repay_flg varchar2(10) -- 逾期还款标志
    ,acru_non_acru_cd varchar2(10) -- 应计非应计代码
    ,repay_type_cd varchar2(10) -- 还款类型代码
    ,curr_cd varchar2(10) -- 币种代码
    ,curr_nomal_pric_bal number(38,8) -- 当前正常本金余额
    ,currt_repay_amt number(30,2) -- 当期还款金额
    ,currt_repay_pric number(30,2) -- 当期还款本金
    ,currt_repay_nomal_pric number(30,2) -- 当期还款正常本金
    ,currt_repay_ovdue_pric number(30,2) -- 当期还款逾期本金
    ,curr_repay_int number(30,2) -- 当前还款利息
    ,currt_repay_nomal_int number(30,2) -- 当期还款正常利息
    ,currt_repay_ovdue_int number(30,2) -- 当期还款逾期利息
    ,currt_repay_pnlt number(30,2) -- 当期还款罚息
    ,currt_repay_ovdue_pric_pnlt number(30,2) -- 当期还款逾期本金罚息
    ,currt_repay_ovdue_int_pnlt number(30,2) -- 当期还款逾期利息罚息
    ,currt_repay_fee number(30,2) -- 当期还款费用
    ,currt_repay_fee_rat number(18,8) -- 当期还款费率
    ,bf_repay_recvbl_uncol_nomal_pric number(30,6) -- 还款前的应收未收正常本金
    ,bf_repay_recvbl_uncol_ovdue_pric number(30,6) -- 还款前的应收未收逾期本金
    ,bf_repay_recvbl_uncol_nomal_int number(30,6) -- 还款前的应收未收正常利息
    ,bf_repay_recvbl_uncol_ovdue_int number(30,6) -- 还款前的应收未收逾期利息
    ,bf_repay_recvbl_uncol_ovdue_pric_pnlt number(30,6) -- 还款前的应收未收逾期本金罚息
    ,bf_repay_recvbl_uncol_ovdue_int_pnlt number(30,6) -- 还款前的应收未收逾期利息罚息
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
grant select on ${icl_schema}.cmm_unite_wl_repay_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_wl_repay_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_wl_repay_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_wl_repay_dtl is '联合网贷还款明细';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.repay_acct_id is '还款账户编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.repay_flow_id is '还款流水编号';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.repay_dt is '还款日期';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.intnal_carr_flg is '内部结转标志';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.wrt_off_flg is '核销标志';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.adv_repay_flg is '提前还款标志';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.ovdue_repay_flg is '逾期还款标志';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.acru_non_acru_cd is '应计非应计代码';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.repay_type_cd is '还款类型代码';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.curr_nomal_pric_bal is '当前正常本金余额';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_amt is '当期还款金额';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_pric is '当期还款本金';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_nomal_pric is '当期还款正常本金';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_ovdue_pric is '当期还款逾期本金';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.curr_repay_int is '当前还款利息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_nomal_int is '当期还款正常利息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_ovdue_int is '当期还款逾期利息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_pnlt is '当期还款罚息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_ovdue_pric_pnlt is '当期还款逾期本金罚息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_ovdue_int_pnlt is '当期还款逾期利息罚息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_fee is '当期还款费用';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.currt_repay_fee_rat is '当期还款费率';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_nomal_pric is '还款前的应收未收正常本金';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_ovdue_pric is '还款前的应收未收逾期本金';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_nomal_int is '还款前的应收未收正常利息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_ovdue_int is '还款前的应收未收逾期利息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_ovdue_pric_pnlt is '还款前的应收未收逾期本金罚息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.bf_repay_recvbl_uncol_ovdue_int_pnlt is '还款前的应收未收逾期利息罚息';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_wl_repay_dtl.etl_timestamp is 'ETL处理时间戳';
