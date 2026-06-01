/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_acpt_dtl
CreateDate: 20221108
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_bill_acpt_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_acpt_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_acpt_dtl (
etl_dt  --ETL处理日期
,agt_id  --协议编号
,lp_id  --法人编号
,acpt_dtl_id  --承兑明细编号
,batch_id  --批次编号
,bill_id  --票据编号
,comm_fee  --手续费
,todos  --工本费
,exp_uncond_pay_entr_cd  --到期无条件支付委托代码
,pay_bank_ibank_no  --付款行联行号
,lmt_deduct_amt  --额度扣减金额
,bill_acpt_proc_status_cd  --票据承兑处理状态代码
,recv_dt  --签收日期
,entry_status_cd  --记账状态代码
,recv_opinion_cd  --签收意见代码
,final_modif_tm  --最后修改时间
,accptor_agent_reply_cd  --承兑人代理回复代码
,entry_dt  --记账日期
,revo_dt  --撤销日期
,draw_status_cd  --出票状态代码
,payoff_flg  --结清标志
,bill_pkg_intrv_id  --票据包区间编号
,bill_amt  --票据金额
,bill_intrv_corp_amt  --票据区间标准金额
,bill_intrv_qtty  --票据区间数量
,crdt_out_acct_flow_num  --信贷出账流水号
,h_data_flg  --历史数据标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.acpt_dtl_id,chr(13),''),chr(10),'') as acpt_dtl_id --承兑明细编号
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id --票据编号
,t1.comm_fee as comm_fee --手续费
,t1.todos as todos --工本费
,replace(replace(t1.exp_uncond_pay_entr_cd,chr(13),''),chr(10),'') as exp_uncond_pay_entr_cd --到期无条件支付委托代码
,replace(replace(t1.pay_bank_ibank_no,chr(13),''),chr(10),'') as pay_bank_ibank_no --付款行联行号
,t1.lmt_deduct_amt as lmt_deduct_amt --额度扣减金额
,replace(replace(t1.bill_acpt_proc_status_cd,chr(13),''),chr(10),'') as bill_acpt_proc_status_cd --票据承兑处理状态代码
,t1.recv_dt as recv_dt --签收日期
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd --记账状态代码
,replace(replace(t1.recv_opinion_cd,chr(13),''),chr(10),'') as recv_opinion_cd --签收意见代码
,t1.final_modif_tm as final_modif_tm --最后修改时间
,replace(replace(t1.accptor_agent_reply_cd,chr(13),''),chr(10),'') as accptor_agent_reply_cd --承兑人代理回复代码
,t1.entry_dt as entry_dt --记账日期
,t1.revo_dt as revo_dt --撤销日期
,replace(replace(t1.draw_status_cd,chr(13),''),chr(10),'') as draw_status_cd --出票状态代码
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg --结清标志
,replace(replace(t1.bill_pkg_intrv_id,chr(13),''),chr(10),'') as bill_pkg_intrv_id --票据包区间编号
,t1.bill_amt as bill_amt --票据金额
,t1.bill_intrv_corp_amt as bill_intrv_corp_amt --票据区间标准金额
,t1.bill_intrv_qtty as bill_intrv_qtty --票据区间数量
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num --信贷出账流水号
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg --历史数据标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
from ${iml_schema}.agt_bill_acpt_dtl t1    --票据承兑明细
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_acpt_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
