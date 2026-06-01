/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ba_exp_cash_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ba_exp_cash_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ba_exp_cash_appl_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,org_id varchar2(100) -- 机构编号
    ,bill_id varchar2(100) -- 票据编号
    ,vouch_id varchar2(60) -- 凭证编号
    ,bill_curr_cd varchar2(30) -- 票据币种代码
    ,bill_amt number(30,2) -- 贴现票据金额
    ,msg_appl_type_cd varchar2(30) -- 报文申请类型代码
    ,appl_dt date -- 申请日期
    ,sugst_pay_curr_cd varchar2(30) -- 提示付款币种代码
    ,cash_amt number(30,2) -- 兑付金额
    ,onl_clear_cd varchar2(30) -- 线上清算代码
    ,vouch_qtty number(10) -- 所附凭证数量
    ,sugst_payer_cate_cd varchar2(30) -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd varchar2(100) -- 提示付款人组织机构代码
    ,sugst_payer_name varchar2(750) -- 提示付款人名称
    ,sugst_payer_acct_id varchar2(100) -- 提示付款人账户编号
    ,sugst_payer_open_bank_no varchar2(60) -- 提示付款人开户行行号
    ,cash_curr_cd varchar2(30) -- 兑付币种代码
    ,sugst_pay_appl_dt date -- 提示付款申请日期
    ,refuse_pay_cd varchar2(30) -- 拒付代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,recv_opinion_cd varchar2(30) -- 签收意见代码
    ,send_out_recv_status_cd varchar2(30) -- 发出签收明细状态代码
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,entry_dt date -- 记账日期
    ,revo_dt date -- 撤销日期
    ,pay_tran_num varchar2(60) -- 支付交易号
    ,spec_prmssn_prtcptr_id varchar2(100) -- 特许参与者编号
    ,pos_apv_status_cd varchar2(30) -- 头寸审批状态代码
    ,send_pos_flow_num varchar2(60) -- 发送头寸流水号
    ,adv_solu_pay_flg varchar2(30) -- 提前解付标志
    ,tran_tm varchar2(20) -- 交易时间
    ,tran_dt date -- 交易日期
    ,reply_teller_id varchar2(100) -- 回复柜员编号
    ,lt_id varchar2(60) -- 清单编号
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
grant select on ${iml_schema}.agt_ba_exp_cash_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_ba_exp_cash_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_ba_exp_cash_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ba_exp_cash_appl_h is '银承到期兑付申请历史';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.bill_curr_cd is '票据币种代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.bill_amt is '贴现票据金额';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.msg_appl_type_cd is '报文申请类型代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_pay_curr_cd is '提示付款币种代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.cash_amt is '兑付金额';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.onl_clear_cd is '线上清算代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.vouch_qtty is '所附凭证数量';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_payer_cate_cd is '提示付款人类别代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_payer_orgnz_cd is '提示付款人组织机构代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_payer_name is '提示付款人名称';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_payer_acct_id is '提示付款人账户编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_payer_open_bank_no is '提示付款人开户行行号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.cash_curr_cd is '兑付币种代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.sugst_pay_appl_dt is '提示付款申请日期';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.refuse_pay_cd is '拒付代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.recv_opinion_cd is '签收意见代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.send_out_recv_status_cd is '发出签收明细状态代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.entry_dt is '记账日期';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.revo_dt is '撤销日期';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.pay_tran_num is '支付交易号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.spec_prmssn_prtcptr_id is '特许参与者编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.pos_apv_status_cd is '头寸审批状态代码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.send_pos_flow_num is '发送头寸流水号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.adv_solu_pay_flg is '提前解付标志';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.reply_teller_id is '回复柜员编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.lt_id is '清单编号';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ba_exp_cash_appl_h.etl_timestamp is 'ETL处理时间戳';
