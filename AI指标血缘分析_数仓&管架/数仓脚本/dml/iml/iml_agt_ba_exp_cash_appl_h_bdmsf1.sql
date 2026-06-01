/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ba_exp_cash_appl_h_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ba_exp_cash_appl_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_appl_h partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_appl_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_appl_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_appl_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_accept_due_pay-
insert into ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 申请编号
    ,'9999' -- 法人编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.DRAFT_ID -- 票据编号
    ,'101008'||TO_CHAR(P1.DRAFT_ID) -- 凭证编号
    ,nvl(trim(P1.ISSE_CURCD),'-') -- 票据币种代码
    ,P1.DRAFT_AMOUNT -- 贴现票据金额
    ,nvl(trim(P1.MESG_TYPE),'000') -- 报文申请类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,nvl(trim(P1.APPLY_CURCD),'-') -- 提示付款币种代码
    ,P1.ACCEPT_AMOUNT -- 兑付金额
    ,DECODE(TRIM(P1.STTLM_MK),'SM00','SM01','SM01','SM02','-')  -- 线上清算代码
    ,P1.VOC_CNT -- 所附凭证数量
    ,nvl(trim(P1.DRFT_HLDR_ROLE),'-') -- 提示付款人类别代码
    ,P1.DRFT_HLDR_CMONID -- 提示付款人组织机构代码
    ,P1.PAYEE_NAME -- 提示付款人名称
    ,P1.PAYEE_ACCOUNT -- 提示付款人账户编号
    ,P1.PAYEE_BANK_NO -- 提示付款人开户行行号
    ,nvl(trim(P1.ACCEPT_CURCD),'-') -- 兑付币种代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.RECEIVE_DATE) -- 提示付款申请日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DISH_CODE END -- 拒付代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.APPSTATUS END -- 审批状态代码
    ,nvl(trim(P1.SIG_MK),'-') -- 签收意见代码
    ,nvl(trim(P1.ACPAY_STATUS),'-') -- 发出签收明细状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_FLAG END -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCOUNT_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.CANCEL_DATE) -- 撤销日期
    ,P1.TRF_ID -- 支付交易号
    ,P1.TRF_REF -- 特许参与者编号
    ,nvl(trim(P1.POSITION_AUDIT_STATUS),'-') -- 头寸审批状态代码
    ,P1.POSITION_SEQNO -- 发送头寸流水号
    ,case when P1.PAYEE_TYPE='A' then '0' when P1.PAYEE_TYPE='B' THEN '1' ELSE '-'end -- 提前解付标志
    ,coalesce(SUBSTR(P1.LAST_UPD_TIME,9,2)||':'||SUBSTR(P1.LAST_UPD_TIME,11,2)||':'||SUBSTR(P1.LAST_UPD_TIME,13,2),'') -- 交易时间
    ,${iml_schema}.DATEFORMAT_MIN(SUBSTR(P1.LAST_UPD_TIME, 1, 8)) -- 交易日期
    ,P1.OPERATOR_NO -- 回复柜员编号
    ,P1.ACPT_ID -- 清单编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_due_pay' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_due_pay p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DISH_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_DUE_PAY'
        AND R1.SRC_FIELD_EN_NAME= 'DISH_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BA_EXP_CASH_APPL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REFUSE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.APPSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_DUE_PAY'
        AND R2.SRC_FIELD_EN_NAME= 'APPSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BA_EXP_CASH_APPL_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCOUNT_FLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_DUE_PAY'
        AND R3.SRC_FIELD_EN_NAME= 'ACCOUNT_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BA_EXP_CASH_APPL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm 
  	                                group by 
  	                                        appl_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.bill_curr_cd, o.bill_curr_cd) as bill_curr_cd -- 票据币种代码
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 贴现票据金额
    ,nvl(n.msg_appl_type_cd, o.msg_appl_type_cd) as msg_appl_type_cd -- 报文申请类型代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.sugst_pay_curr_cd, o.sugst_pay_curr_cd) as sugst_pay_curr_cd -- 提示付款币种代码
    ,nvl(n.cash_amt, o.cash_amt) as cash_amt -- 兑付金额
    ,nvl(n.onl_clear_cd, o.onl_clear_cd) as onl_clear_cd -- 线上清算代码
    ,nvl(n.vouch_qtty, o.vouch_qtty) as vouch_qtty -- 所附凭证数量
    ,nvl(n.sugst_payer_cate_cd, o.sugst_payer_cate_cd) as sugst_payer_cate_cd -- 提示付款人类别代码
    ,nvl(n.sugst_payer_orgnz_cd, o.sugst_payer_orgnz_cd) as sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,nvl(n.sugst_payer_name, o.sugst_payer_name) as sugst_payer_name -- 提示付款人名称
    ,nvl(n.sugst_payer_acct_id, o.sugst_payer_acct_id) as sugst_payer_acct_id -- 提示付款人账户编号
    ,nvl(n.sugst_payer_open_bank_no, o.sugst_payer_open_bank_no) as sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,nvl(n.cash_curr_cd, o.cash_curr_cd) as cash_curr_cd -- 兑付币种代码
    ,nvl(n.sugst_pay_appl_dt, o.sugst_pay_appl_dt) as sugst_pay_appl_dt -- 提示付款申请日期
    ,nvl(n.refuse_pay_cd, o.refuse_pay_cd) as refuse_pay_cd -- 拒付代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.recv_opinion_cd, o.recv_opinion_cd) as recv_opinion_cd -- 签收意见代码
    ,nvl(n.send_out_recv_status_cd, o.send_out_recv_status_cd) as send_out_recv_status_cd -- 发出签收明细状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,nvl(n.pay_tran_num, o.pay_tran_num) as pay_tran_num -- 支付交易号
    ,nvl(n.spec_prmssn_prtcptr_id, o.spec_prmssn_prtcptr_id) as spec_prmssn_prtcptr_id -- 特许参与者编号
    ,nvl(n.pos_apv_status_cd, o.pos_apv_status_cd) as pos_apv_status_cd -- 头寸审批状态代码
    ,nvl(n.send_pos_flow_num, o.send_pos_flow_num) as send_pos_flow_num -- 发送头寸流水号
    ,nvl(n.adv_solu_pay_flg, o.adv_solu_pay_flg) as adv_solu_pay_flg -- 提前解付标志
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.reply_teller_id, o.reply_teller_id) as reply_teller_id -- 回复柜员编号
    ,nvl(n.lt_id, o.lt_id) as lt_id -- 清单编号
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.bill_id <> n.bill_id
        or o.vouch_id <> n.vouch_id
        or o.bill_curr_cd <> n.bill_curr_cd
        or o.bill_amt <> n.bill_amt
        or o.msg_appl_type_cd <> n.msg_appl_type_cd
        or o.appl_dt <> n.appl_dt
        or o.sugst_pay_curr_cd <> n.sugst_pay_curr_cd
        or o.cash_amt <> n.cash_amt
        or o.onl_clear_cd <> n.onl_clear_cd
        or o.vouch_qtty <> n.vouch_qtty
        or o.sugst_payer_cate_cd <> n.sugst_payer_cate_cd
        or o.sugst_payer_orgnz_cd <> n.sugst_payer_orgnz_cd
        or o.sugst_payer_name <> n.sugst_payer_name
        or o.sugst_payer_acct_id <> n.sugst_payer_acct_id
        or o.sugst_payer_open_bank_no <> n.sugst_payer_open_bank_no
        or o.cash_curr_cd <> n.cash_curr_cd
        or o.sugst_pay_appl_dt <> n.sugst_pay_appl_dt
        or o.refuse_pay_cd <> n.refuse_pay_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.recv_opinion_cd <> n.recv_opinion_cd
        or o.send_out_recv_status_cd <> n.send_out_recv_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.entry_dt <> n.entry_dt
        or o.revo_dt <> n.revo_dt
        or o.pay_tran_num <> n.pay_tran_num
        or o.spec_prmssn_prtcptr_id <> n.spec_prmssn_prtcptr_id
        or o.pos_apv_status_cd <> n.pos_apv_status_cd
        or o.send_pos_flow_num <> n.send_pos_flow_num
        or o.adv_solu_pay_flg <> n.adv_solu_pay_flg
        or o.tran_tm <> n.tran_tm
        or o.tran_dt <> n.tran_dt
        or o.reply_teller_id <> n.reply_teller_id
        or o.lt_id <> n.lt_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 贴现票据金额
    ,msg_appl_type_cd -- 报文申请类型代码
    ,appl_dt -- 申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,cash_amt -- 兑付金额
    ,onl_clear_cd -- 线上清算代码
    ,vouch_qtty -- 所附凭证数量
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_id -- 提示付款人账户编号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,cash_curr_cd -- 兑付币种代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,refuse_pay_cd -- 拒付代码
    ,apv_status_cd -- 审批状态代码
    ,recv_opinion_cd -- 签收意见代码
    ,send_out_recv_status_cd -- 发出签收明细状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,revo_dt -- 撤销日期
    ,pay_tran_num -- 支付交易号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pos_apv_status_cd -- 头寸审批状态代码
    ,send_pos_flow_num -- 发送头寸流水号
    ,adv_solu_pay_flg -- 提前解付标志
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,reply_teller_id -- 回复柜员编号
    ,lt_id -- 清单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.org_id -- 机构编号
    ,o.bill_id -- 票据编号
    ,o.vouch_id -- 凭证编号
    ,o.bill_curr_cd -- 票据币种代码
    ,o.bill_amt -- 贴现票据金额
    ,o.msg_appl_type_cd -- 报文申请类型代码
    ,o.appl_dt -- 申请日期
    ,o.sugst_pay_curr_cd -- 提示付款币种代码
    ,o.cash_amt -- 兑付金额
    ,o.onl_clear_cd -- 线上清算代码
    ,o.vouch_qtty -- 所附凭证数量
    ,o.sugst_payer_cate_cd -- 提示付款人类别代码
    ,o.sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,o.sugst_payer_name -- 提示付款人名称
    ,o.sugst_payer_acct_id -- 提示付款人账户编号
    ,o.sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,o.cash_curr_cd -- 兑付币种代码
    ,o.sugst_pay_appl_dt -- 提示付款申请日期
    ,o.refuse_pay_cd -- 拒付代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.recv_opinion_cd -- 签收意见代码
    ,o.send_out_recv_status_cd -- 发出签收明细状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.entry_dt -- 记账日期
    ,o.revo_dt -- 撤销日期
    ,o.pay_tran_num -- 支付交易号
    ,o.spec_prmssn_prtcptr_id -- 特许参与者编号
    ,o.pos_apv_status_cd -- 头寸审批状态代码
    ,o.send_pos_flow_num -- 发送头寸流水号
    ,o.adv_solu_pay_flg -- 提前解付标志
    ,o.tran_tm -- 交易时间
    ,o.tran_dt -- 交易日期
    ,o.reply_teller_id -- 回复柜员编号
    ,o.lt_id -- 清单编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_bk o
    left join ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ba_exp_cash_appl_h;
--alter table ${iml_schema}.agt_ba_exp_cash_appl_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ba_exp_cash_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ba_exp_cash_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ba_exp_cash_appl_h modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ba_exp_cash_appl_h exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl;
alter table ${iml_schema}.agt_ba_exp_cash_appl_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ba_exp_cash_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ba_exp_cash_appl_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ba_exp_cash_appl_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
