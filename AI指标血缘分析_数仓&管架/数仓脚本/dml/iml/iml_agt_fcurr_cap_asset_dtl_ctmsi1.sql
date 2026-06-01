/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fcurr_cap_asset_dtl_ctmsi1
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
drop table ${iml_schema}.agt_fcurr_cap_asset_dtl_ctmsi1_tm purge;
alter table ${iml_schema}.agt_fcurr_cap_asset_dtl add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_fcurr_cap_asset_dtl modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fcurr_cap_asset_dtl_ctmsi1_tm
compress ${option_switch} for query high
as
select
    bal_dtl_id -- 余额明细编号
    ,lp_id -- 法人编号
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,entry_def_id -- 分录定义编号
    ,asset_cate_name -- 资产类别名称
    ,bus_cate_name -- 业务类别名称
    ,main_asset_id -- 主资产编号
    ,minor_asset_id -- 次资产编号
    ,bus_dt -- 业务日期
    ,hold_pos -- 持有仓位
    ,hold_denom -- 持有面额
    ,net_price_cost -- 净价成本
    ,int_adj -- 利息调整
    ,evha_val_chag -- 公允价值变动
    ,int_cost -- 利息成本
    ,full_price_cost -- 全价成本
    ,impam_prep -- 减值准备
    ,spd_prft -- 价差收益
    ,amort_prft -- 摊销收益
    ,int_prft -- 利息收益
    ,evha_val_chag_pl -- 公允价值变动损益
    ,impam_loss -- 减值损失
    ,tran_fee -- 交易费用
    ,actl_int_rat -- 实际利率
    ,comm_fee_inco -- 手续费收入
    ,comm_fee_expns -- 手续费支出
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,happ_amt -- 发生金额
    ,amort_adj_fact -- 摊销调整因子
    ,last_bal_dtl_id -- 上次余额明细编号
    ,offset_bal_dtl_id -- 冲回余额明细编号
    ,strk_bal_flg -- 冲账标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fcurr_cap_asset_dtl
where 0=1;

-- 3.1 truncate target table batch_date partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fcurr_cap_asset_dtl truncate subpartition p_ctmsi1_${batch_date} reuse storage;

-- 3.2 insert data to tm table
-- ctms_fbs_v_alterbalance-
insert into ${iml_schema}.agt_fcurr_cap_asset_dtl_ctmsi1_tm(
    bal_dtl_id -- 余额明细编号
    ,lp_id -- 法人编号
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,entry_def_id -- 分录定义编号
    ,asset_cate_name -- 资产类别名称
    ,bus_cate_name -- 业务类别名称
    ,main_asset_id -- 主资产编号
    ,minor_asset_id -- 次资产编号
    ,bus_dt -- 业务日期
    ,hold_pos -- 持有仓位
    ,hold_denom -- 持有面额
    ,net_price_cost -- 净价成本
    ,int_adj -- 利息调整
    ,evha_val_chag -- 公允价值变动
    ,int_cost -- 利息成本
    ,full_price_cost -- 全价成本
    ,impam_prep -- 减值准备
    ,spd_prft -- 价差收益
    ,amort_prft -- 摊销收益
    ,int_prft -- 利息收益
    ,evha_val_chag_pl -- 公允价值变动损益
    ,impam_loss -- 减值损失
    ,tran_fee -- 交易费用
    ,actl_int_rat -- 实际利率
    ,comm_fee_inco -- 手续费收入
    ,comm_fee_expns -- 手续费支出
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,happ_amt -- 发生金额
    ,amort_adj_fact -- 摊销调整因子
    ,last_bal_dtl_id -- 上次余额明细编号
    ,offset_bal_dtl_id -- 冲回余额明细编号
    ,strk_bal_flg -- 冲账标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ALTERBALANCE_ID -- 余额明细编号
    ,'9999' -- 法人编号
    ,P1.ASPCLIENT_ID -- 部门编号
    ,P1.KEEPFOLDER_ID -- 账簿编号
    ,P1.ACCCODE -- 分录定义编号
    ,P1.ASSETTYPE -- 资产类别名称
    ,P1.BUZTYPE -- 业务类别名称
    ,P1.MAJORASSETCODE -- 主资产编号
    ,P1.MINORASSETCODE -- 次资产编号
    ,${iml_schema}.dateformat_min(TO_CHAR(P1.SETTLEDATE)) -- 业务日期
    ,P1.HOLDPOSITION -- 持有仓位
    ,P1.HOLDFACEAMOUNT -- 持有面额
    ,P1.CLEANPRICECOST -- 净价成本
    ,P1.INTERESTADJUST -- 利息调整
    ,P1.FAIRVALUEALTER -- 公允价值变动
    ,P1.INTERESTCOST -- 利息成本
    ,P1.DIRTYPRICECOST -- 全价成本
    ,P1.IMPAIRMENT -- 减值准备
    ,P1.PRICEEARNING -- 价差收益
    ,P1.AMORTIZEEARNING -- 摊销收益
    ,P1.INTERESTEARNING -- 利息收益
    ,P1.FAIRVALUEINCOME -- 公允价值变动损益
    ,P1.IMPAIRMENTLOST -- 减值损失
    ,P1.TRADEEXPENSE -- 交易费用
    ,P1.REALRATE -- 实际利率
    ,P1.CHARGEINCOME -- 手续费收入
    ,P1.CHARGEEXPENSE -- 手续费支出
    ,${iml_schema}.dateformat_min(TO_CHAR(P1.VALUEDATE)) -- 起息日期
    ,${iml_schema}.dateformat_max(TO_CHAR(P1.MATURITYDATE)) -- 到期日期
    ,P1.OCCURAMOUNT -- 发生金额
    ,P1.AMORTIZATIONFACTOR -- 摊销调整因子
    ,P1.ALTERBALANCE_ID_PREV -- 上次余额明细编号
    ,P1.ALTERBALANCE_ID_REV -- 冲回余额明细编号
    ,P1.REV_FLAG -- 冲账标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_alterbalance' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_alterbalance p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.SETTLEDATE='${batch_date}'
;
commit;



-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_fcurr_cap_asset_dtl exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.agt_fcurr_cap_asset_dtl_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fcurr_cap_asset_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_fcurr_cap_asset_dtl_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fcurr_cap_asset_dtl', partname => 'p_ctmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);