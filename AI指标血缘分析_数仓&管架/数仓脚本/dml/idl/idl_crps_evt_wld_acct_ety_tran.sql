/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_evt_wld_acct_ety_tran
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
alter table ${idl_schema}.crps_evt_wld_acct_ety_tran drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_evt_wld_acct_ety_tran add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_evt_wld_acct_ety_tran (
etl_dt  --etl处理日期
,evt_id  --事件编号
,lp_id  --法人编号
,ser_num  --序列号
,batch_doc_name  --批量文件名称
,batch_dt  --批量日期
,grouping_seq_num  --分组序号
,evt_tran_code  --事件交易码
,core_tran_flow  --核心交易流水
,tran_descb  --交易描述
,perds  --期数
,card_no  --卡号
,curr_cd  --币种代码
,enter_acct_amt  --入账金额
,debit_crdt_flg  --借贷标志
,enter_acct_way_cd  --入账方式代码
,subrch_id  --支行编号
,subj_id  --科目编号
,loan_prod_id  --贷款产品编号
,crdt_plan_id  --信用计划编号
,syn_id  --银团编号
,bank_id  --银行编号
,rb_w_flg  --红蓝字标志
,tran_ref_no  --交易参考号
,aging_group_cd  --账龄组代码
,bal_compnt_group_cd  --余额成分组代码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num --序列号
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name --批量文件名称
,t1.batch_dt as batch_dt --批量日期
,replace(replace(t1.grouping_seq_num,chr(13),''),chr(10),'') as grouping_seq_num --分组序号
,replace(replace(t1.evt_tran_code,chr(13),''),chr(10),'') as evt_tran_code --事件交易码
,replace(replace(t1.core_tran_flow,chr(13),''),chr(10),'') as core_tran_flow --核心交易流水
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb --交易描述
,t1.perds as perds --期数
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no --卡号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.enter_acct_amt as enter_acct_amt --入账金额
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg --借贷标志
,replace(replace(t1.enter_acct_way_cd,chr(13),''),chr(10),'') as enter_acct_way_cd --入账方式代码
,replace(replace(t1.subrch_id,chr(13),''),chr(10),'') as subrch_id --支行编号
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'') as loan_prod_id --贷款产品编号
,replace(replace(t1.crdt_plan_id,chr(13),''),chr(10),'') as crdt_plan_id --信用计划编号
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id --银团编号
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id --银行编号
,replace(replace(t1.rb_w_flg,chr(13),''),chr(10),'') as rb_w_flg --红蓝字标志
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.aging_group_cd,chr(13),''),chr(10),'') as aging_group_cd --账龄组代码
,replace(replace(t1.bal_compnt_group_cd,chr(13),''),chr(10),'') as bal_compnt_group_cd --余额成分组代码
from ${iml_schema}.evt_wld_acct_ety_tran t1    --微粒贷会计分录交易事件
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_evt_wld_acct_ety_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
