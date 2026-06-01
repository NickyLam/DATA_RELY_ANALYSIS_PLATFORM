/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_evt_wld_syn_adj_flow
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
alter table ${idl_schema}.crps_evt_wld_syn_adj_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_evt_wld_syn_adj_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_evt_wld_syn_adj_flow (
etl_dt  --etl处理日期
,evt_id  --事件编号
,lp_id  --法人编号
,batch_doc_name  --批量文件名称
,seq_num  --序号
,bus_flow_num  --业务流水号
,syn_id  --银团编号
,bank_id  --银行编号
,tran_type_cd  --交易类型代码
,logic_card_no  --逻辑卡号
,exc_resv_clear_amt  --备付金清算金额
,cnc_entry_amt  --cnc记账金额
,should_adj_bal  --应调整差额
,batch_dt  --批量日期
,excep_type_cd  --异常类型代码
,cust_name  --客户名称

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name --批量文件名称
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num --序号
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num --业务流水号
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id --银团编号
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id --银行编号
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd --交易类型代码
,replace(replace(t1.logic_card_no,chr(13),''),chr(10),'') as logic_card_no --逻辑卡号
,t1.exc_resv_clear_amt as exc_resv_clear_amt --备付金清算金额
,t1.cnc_entry_amt as cnc_entry_amt --cnc记账金额
,t1.should_adj_bal as should_adj_bal --应调整差额
,t1.batch_dt as batch_dt --批量日期
,replace(replace(t1.excep_type_cd,chr(13),''),chr(10),'') as excep_type_cd --异常类型代码
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
from ${iml_schema}.evt_wld_syn_adj_flow t1    --微粒贷银团尾差调整流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_evt_wld_syn_adj_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
