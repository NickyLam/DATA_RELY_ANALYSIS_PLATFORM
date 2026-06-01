/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_evt_myloan_tran_repay_plan
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
alter table ${idl_schema}.crps_evt_myloan_tran_repay_plan drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_evt_myloan_tran_repay_plan add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_evt_myloan_tran_repay_plan (
etl_dt  --etl处理日期
,evt_id  --事件编号
,lp_id  --法人编号
,cont_id  --合同编号
,pd_num  --期次号
,asset_tran_bus_dt  --资产转让业务日期
,asset_tran_tran_tm  --资产转让交易时间
,asset_tran_bus_flow_num  --资产转让业务流水号
,cap_flow_num  --资金流水号
,inst_start_dt  --分期开始日期
,inst_end_dt  --分期结束日期
,pric_bal  --本金余额
,int_bal  --利息余额
,ovdue_pric_pnlt_bal  --逾期本金罚息余额
,ovdue_int_pnlt_bal  --逾期利息罚息余额
,tran_type_cd  --转让类型代码
,tran_way_cd  --转让方式代码
,tran_amt  --转让金额
,asset_bal_diff_amt  --作价资产余额和转让金额差价
,inst_status_cd  --分期状态代码
,acru_non_idf_cd  --应计非应计标识代码
,wrt_off_flg  --核销标志
,asset_tran_cntpty_org_id  --资产转让交易对手机构编号
,dist_cd  --行政区划代码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.pd_num,chr(13),''),chr(10),'') as pd_num --期次号
,t1.asset_tran_bus_dt as asset_tran_bus_dt --资产转让业务日期
,t1.asset_tran_tran_tm as asset_tran_tran_tm --资产转让交易时间
,replace(replace(t1.asset_tran_bus_flow_num,chr(13),''),chr(10),'') as asset_tran_bus_flow_num --资产转让业务流水号
,replace(replace(t1.cap_flow_num,chr(13),''),chr(10),'') as cap_flow_num --资金流水号
,t1.inst_start_dt as inst_start_dt --分期开始日期
,t1.inst_end_dt as inst_end_dt --分期结束日期
,t1.pric_bal as pric_bal --本金余额
,t1.int_bal as int_bal --利息余额
,t1.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal --逾期本金罚息余额
,t1.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal --逾期利息罚息余额
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd --转让类型代码
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd --转让方式代码
,t1.tran_amt as tran_amt --转让金额
,t1.asset_bal_diff_amt as asset_bal_diff_amt --作价资产余额和转让金额差价
,replace(replace(t1.inst_status_cd,chr(13),''),chr(10),'') as inst_status_cd --分期状态代码
,replace(replace(t1.acru_non_idf_cd,chr(13),''),chr(10),'') as acru_non_idf_cd --应计非应计标识代码
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg --核销标志
,replace(replace(t1.asset_tran_cntpty_org_id,chr(13),''),chr(10),'') as asset_tran_cntpty_org_id --资产转让交易对手机构编号
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
from ${iml_schema}.evt_myloan_tran_repay_plan t1    --网商贷资产转入还款计划
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_evt_myloan_tran_repay_plan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
