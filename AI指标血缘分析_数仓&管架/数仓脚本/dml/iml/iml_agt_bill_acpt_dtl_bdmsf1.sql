/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_acpt_dtl_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_acpt_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_acpt_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_acpt_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acpt_dtl_id -- 承兑明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,pay_bank_ibank_no -- 付款行联行号
    ,lmt_deduct_amt -- 额度扣减金额
    ,bill_acpt_proc_status_cd -- 票据承兑处理状态代码
    ,recv_dt -- 签收日期
    ,entry_status_cd -- 记账状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,final_modif_tm -- 最后修改时间
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,draw_status_cd -- 出票状态代码
    ,payoff_flg -- 结清标志
    ,bill_pkg_intrv_id -- 票据包区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_corp_amt -- 票据区间标准金额
    ,bill_intrv_qtty -- 票据区间数量
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,bill_num -- 票据号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_acpt_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_acpt_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_accept_details-
insert into ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acpt_dtl_id -- 承兑明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,pay_bank_ibank_no -- 付款行联行号
    ,lmt_deduct_amt -- 额度扣减金额
    ,bill_acpt_proc_status_cd -- 票据承兑处理状态代码
    ,recv_dt -- 签收日期
    ,entry_status_cd -- 记账状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,final_modif_tm -- 最后修改时间
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,draw_status_cd -- 出票状态代码
    ,payoff_flg -- 结清标志
    ,bill_pkg_intrv_id -- 票据包区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_corp_amt -- 票据区间标准金额
    ,bill_intrv_qtty -- 票据区间数量
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,bill_num -- 票据号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223101'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 承兑明细编号
    ,P1.CONTRACT_ID -- 批次编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.CHARGE -- 手续费
    ,P1.EXPENSES -- 工本费
    ,NVL(TRIM(P1.UCONDL_CONSGNTMRK),'-') -- 到期无条件支付委托代码
    ,P1.DRAWEE_BANK_NO -- 付款行联行号
    ,P1.CREDIT_LINE -- 额度扣减金额
    ,NVL(TRIM(P1.ACCEPT_STATUS),'-') -- 票据承兑处理状态代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ENDST_DATE) -- 签收日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_FLAG END -- 记账状态代码
    ,NVL(TRIM(P1.SIG_MK),'-') -- 签收意见代码
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,NVL(TRIM(P1.RCV_PRXY_SGNTR),'PS00') -- 承兑人代理回复代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ACCOUNT_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CANCEL_DATE) -- 撤销日期
    ,NVL(TRIM(P1.PRINT_STATUS),'-') -- 出票状态代码
    ,NVL(TRIM(P1.SETTLE_FLAG),'-') -- 结清标志
    ,'-' -- 票据包区间编号
    ,0.0 -- 票据金额
    ,0.0 -- 票据区间标准金额
    ,0.0 -- 票据区间数量
    ,P1.RUN_CODE -- 信贷出账流水号
    ,p1.RESERVE1 -- 历史数据标志
    ,p1.DRAFT_NUMBER -- 票据号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_details p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_FLAG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_FLAG'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- bdms_cpes_accept_details-
insert into ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acpt_dtl_id -- 承兑明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,pay_bank_ibank_no -- 付款行联行号
    ,lmt_deduct_amt -- 额度扣减金额
    ,bill_acpt_proc_status_cd -- 票据承兑处理状态代码
    ,recv_dt -- 签收日期
    ,entry_status_cd -- 记账状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,final_modif_tm -- 最后修改时间
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,draw_status_cd -- 出票状态代码
    ,payoff_flg -- 结清标志
    ,bill_pkg_intrv_id -- 票据包区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_corp_amt -- 票据区间标准金额
    ,bill_intrv_qtty -- 票据区间数量
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,bill_num -- 票据号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223108'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 承兑明细编号
    ,P1.CONTRACT_ID -- 批次编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.CHARGE -- 手续费
    ,0.0 -- 工本费
    ,'-' -- 到期无条件支付委托代码
    ,P1.ACCEPTOR_BANK_NO -- 付款行联行号
    ,0.0 -- 额度扣减金额
    ,nvl(trim(P1.ACCEPT_STATUS),'-') -- 票据承兑处理状态代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ACCEPTOR_DATE） -- 签收日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,'-' -- 签收意见代码
    ,${iml_schema}.TIMEFORMAT_MAX2(P1.LAST_UPDATE_TIME) -- 最后修改时间
    ,'PS00' -- 承兑人代理回复代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ACCOUNT_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MAX2(null) -- 撤销日期
    ,'-' -- 出票状态代码
    ,'-' -- 结清标志
    ,P1.DRAFT_BP_RANGE -- 票据包区间编号
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,P1.STD_AMT -- 票据区间标准金额
    ,P1.BP_NUM -- 票据区间数量
    ,P1.RUN_CODE -- 信贷出账流水号
    ,' ' -- 历史数据标志
    ,p1.DRAFT_NUMBER -- 票据号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_accept_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_accept_details p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_ACCEPT_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acpt_dtl_id -- 承兑明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,pay_bank_ibank_no -- 付款行联行号
    ,lmt_deduct_amt -- 额度扣减金额
    ,bill_acpt_proc_status_cd -- 票据承兑处理状态代码
    ,recv_dt -- 签收日期
    ,entry_status_cd -- 记账状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,final_modif_tm -- 最后修改时间
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,draw_status_cd -- 出票状态代码
    ,payoff_flg -- 结清标志
    ,bill_pkg_intrv_id -- 票据包区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_corp_amt -- 票据区间标准金额
    ,bill_intrv_qtty -- 票据区间数量
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,bill_num -- 票据号码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acpt_dtl_id, o.acpt_dtl_id) as acpt_dtl_id -- 承兑明细编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.todos, o.todos) as todos -- 工本费
    ,nvl(n.exp_uncond_pay_entr_cd, o.exp_uncond_pay_entr_cd) as exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,nvl(n.pay_bank_ibank_no, o.pay_bank_ibank_no) as pay_bank_ibank_no -- 付款行联行号
    ,nvl(n.lmt_deduct_amt, o.lmt_deduct_amt) as lmt_deduct_amt -- 额度扣减金额
    ,nvl(n.bill_acpt_proc_status_cd, o.bill_acpt_proc_status_cd) as bill_acpt_proc_status_cd -- 票据承兑处理状态代码
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 签收日期
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.recv_opinion_cd, o.recv_opinion_cd) as recv_opinion_cd -- 签收意见代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.accptor_agent_reply_cd, o.accptor_agent_reply_cd) as accptor_agent_reply_cd -- 承兑人代理回复代码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,nvl(n.draw_status_cd, o.draw_status_cd) as draw_status_cd -- 出票状态代码
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.bill_pkg_intrv_id, o.bill_pkg_intrv_id) as bill_pkg_intrv_id -- 票据包区间编号
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.bill_intrv_corp_amt, o.bill_intrv_corp_amt) as bill_intrv_corp_amt -- 票据区间标准金额
    ,nvl(n.bill_intrv_qtty, o.bill_intrv_qtty) as bill_intrv_qtty -- 票据区间数量
    ,nvl(n.crdt_out_acct_flow_num, o.crdt_out_acct_flow_num) as crdt_out_acct_flow_num -- 信贷出账流水号
    ,nvl(n.h_data_flg, o.h_data_flg) as h_data_flg -- 历史数据标志
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acpt_dtl_id <> n.acpt_dtl_id
                or o.batch_id <> n.batch_id
                or o.bill_id <> n.bill_id
                or o.comm_fee <> n.comm_fee
                or o.todos <> n.todos
                or o.exp_uncond_pay_entr_cd <> n.exp_uncond_pay_entr_cd
                or o.pay_bank_ibank_no <> n.pay_bank_ibank_no
                or o.lmt_deduct_amt <> n.lmt_deduct_amt
                or o.bill_acpt_proc_status_cd <> n.bill_acpt_proc_status_cd
                or o.recv_dt <> n.recv_dt
                or o.entry_status_cd <> n.entry_status_cd
                or o.recv_opinion_cd <> n.recv_opinion_cd
                or o.final_modif_tm <> n.final_modif_tm
                or o.accptor_agent_reply_cd <> n.accptor_agent_reply_cd
                or o.entry_dt <> n.entry_dt
                or o.revo_dt <> n.revo_dt
                or o.draw_status_cd <> n.draw_status_cd
                or o.payoff_flg <> n.payoff_flg
                or o.bill_pkg_intrv_id <> n.bill_pkg_intrv_id
                or o.bill_amt <> n.bill_amt
                or o.bill_intrv_corp_amt <> n.bill_intrv_corp_amt
                or o.bill_intrv_qtty <> n.bill_intrv_qtty
                or o.crdt_out_acct_flow_num <> n.crdt_out_acct_flow_num
                or o.h_data_flg <> n.h_data_flg
                or o.bill_num <> n.bill_num
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_acpt_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_acpt_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_acpt_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_acpt_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_acpt_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_acpt_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);