/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_discnt_dtl_bdmsf1
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
drop table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_discnt_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_discnt_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_discnt_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,buy_dtl_id -- 买入明细编号
    ,buy_way_cd -- 买入方式代码
    ,batch_id -- 批次编号
    ,discnt_type_cd -- 贴现类型代码
    ,bill_id -- 票据编号
    ,city_wide_flg -- 同城标志
    ,rher_name -- 前手名称
    ,int_accr_exp_dt -- 计息到期日期
    ,defer_days -- 顺延天数
    ,int_accr_days -- 计息天数
    ,not_ngbl_flg -- 不得转让标志
    ,int_amt -- 利息金额
    ,onl_clear_flg -- 线上清算标志
    ,buyer_pay_int -- 买方付息利息
    ,actl_amt -- 贴现金额
    ,discnt_appl_enter_acct_num -- 贴现申请入账账号
    ,discnt_appl_enter_acct_bk_no -- 贴现申请入账行行号
    ,dscnt_props_cate_cd -- 贴出人类别代码
    ,dscnt_props_name -- 贴出人名称
    ,dscnt_props_orgnz_cd -- 贴出人组织机构代码
    ,dscnt_props_acct_num -- 贴出人账号
    ,dscnt_props_udtake_bk_no -- 贴出人承接行行号
    ,tran_cont_id -- 交易合同编号
    ,entry_dt -- 记账日期
    ,entry_status_cd -- 记账状态代码
    ,recv_dt -- 签收日期
    ,buy_dtl_status_cd -- 买入明细状态代码
    ,final_modif_tm -- 最后修改时间
    ,modif_teller_id -- 修改柜员编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,quick_discnt_status_cd -- 秒贴状态代码
    ,quick_discnt_flg -- 秒贴标志
    ,bill_src_cd -- 票据来源代码
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,accept_ps_name -- 收票人名称
    ,accept_ps_acct_id -- 收票人账户编号
    ,accept_ps_open_bank_num -- 收票人开户行号
    ,accept_ps_open_bank_name -- 收票人开户行名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discnt_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_discnt_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_buy_details-
insert into ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,buy_dtl_id -- 买入明细编号
    ,buy_way_cd -- 买入方式代码
    ,batch_id -- 批次编号
    ,discnt_type_cd -- 贴现类型代码
    ,bill_id -- 票据编号
    ,city_wide_flg -- 同城标志
    ,rher_name -- 前手名称
    ,int_accr_exp_dt -- 计息到期日期
    ,defer_days -- 顺延天数
    ,int_accr_days -- 计息天数
    ,not_ngbl_flg -- 不得转让标志
    ,int_amt -- 利息金额
    ,onl_clear_flg -- 线上清算标志
    ,buyer_pay_int -- 买方付息利息
    ,actl_amt -- 贴现金额
    ,discnt_appl_enter_acct_num -- 贴现申请入账账号
    ,discnt_appl_enter_acct_bk_no -- 贴现申请入账行行号
    ,dscnt_props_cate_cd -- 贴出人类别代码
    ,dscnt_props_name -- 贴出人名称
    ,dscnt_props_orgnz_cd -- 贴出人组织机构代码
    ,dscnt_props_acct_num -- 贴出人账号
    ,dscnt_props_udtake_bk_no -- 贴出人承接行行号
    ,tran_cont_id -- 交易合同编号
    ,entry_dt -- 记账日期
    ,entry_status_cd -- 记账状态代码
    ,recv_dt -- 签收日期
    ,buy_dtl_status_cd -- 买入明细状态代码
    ,final_modif_tm -- 最后修改时间
    ,modif_teller_id -- 修改柜员编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,quick_discnt_status_cd -- 秒贴状态代码
    ,quick_discnt_flg -- 秒贴标志
    ,bill_src_cd -- 票据来源代码
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,accept_ps_name -- 收票人名称
    ,accept_ps_acct_id -- 收票人账户编号
    ,accept_ps_open_bank_num -- 收票人开户行号
    ,accept_ps_open_bank_name -- 收票人开户行名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223102'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 买入明细编号
    ,NVL(TRIM(P1.BUY_TYPE),'00') -- 买入方式代码
    ,P1.CONTRACT_ID -- 批次编号
    ,NVL(TRIM(P1.CENTRAL_BANKFLG),'-') -- 贴现类型代码
    ,P1.DRAFT_ID -- 票据编号
    ,nvl(trim(P1.SAME_CITY_FLAG),'-') -- 同城标志
    ,P1.PREVIOUS_HAND -- 前手名称
    ,${iml_schema}.DATEFORMAT_MAX2(P1.PAYMENT_DATE) -- 计息到期日期
    ,P1.POSTPONE_DAYS -- 顺延天数
    ,P1.PAYMENT_DAYS -- 计息天数
    ,nvl(trim(P1.END_SMT_FLAG),'-') -- 不得转让标志
    ,P1.INTEREST -- 利息金额
    ,nvl(trim(P1.STTLM_MK),'-') -- 线上清算标志
    ,P1.PAYER_AMOUNT -- 买方付息利息
    ,P1.PAY_AMOUNT -- 贴现金额
    ,P1.AOA_ACCOUNT -- 贴现申请入账账号
    ,P1.AOA_BANK_ID -- 贴现申请入账行行号
    ,NVL(TRIM(P1.DSCNT_PROPS_ROLE),'-') -- 贴出人类别代码
    ,P1.DSCNT_PROPS_NAME -- 贴出人名称
    ,P1.DSCNT_PROPS_CMONID -- 贴出人组织机构代码
    ,P1.DSCNT_PROPS_ACTNO -- 贴出人账号
    ,P1.DSCNT_PROPS_AGCY_UBANK -- 贴出人承接行行号
    ,P1.BTCH_NB -- 交易合同编号
    ,P1.ACCONT_DATE -- 记账日期
    ,nvl(trim(P1.ACCOUNT_STATUS),'-') -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ENDST_DATE) -- 签收日期
    ,nvl(trim(P1.BUY_STATUS),'-') -- 买入明细状态代码
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,P1.LAST_OPERATOR_NO -- 修改柜员编号
    ,'-' -- 票据子区间编号
    ,nvl(trim(P1.FLASH_DISCNT_STATUS),'-') -- 秒贴状态代码
    ,NVL(TRIM(P1.FLASH_DISCNT_FLAG),'-') -- 秒贴标志
    ,' ' -- 票据来源代码
    ,P1.RUN_CODE -- 信贷出账流水号
    ,P1.RESERVE1 -- 历史数据标志
    ,P1.PAYEE_NAME -- 收票人名称
    ,P1.PAYEE_ACCOUNT -- 收票人账户编号
    ,P1.PAYEE_BANK_NO -- 收票人开户行号
    ,P1.PAYEE_BANK_NAME -- 收票人开户行名称
    ,P1.DRAWEE_BANK_NO -- 付款行行号
    ,P1.DRAWEE_BANK_NAME -- 付款行名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_buy_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_buy_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.CENTRAL_BANKFLG='0'
;
commit;

-- bdms_cpes_buy_details-
insert into ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,buy_dtl_id -- 买入明细编号
    ,buy_way_cd -- 买入方式代码
    ,batch_id -- 批次编号
    ,discnt_type_cd -- 贴现类型代码
    ,bill_id -- 票据编号
    ,city_wide_flg -- 同城标志
    ,rher_name -- 前手名称
    ,int_accr_exp_dt -- 计息到期日期
    ,defer_days -- 顺延天数
    ,int_accr_days -- 计息天数
    ,not_ngbl_flg -- 不得转让标志
    ,int_amt -- 利息金额
    ,onl_clear_flg -- 线上清算标志
    ,buyer_pay_int -- 买方付息利息
    ,actl_amt -- 贴现金额
    ,discnt_appl_enter_acct_num -- 贴现申请入账账号
    ,discnt_appl_enter_acct_bk_no -- 贴现申请入账行行号
    ,dscnt_props_cate_cd -- 贴出人类别代码
    ,dscnt_props_name -- 贴出人名称
    ,dscnt_props_orgnz_cd -- 贴出人组织机构代码
    ,dscnt_props_acct_num -- 贴出人账号
    ,dscnt_props_udtake_bk_no -- 贴出人承接行行号
    ,tran_cont_id -- 交易合同编号
    ,entry_dt -- 记账日期
    ,entry_status_cd -- 记账状态代码
    ,recv_dt -- 签收日期
    ,buy_dtl_status_cd -- 买入明细状态代码
    ,final_modif_tm -- 最后修改时间
    ,modif_teller_id -- 修改柜员编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,quick_discnt_status_cd -- 秒贴状态代码
    ,quick_discnt_flg -- 秒贴标志
    ,bill_src_cd -- 票据来源代码
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,accept_ps_name -- 收票人名称
    ,accept_ps_acct_id -- 收票人账户编号
    ,accept_ps_open_bank_num -- 收票人开户行号
    ,accept_ps_open_bank_name -- 收票人开户行名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223109'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 买入明细编号
    ,'00' -- 买入方式代码
    ,P1.CONTRACT_ID -- 批次编号
    ,'-' -- 贴现类型代码
    ,P1.DRAFT_ID -- 票据编号
    ,nvl(trim(P1.SAME_CITY_FLAG),' ') -- 同城标志
    ,P1.PREVIOUS_HAND -- 前手名称
    ,${iml_schema}.DATEFORMAT_MAX2(P1.PAYMENT_DATE) -- 计息到期日期
    ,P1.POSTPONE_DAYS -- 顺延天数
    ,P1.PAYMENT_DAYS -- 计息天数
    ,nvl(trim(P1.END_SMT_FLAG),'-') -- 不得转让标志
    ,P1.INTEREST -- 利息金额
    ,'-' -- 线上清算标志
    ,P1.PAYER_AMOUNT -- 买方付息利息
    ,P1.PAY_AMOUNT -- 贴现金额
    ,P1.AOA_ACCOUNT -- 贴现申请入账账号
    ,P1.AOA_BANK_ID -- 贴现申请入账行行号
    ,'-' -- 贴出人类别代码
    ,' ' -- 贴出人名称
    ,' ' -- 贴出人组织机构代码
    ,' ' -- 贴出人账号
    ,' ' -- 贴出人承接行行号
    ,' ' -- 交易合同编号
    ,P1.ACCONT_DATE -- 记账日期
    ,nvl(trim(P1.ACCOUNT_STATUS),'-') -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MAX2(null) -- 签收日期
    ,nvl(trim(P1.BUY_STATUS),'-') -- 买入明细状态代码
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,P1.LAST_OPERATOR_NO -- 修改柜员编号
    ,P1.CD_RANGE -- 票据子区间编号
    ,NVL(TRIM(P1.FLASH_DISCNT_STATUS),'-') -- 秒贴状态代码
    ,NVL(TRIM(P1.FLASH_DISCNT_FLAG),'-') -- 秒贴标志
    ,nvl(trim(P1.DRAFT_CATEGORY),'-') -- 票据来源代码
    ,P1.RUN_CODE -- 信贷出账流水号
    ,' ' -- 历史数据标志
    ,P1.PAYEE_NAME -- 收票人名称
    ,P1.PAYEE_ACCOUNT -- 收票人账户编号
    ,P1.PAYEE_BANK_NO -- 收票人开户行号
    ,P1.PAYEE_BANK_NAME -- 收票人开户行名称
    ,P1.DRAWEE_BANK_NO -- 付款行行号
    ,P1.DRAWEE_BANK_NAME -- 付款行名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_buy_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_buy_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,buy_dtl_id -- 买入明细编号
    ,buy_way_cd -- 买入方式代码
    ,batch_id -- 批次编号
    ,discnt_type_cd -- 贴现类型代码
    ,bill_id -- 票据编号
    ,city_wide_flg -- 同城标志
    ,rher_name -- 前手名称
    ,int_accr_exp_dt -- 计息到期日期
    ,defer_days -- 顺延天数
    ,int_accr_days -- 计息天数
    ,not_ngbl_flg -- 不得转让标志
    ,int_amt -- 利息金额
    ,onl_clear_flg -- 线上清算标志
    ,buyer_pay_int -- 买方付息利息
    ,actl_amt -- 贴现金额
    ,discnt_appl_enter_acct_num -- 贴现申请入账账号
    ,discnt_appl_enter_acct_bk_no -- 贴现申请入账行行号
    ,dscnt_props_cate_cd -- 贴出人类别代码
    ,dscnt_props_name -- 贴出人名称
    ,dscnt_props_orgnz_cd -- 贴出人组织机构代码
    ,dscnt_props_acct_num -- 贴出人账号
    ,dscnt_props_udtake_bk_no -- 贴出人承接行行号
    ,tran_cont_id -- 交易合同编号
    ,entry_dt -- 记账日期
    ,entry_status_cd -- 记账状态代码
    ,recv_dt -- 签收日期
    ,buy_dtl_status_cd -- 买入明细状态代码
    ,final_modif_tm -- 最后修改时间
    ,modif_teller_id -- 修改柜员编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,quick_discnt_status_cd -- 秒贴状态代码
    ,quick_discnt_flg -- 秒贴标志
    ,bill_src_cd -- 票据来源代码
    ,crdt_out_acct_flow_num -- 信贷出账流水号
    ,h_data_flg -- 历史数据标志
    ,accept_ps_name -- 收票人名称
    ,accept_ps_acct_id -- 收票人账户编号
    ,accept_ps_open_bank_num -- 收票人开户行号
    ,accept_ps_open_bank_name -- 收票人开户行名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
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
    ,nvl(n.buy_dtl_id, o.buy_dtl_id) as buy_dtl_id -- 买入明细编号
    ,nvl(n.buy_way_cd, o.buy_way_cd) as buy_way_cd -- 买入方式代码
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.discnt_type_cd, o.discnt_type_cd) as discnt_type_cd -- 贴现类型代码
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.city_wide_flg, o.city_wide_flg) as city_wide_flg -- 同城标志
    ,nvl(n.rher_name, o.rher_name) as rher_name -- 前手名称
    ,nvl(n.int_accr_exp_dt, o.int_accr_exp_dt) as int_accr_exp_dt -- 计息到期日期
    ,nvl(n.defer_days, o.defer_days) as defer_days -- 顺延天数
    ,nvl(n.int_accr_days, o.int_accr_days) as int_accr_days -- 计息天数
    ,nvl(n.not_ngbl_flg, o.not_ngbl_flg) as not_ngbl_flg -- 不得转让标志
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.onl_clear_flg, o.onl_clear_flg) as onl_clear_flg -- 线上清算标志
    ,nvl(n.buyer_pay_int, o.buyer_pay_int) as buyer_pay_int -- 买方付息利息
    ,nvl(n.actl_amt, o.actl_amt) as actl_amt -- 贴现金额
    ,nvl(n.discnt_appl_enter_acct_num, o.discnt_appl_enter_acct_num) as discnt_appl_enter_acct_num -- 贴现申请入账账号
    ,nvl(n.discnt_appl_enter_acct_bk_no, o.discnt_appl_enter_acct_bk_no) as discnt_appl_enter_acct_bk_no -- 贴现申请入账行行号
    ,nvl(n.dscnt_props_cate_cd, o.dscnt_props_cate_cd) as dscnt_props_cate_cd -- 贴出人类别代码
    ,nvl(n.dscnt_props_name, o.dscnt_props_name) as dscnt_props_name -- 贴出人名称
    ,nvl(n.dscnt_props_orgnz_cd, o.dscnt_props_orgnz_cd) as dscnt_props_orgnz_cd -- 贴出人组织机构代码
    ,nvl(n.dscnt_props_acct_num, o.dscnt_props_acct_num) as dscnt_props_acct_num -- 贴出人账号
    ,nvl(n.dscnt_props_udtake_bk_no, o.dscnt_props_udtake_bk_no) as dscnt_props_udtake_bk_no -- 贴出人承接行行号
    ,nvl(n.tran_cont_id, o.tran_cont_id) as tran_cont_id -- 交易合同编号
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 签收日期
    ,nvl(n.buy_dtl_status_cd, o.buy_dtl_status_cd) as buy_dtl_status_cd -- 买入明细状态代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.modif_teller_id, o.modif_teller_id) as modif_teller_id -- 修改柜员编号
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,nvl(n.quick_discnt_status_cd, o.quick_discnt_status_cd) as quick_discnt_status_cd -- 秒贴状态代码
    ,nvl(n.quick_discnt_flg, o.quick_discnt_flg) as quick_discnt_flg -- 秒贴标志
    ,nvl(n.bill_src_cd, o.bill_src_cd) as bill_src_cd -- 票据来源代码
    ,nvl(n.crdt_out_acct_flow_num, o.crdt_out_acct_flow_num) as crdt_out_acct_flow_num -- 信贷出账流水号
    ,nvl(n.h_data_flg, o.h_data_flg) as h_data_flg -- 历史数据标志
    ,nvl(n.accept_ps_name, o.accept_ps_name) as accept_ps_name -- 收票人名称
    ,nvl(n.accept_ps_acct_id, o.accept_ps_acct_id) as accept_ps_acct_id -- 收票人账户编号
    ,nvl(n.accept_ps_open_bank_num, o.accept_ps_open_bank_num) as accept_ps_open_bank_num -- 收票人开户行号
    ,nvl(n.accept_ps_open_bank_name, o.accept_ps_open_bank_name) as accept_ps_open_bank_name -- 收票人开户行名称
    ,nvl(n.pay_bank_bank_no, o.pay_bank_bank_no) as pay_bank_bank_no -- 付款行行号
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款行名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.buy_dtl_id <> n.buy_dtl_id
                or o.buy_way_cd <> n.buy_way_cd
                or o.batch_id <> n.batch_id
                or o.discnt_type_cd <> n.discnt_type_cd
                or o.bill_id <> n.bill_id
                or o.city_wide_flg <> n.city_wide_flg
                or o.rher_name <> n.rher_name
                or o.int_accr_exp_dt <> n.int_accr_exp_dt
                or o.defer_days <> n.defer_days
                or o.int_accr_days <> n.int_accr_days
                or o.not_ngbl_flg <> n.not_ngbl_flg
                or o.int_amt <> n.int_amt
                or o.onl_clear_flg <> n.onl_clear_flg
                or o.buyer_pay_int <> n.buyer_pay_int
                or o.actl_amt <> n.actl_amt
                or o.discnt_appl_enter_acct_num <> n.discnt_appl_enter_acct_num
                or o.discnt_appl_enter_acct_bk_no <> n.discnt_appl_enter_acct_bk_no
                or o.dscnt_props_cate_cd <> n.dscnt_props_cate_cd
                or o.dscnt_props_name <> n.dscnt_props_name
                or o.dscnt_props_orgnz_cd <> n.dscnt_props_orgnz_cd
                or o.dscnt_props_acct_num <> n.dscnt_props_acct_num
                or o.dscnt_props_udtake_bk_no <> n.dscnt_props_udtake_bk_no
                or o.tran_cont_id <> n.tran_cont_id
                or o.entry_dt <> n.entry_dt
                or o.entry_status_cd <> n.entry_status_cd
                or o.recv_dt <> n.recv_dt
                or o.buy_dtl_status_cd <> n.buy_dtl_status_cd
                or o.final_modif_tm <> n.final_modif_tm
                or o.modif_teller_id <> n.modif_teller_id
                or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
                or o.quick_discnt_status_cd <> n.quick_discnt_status_cd
                or o.quick_discnt_flg <> n.quick_discnt_flg
                or o.bill_src_cd <> n.bill_src_cd
                or o.crdt_out_acct_flow_num <> n.crdt_out_acct_flow_num
                or o.h_data_flg <> n.h_data_flg
                or o.accept_ps_name <> n.accept_ps_name
                or o.accept_ps_acct_id <> n.accept_ps_acct_id
                or o.accept_ps_open_bank_num <> n.accept_ps_open_bank_num
                or o.accept_ps_open_bank_name <> n.accept_ps_open_bank_name
                or o.pay_bank_bank_no <> n.pay_bank_bank_no
                or o.pay_bank_name <> n.pay_bank_name
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
from ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_discnt_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_discnt_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_discnt_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_discnt_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_discnt_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_discnt_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);