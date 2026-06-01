/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_evt_wld_bank_coll_comm_flow
CreateDate: 20230608
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_evt_wld_bank_coll_comm_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_evt_wld_bank_coll_comm_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_evt_wld_bank_coll_comm_flow (
etl_dt  --etl处理日期
,evt_id  --事件编号
,lp_id  --法人编号
,ser_num  --序列号
,comm_dt  --佣金日期
,logic_card_no  --逻辑卡号
,dubil_id  --借据编号
,ovdue_days  --逾期天数
,repay_dt  --还款日期
,repay_amt  --还款金额
,syn_id  --银团编号
,bank_id  --银行编号
,bank_contri_ratio  --银行出资比例
,outsourc_fee_rat  --委外费率
,outsourc_fee  --委外费用

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num --序列号
,t1.comm_dt as comm_dt --佣金日期
,replace(replace(t1.logic_card_no,chr(13),''),chr(10),'') as logic_card_no --逻辑卡号
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,t1.ovdue_days as ovdue_days --逾期天数
,t1.repay_dt as repay_dt --还款日期
,t1.repay_amt as repay_amt --还款金额
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id --银团编号
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id --银行编号
,t1.bank_contri_ratio as bank_contri_ratio --银行出资比例
,t1.outsourc_fee_rat as outsourc_fee_rat --委外费率
,t1.outsourc_fee as outsourc_fee --委外费用
from ${iml_schema}.evt_wld_bank_coll_comm_flow t1    --微粒贷银行催收佣金流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_evt_wld_bank_coll_comm_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
