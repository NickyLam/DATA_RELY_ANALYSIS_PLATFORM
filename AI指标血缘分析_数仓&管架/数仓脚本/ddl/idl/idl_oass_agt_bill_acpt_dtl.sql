/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_acpt_dtl
CreateDate: 20221108
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_acpt_dtl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_acpt_dtl(
etl_dt date --ETL处理日期
,agt_id varchar2(60) --协议编号
,lp_id varchar2(60) --法人编号
,acpt_dtl_id varchar2(60) --承兑明细编号
,batch_id varchar2(60) --批次编号
,bill_id varchar2(60) --票据编号
,comm_fee number(30,2) --手续费
,todos number(30,2) --工本费
,exp_uncond_pay_entr_cd varchar2(10) --到期无条件支付委托代码
,pay_bank_ibank_no varchar2(60) --付款行联行号
,lmt_deduct_amt number(30,2) --额度扣减金额
,bill_acpt_proc_status_cd varchar2(10) --票据承兑处理状态代码
,recv_dt date --签收日期
,entry_status_cd varchar2(10) --记账状态代码
,recv_opinion_cd varchar2(10) --签收意见代码
,final_modif_tm timestamp(6) --最后修改时间
,accptor_agent_reply_cd varchar2(10) --承兑人代理回复代码
,entry_dt date --记账日期
,revo_dt date --撤销日期
,draw_status_cd varchar2(10) --出票状态代码
,payoff_flg varchar2(10) --结清标志
,bill_pkg_intrv_id varchar2(60) --票据包区间编号
,bill_amt number(30,2) --票据金额
,bill_intrv_corp_amt number(30,2) --票据区间标准金额
,bill_intrv_qtty number(10) --票据区间数量
,crdt_out_acct_flow_num varchar2(60) --信贷出账流水号
,h_data_flg varchar2(100) --历史数据标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bill_acpt_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_acpt_dtl is '票据承兑明细';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.acpt_dtl_id is '承兑明细编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.batch_id is '批次编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_id is '票据编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.comm_fee is '手续费';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.todos is '工本费';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.exp_uncond_pay_entr_cd is '到期无条件支付委托代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.pay_bank_ibank_no is '付款行联行号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.lmt_deduct_amt is '额度扣减金额';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_acpt_proc_status_cd is '票据承兑处理状态代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.recv_dt is '签收日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.recv_opinion_cd is '签收意见代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.accptor_agent_reply_cd is '承兑人代理回复代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.entry_dt is '记账日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.revo_dt is '撤销日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.draw_status_cd is '出票状态代码';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.payoff_flg is '结清标志';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_pkg_intrv_id is '票据包区间编号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_amt is '票据金额';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_intrv_corp_amt is '票据区间标准金额';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.bill_intrv_qtty is '票据区间数量';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.h_data_flg is '历史数据标志';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_acpt_dtl.id_mark is '增删标志';

