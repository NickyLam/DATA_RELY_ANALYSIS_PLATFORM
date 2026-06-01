/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_recvbl_fee_dtl_ncbsi1
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
drop table ${iml_schema}.evt_dep_recvbl_fee_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_recvbl_fee_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_recvbl_fee_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_recvbl_fee_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,recvbl_fee_seq_num -- 应收费用序号
    ,lp_id -- 法人编号
    ,bus_tran_dt -- 业务交易日期
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,charge_acct_id -- 收费账户编号
    ,charge_acct_prod_id -- 收费账户产品编号
    ,charge_cust_acct_num -- 收费客户账号
    ,charge_acct_curr_cd -- 收费账户币种代码
    ,acct_id -- 账户编号
    ,effect_dt -- 生效日期
    ,last_charge_dt -- 上一收费日期
    ,tran_revs_dt -- 交易冲正日期
    ,revs_org_id -- 冲正机构编号
    ,core_tran_org_id -- 核心交易机构编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_id -- 凭证编号
    ,vouch_sum_qtty -- 凭证合计数量
    ,dep_agt_id -- 存款协议编号
    ,cntpty_bus_id -- 对手业务编号
    ,tran_ref_no -- 交易参考号
    ,discnt_fee_amt -- 折扣费用金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 收费金额
    ,init_fee_amt -- 原始费用金额
    ,next_charge_dt -- 下一收费日期
    ,tax -- 税金
    ,init_recvbl_fee_amt -- 原应收费用金额
    ,fee_price -- 费用单价
    ,charge_freq_cd -- 收费频率代码
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,need_prft_cut_flg -- 需要分润标志
    ,tran_bank_prft_cut_amt -- 交易行分润金额
    ,fee_charge_way_cd -- 费用收费方式代码
    ,grace_flg -- 宽限标志
    ,tran_revd_flg -- 交易已冲正标志
    ,fee_discnt_type_cd -- 费用折扣类型代码
    ,tran_bank_ratio -- 交易行比例
    ,charge_curr_cd -- 收费币种代码
    ,charge_sub_acct_num -- 收费子账号
    ,charge_day -- 收费日
    ,termnt_num -- 终止号码
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,owe_fee_status_cd -- 欠费状态代码
    ,prior_level -- 优先等级
    ,fee_discnt_rat -- 费用折扣率
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_teller_id -- 冲正柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_recvbl_fee_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_osd_serv_charge-1
insert into ${iml_schema}.evt_dep_recvbl_fee_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,recvbl_fee_seq_num -- 应收费用序号
    ,lp_id -- 法人编号
    ,bus_tran_dt -- 业务交易日期
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,charge_acct_id -- 收费账户编号
    ,charge_acct_prod_id -- 收费账户产品编号
    ,charge_cust_acct_num -- 收费客户账号
    ,charge_acct_curr_cd -- 收费账户币种代码
    ,acct_id -- 账户编号
    ,effect_dt -- 生效日期
    ,last_charge_dt -- 上一收费日期
    ,tran_revs_dt -- 交易冲正日期
    ,revs_org_id -- 冲正机构编号
    ,core_tran_org_id -- 核心交易机构编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_id -- 凭证编号
    ,vouch_sum_qtty -- 凭证合计数量
    ,dep_agt_id -- 存款协议编号
    ,cntpty_bus_id -- 对手业务编号
    ,tran_ref_no -- 交易参考号
    ,discnt_fee_amt -- 折扣费用金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 收费金额
    ,init_fee_amt -- 原始费用金额
    ,next_charge_dt -- 下一收费日期
    ,tax -- 税金
    ,init_recvbl_fee_amt -- 原应收费用金额
    ,fee_price -- 费用单价
    ,charge_freq_cd -- 收费频率代码
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,need_prft_cut_flg -- 需要分润标志
    ,tran_bank_prft_cut_amt -- 交易行分润金额
    ,fee_charge_way_cd -- 费用收费方式代码
    ,grace_flg -- 宽限标志
    ,tran_revd_flg -- 交易已冲正标志
    ,fee_discnt_type_cd -- 费用折扣类型代码
    ,tran_bank_ratio -- 交易行比例
    ,charge_curr_cd -- 收费币种代码
    ,charge_sub_acct_num -- 收费子账号
    ,charge_day -- 收费日
    ,termnt_num -- 终止号码
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,owe_fee_status_cd -- 欠费状态代码
    ,prior_level -- 优先等级
    ,fee_discnt_rat -- 费用折扣率
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_teller_id -- 冲正柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101065'||P1.OSD_SEQ_NO -- 事件编号
    ,P1.OSD_SEQ_NO -- 应收费用序号
    ,'9999' -- 法人编号
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.SEQ_NO -- 序号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.CHARGE_TO_INTERNAL_KEY -- 收费账户编号
    ,P1.CHARGE_TO_PROD_TYPE -- 收费账户产品编号
    ,nvl(trim(p9.card_no),p1.CHARGE_TO_BASE_ACCT_NO) -- 收费客户账号
    ,P1.CHARGE_TO_CCY -- 收费账户币种代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.LAST_CHARGE_DATE -- 上一收费日期
    ,P1.REVERSAL_DATE -- 交易冲正日期
    ,P1.REVERSAL_BRANCH -- 冲正机构编号
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.VOUCHER_START_NO -- 凭证编号
    ,P1.VOUCHER_SUM -- 凭证合计数量
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.OTH_BUSINESS_NO -- 对手业务编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.DISC_FEE_AMT -- 折扣费用金额
    ,P1.FEE_TYPE -- 费用类型编号
    ,P1.FEE_AMT -- 收费金额
    ,P1.ORIG_FEE_AMT -- 原始费用金额
    ,P1.NEXT_CHARGE_DATE -- 下一收费日期
    ,P1.TAX_AMT -- 税金
    ,P1.TRAN_FEE_AMT -- 原应收费用金额
    ,P1.UNIT_PRICE -- 费用单价
    ,P1.CHARGE_PERIOD_FREQ -- 收费频率代码
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,DECODE(trim(P1.PROFIT_ALLOT_FLAG),'','-','Y','1','N','0',P1.PROFIT_ALLOT_FLAG)-- 需要分润标志
    ,P1.TRAN_PROFIT_AMT -- 交易行分润金额
    ,P1.CHARGE_WAY -- 费用收费方式代码
    ,DECODE(trim(P1.DELAY_FLAG),'','-','Y','1','N','0',P1.DELAY_FLAG) -- 宽限标志
    ,DECODE(trim(P1.REVERSAL_FLAG),'','-','Y','1','N','0',P1.REVERSAL_FLAG) -- 交易已冲正标志
    ,P1.SC_DISCOUNT_TYPE -- 费用折扣类型代码
    ,P1.TRAN_BRANCH_PERCENT -- 交易行比例
    ,P1.FEE_CCY -- 收费币种代码
    ,P1.CHARGE_TO_ACCT_SEQ_NO -- 收费子账号
    ,P1.CHARGE_DAY -- 收费日
    ,P1.END_NO -- 终止号码
    ,P1.OPEN_BRANCH_PERCENT -- 账户行比例
    ,P1.OPEN_PROFIT_AMT -- 账户行分润金额
    ,P1.OSD_STATUS -- 欠费状态代码
    ,P1.PRIORITY -- 优先等级
    ,P1.SC_DISCOUNT_RATE -- 费用折扣率
    ,P1.REVERSAL_AUTH_USER_ID -- 冲正授权柜员编号
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_osd_serv_charge' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_osd_serv_charge p1
    left join (select DISTINCT BASE_ACCT_NO,CARD_NO from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select DISTINCT BASE_ACCT_NO,CARD_NO from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.CHARGE_TO_BASE_ACCT_NO=p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')    
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_recvbl_fee_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_recvbl_fee_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_recvbl_fee_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_recvbl_fee_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_recvbl_fee_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_recvbl_fee_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);