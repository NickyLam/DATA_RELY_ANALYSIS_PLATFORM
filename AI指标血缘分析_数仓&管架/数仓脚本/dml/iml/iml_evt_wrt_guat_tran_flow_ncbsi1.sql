/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wrt_guat_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_wrt_guat_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_wrt_guat_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wrt_guat_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wrt_guat_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cash_tran_seq_num -- 现金交易序号
    ,cr_acct_id -- 贷方账户编号
    ,cr_cust_acct_num -- 贷方客户账号
    ,cr_acct_curr -- 贷方账户币种代码
    ,cr_acct_sub_acct_num -- 贷方账户子账号
    ,cr_acct_prod_id -- 贷方账户产品编号
    ,cr_bal_type_cd -- 贷方钞汇余额代码
    ,cr_tran_seq_num -- 贷方交易序号
    ,dr_acct_id -- 借方账户编号
    ,dr_cust_acct_num -- 借方客户账号
    ,dr_acct_curr -- 借方账户币种代码
    ,dr_acct_sub_acct_num -- 借方账户子账号
    ,dr_acct_prod_id -- 借方账户产品编号
    ,dr_bal_type_cd -- 借方钞汇余额代码
    ,dr_tran_seq_num -- 借方交易序号
    ,cust_id -- 客户编号
    ,tran_cd -- 交易码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,revs_dt -- 冲正日期
    ,revs_tran_cd -- 冲正交易码
    ,wrt_guat_tran_status_cd -- 结售汇交易状态代码
    ,bus_type_cd -- 业务类型代码
    ,quot_type_cd -- 牌价类型代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,buy_amt -- 买入金额
    ,buy_curr_cd -- 买入币种代码
    ,buyer_exch_rat -- 买方汇率
    ,sell_curr -- 卖出币种代码
    ,sell_amt -- 卖出金额
    ,seller_exch_rat -- 卖方汇率
    ,exec_exch_rat -- 执行汇率
    ,float_int_rat -- 浮动利率
    ,base_quot_way_cd -- 基础报价方式代码
    ,base_exch_rat_type_cd -- 基础汇率类型代码
    ,base_exch_rat -- 基础汇率
    ,base_equvl_amt -- 基础等值金额
    ,cross_exch_rat -- 交叉汇率
    ,offset_cross_exch_rat -- 平盘交叉汇率
    ,intnal_price -- 内部价格
    ,change_equvl_amt -- 找零等值金额
    ,change_amt -- 找零金额
    ,change_base_int_rat -- 找零基础利率
    ,change_base_int_rat_type_cd -- 找零基础利率类型代码
    ,change_int_rat -- 找零利率
    ,change_base_quot_way_cd -- 找零基础报价方式代码
    ,change_quot_way_cd -- 找零报价方式代码
    ,change_int_rat_type_cd -- 找零利率类型代码
    ,tran_ref_no -- 交易参考号
    ,follow_ref_no -- 跟踪参考号
    ,chn_id -- 渠道编号
    ,bank_tran_seq_num -- 银行交易序号
    ,tran_descb -- 交易描述
    ,src_module_type_cd -- 源模块类型代码
    ,tran_termn_id -- 交易终端编号
    ,check_dt -- 复核日期
    ,entry_dt -- 记账日期
    ,check_teller_id -- 复核柜员编号
    ,check_auth_teller_id -- 复核授权柜员编号
    ,tran_auth_teller_id -- 交易授权柜员编号
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_teller_id -- 冲正柜员编号
    ,core_tran_teller_id -- 核心交易柜员编号
    ,tran_tm -- 交易时间
    ,offset_status_cd -- 平盘状态代码
    ,fcurr_hq_sys_in_suplm_amt -- 外币总行系统内平补金额
    ,sys_in_offset_flow_num -- 系统内平盘流水号
    ,tran_market_offset_flow_num -- 交易市场平盘流水号
    ,zero_proc_flg -- 是否尾零处理标志
    ,float_spread -- 浮动点差
    ,exch_rat_quot_effect_tm -- 汇率牌价生效时间
    ,exch_rat_quot_effect_dt -- 汇率牌价生效日期
    ,sell_offset_exch_rat -- 卖出平盘汇率
    ,buy_offset_exch_rat -- 买入平盘汇率
    ,wg_bus_type_cd -- 结售汇业务类型代码
    ,overser_proof_flg -- 海外人才证明标志
    ,overser_proof_descb -- 海外人才证明描述
    ,overser_remark -- 海外人才备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wrt_guat_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_exchange_tran_hist-1
insert into ${iml_schema}.evt_wrt_guat_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cash_tran_seq_num -- 现金交易序号
    ,cr_acct_id -- 贷方账户编号
    ,cr_cust_acct_num -- 贷方客户账号
    ,cr_acct_curr -- 贷方账户币种代码
    ,cr_acct_sub_acct_num -- 贷方账户子账号
    ,cr_acct_prod_id -- 贷方账户产品编号
    ,cr_bal_type_cd -- 贷方钞汇余额代码
    ,cr_tran_seq_num -- 贷方交易序号
    ,dr_acct_id -- 借方账户编号
    ,dr_cust_acct_num -- 借方客户账号
    ,dr_acct_curr -- 借方账户币种代码
    ,dr_acct_sub_acct_num -- 借方账户子账号
    ,dr_acct_prod_id -- 借方账户产品编号
    ,dr_bal_type_cd -- 借方钞汇余额代码
    ,dr_tran_seq_num -- 借方交易序号
    ,cust_id -- 客户编号
    ,tran_cd -- 交易码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,revs_dt -- 冲正日期
    ,revs_tran_cd -- 冲正交易码
    ,wrt_guat_tran_status_cd -- 结售汇交易状态代码
    ,bus_type_cd -- 业务类型代码
    ,quot_type_cd -- 牌价类型代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,buy_amt -- 买入金额
    ,buy_curr_cd -- 买入币种代码
    ,buyer_exch_rat -- 买方汇率
    ,sell_curr -- 卖出币种代码
    ,sell_amt -- 卖出金额
    ,seller_exch_rat -- 卖方汇率
    ,exec_exch_rat -- 执行汇率
    ,float_int_rat -- 浮动利率
    ,base_quot_way_cd -- 基础报价方式代码
    ,base_exch_rat_type_cd -- 基础汇率类型代码
    ,base_exch_rat -- 基础汇率
    ,base_equvl_amt -- 基础等值金额
    ,cross_exch_rat -- 交叉汇率
    ,offset_cross_exch_rat -- 平盘交叉汇率
    ,intnal_price -- 内部价格
    ,change_equvl_amt -- 找零等值金额
    ,change_amt -- 找零金额
    ,change_base_int_rat -- 找零基础利率
    ,change_base_int_rat_type_cd -- 找零基础利率类型代码
    ,change_int_rat -- 找零利率
    ,change_base_quot_way_cd -- 找零基础报价方式代码
    ,change_quot_way_cd -- 找零报价方式代码
    ,change_int_rat_type_cd -- 找零利率类型代码
    ,tran_ref_no -- 交易参考号
    ,follow_ref_no -- 跟踪参考号
    ,chn_id -- 渠道编号
    ,bank_tran_seq_num -- 银行交易序号
    ,tran_descb -- 交易描述
    ,src_module_type_cd -- 源模块类型代码
    ,tran_termn_id -- 交易终端编号
    ,check_dt -- 复核日期
    ,entry_dt -- 记账日期
    ,check_teller_id -- 复核柜员编号
    ,check_auth_teller_id -- 复核授权柜员编号
    ,tran_auth_teller_id -- 交易授权柜员编号
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_teller_id -- 冲正柜员编号
    ,core_tran_teller_id -- 核心交易柜员编号
    ,tran_tm -- 交易时间
    ,offset_status_cd -- 平盘状态代码
    ,fcurr_hq_sys_in_suplm_amt -- 外币总行系统内平补金额
    ,sys_in_offset_flow_num -- 系统内平盘流水号
    ,tran_market_offset_flow_num -- 交易市场平盘流水号
    ,zero_proc_flg -- 是否尾零处理标志
    ,float_spread -- 浮动点差
    ,exch_rat_quot_effect_tm -- 汇率牌价生效时间
    ,exch_rat_quot_effect_dt -- 汇率牌价生效日期
    ,sell_offset_exch_rat -- 卖出平盘汇率
    ,buy_offset_exch_rat -- 买入平盘汇率
    ,wg_bus_type_cd -- 结售汇业务类型代码
    ,overser_proof_flg -- 海外人才证明标志
    ,overser_proof_descb -- 海外人才证明描述
    ,overser_remark -- 海外人才备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201005'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.CASH_SEQ_NO -- 现金交易序号
    ,decode(P1.DEPOSIT_INTERNAL_KEY,'0','',P1.DEPOSIT_INTERNAL_KEY) -- 贷方账户编号
    ,nvl(trim(p8.card_no),p1.DEPOSIT_BASE_ACCT_NO) -- 贷方客户账号
    ,NVL(TRIM(P1.CR_ACCT_CCY),'-') -- 贷方账户币种代码
    ,P1.DEPOSIT_ACCT_SEQ_NO -- 贷方账户子账号
    ,P1.DEPOSIT_PROD_TYPE -- 贷方账户产品编号
    ,nvl(trim(P1.DEPOSIT_BALANCE_TYPE),'-') -- 贷方钞汇余额代码
    ,P1.DEPOSIT_SEQ_NO -- 贷方交易序号
    ,decode(P1.WITHDRAW_INTERNAL_KEY,'0','',P1.WITHDRAW_INTERNAL_KEY) -- 借方账户编号
    ,nvl(trim(p9.card_no),p1.WITHDRAW_BASE_ACCT_NO) -- 借方客户账号
    ,NVL(TRIM(P1.WITHDRAW_ACCT_CCY),'-') -- 借方账户币种代码
    ,P1.WITHDRAW_ACCT_SEQ_NO -- 借方账户子账号
    ,P1.WITHDRAW_PROD_TYPE -- 借方账户产品编号
    ,nvl(trim(P1.WITHDRAW_BALANCE_TYPE),'-') -- 借方钞汇余额代码
    ,P1.WITHDRAW_SEQ_NO -- 借方交易序号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,P1.EXCHANGE_TRAN_STATUS -- 结售汇交易状态代码
    ,P1.SELL_BUY_IND -- 业务类型代码
    ,P1.QUOTE_TYPE -- 牌价类型代码
    ,nvl(trim(P1.RATE_TYPE),'-') -- 汇率类型代码
    ,P1.BUY_AMOUNT -- 买入金额
    ,nvl(trim(P1.BUY_CCY),'-') -- 买入币种代码
    ,P1.BUY_RATE -- 买方汇率
    ,NVL(TRIM(P1.SELL_CCY),'-') -- 卖出币种代码
    ,P1.SELL_AMOUNT -- 卖出金额
    ,P1.SELL_RATE -- 卖方汇率
    ,P1.EXCH_RATE -- 执行汇率
    ,P1.FLOAT_RATE -- 浮动利率
    ,nvl(trim(P1.BASE_QUOTE_TYPE),'-') -- 基础报价方式代码
    ,nvl(trim(P1.BASE_RATE_TYPE),'-') -- 基础汇率类型代码
    ,P1.BASE_RATE -- 基础汇率
    ,P1.BASE_EQUIV_AMT -- 基础等值金额
    ,P1.CROSS_RATE -- 交叉汇率
    ,P1.UNC_CROSS_RATE -- 平盘交叉汇率
    ,P1.INNER_RATE -- 内部价格
    ,P1.CHANGE_BASE_EQUIV_AMT -- 找零等值金额
    ,P1.CHANGE_CNY_AMOUNT -- 找零金额
    ,P1.CHANGE_BASE_RATE -- 找零基础利率
    ,nvl(trim(P1.CHANGE_BASE_RATE_TYPE),'-') -- 找零基础利率类型代码
    ,P1.CHANGE_RATE -- 找零利率
    ,nvl(trim(P1.CHANGE_BASE_QUOTE_TYPE),'-') -- 找零基础报价方式代码
    ,nvl(trim(P1.CHANGE_QUOTE_TYPE),'-') -- 找零报价方式代码
    ,nvl(trim(P1.CHANGE_RATE_TYPE),'-') -- 找零利率类型代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRACE_REF_NO -- 跟踪参考号
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 渠道编号
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,P1.REMARK -- 交易描述
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.TERMINAL_ID -- 交易终端编号
    ,P1.APPROVAL_DATE -- 复核日期
    ,P1.VALUE_DATE -- 记账日期
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.APPR_AUTH_USER_ID -- 复核授权柜员编号
    ,P1.AUTH_USER_ID -- 交易授权柜员编号
    ,P1.REVERSAL_AUTH_USER_ID -- 冲正授权柜员编号
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,P1.USER_ID -- 核心交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(P1.UNC_STATUS),'-') -- 平盘状态代码
    ,P1.FCY_CTRL_IBUNC_AMT -- 外币总行系统内平补金额
    ,P1.IBUNC_REFERENCE -- 系统内平盘流水号
    ,P1.OBUNC_REFERENCE -- 交易市场平盘流水号
    ,DECODE(P1.MIN_AMT_FLAG,'Y','1','N','0','-') -- 是否尾零处理标志
    ,P1.FLOAT_POINT -- 浮动点差
    ,P1.EFFECT_TIME -- 汇率牌价生效时间
    ,P1.EFFECT_DATE -- 汇率牌价生效日期
    ,P1.SELL_UNC_RATE -- 卖出平盘汇率
    ,P1.BUY_UNC_RATE -- 买入平盘汇率
    ,nvl(trim(P1.COUPON_RATE_TYPE),'-') -- 结售汇业务类型代码
    ,decode(P1.OVERSEA_TALENT_PROOF,'Y','1','N','0', ' ','-',P1.OVERSEA_TALENT_PROOF) -- 海外人才证明标志
    ,P1.OVERSEA_TALENT_PROOF_TYPE -- 海外人才证明描述
    ,P1.OVERSEA_TALENT_REMARK -- 海外人才备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_exchange_tran_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ncbs_rb_exchange_tran_hist p1
  left join (select distinct base_acct_no, card_no
               from ${iol_schema}.ncbs_new_old_seq_no) p8
    on p1.deposit_base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
  left join (select distinct base_acct_no, card_no
               from ${iol_schema}.ncbs_new_old_seq_no) p9
    on p1.withdraw_base_acct_no = p9.base_acct_no
   and p9.base_acct_no like '0%'
 where 1 = 1
   and p1.tran_date = to_date('${batch_date}', 'YYYYMMDD')
   ;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wrt_guat_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wrt_guat_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_wrt_guat_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wrt_guat_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wrt_guat_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wrt_guat_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);