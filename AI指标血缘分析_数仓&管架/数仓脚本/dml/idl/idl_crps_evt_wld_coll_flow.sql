/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_evt_wld_coll_flow
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
alter table ${idl_schema}.crps_evt_wld_coll_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_evt_wld_coll_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_evt_wld_coll_flow (
etl_dt  --etl处理日期
,evt_id  --事件编号
,lp_id  --法人编号
,batch_doc_name  --批量文件名称
,seq_num  --序号
,coll_flow_num  --催收流水号
,case_id  --案件编号
,cust_id  --客户编号
,way_cd  --催记方式代码
,coll_act_type_cd  --催收动作类型代码
,coll_dt  --催收日期
,coll_rest_type_cd  --催收结果类型代码
,promis_repay_amt  --承诺偿还金额
,promis_repay_dt  --承诺偿还日期
,remark  --备注
,org_id  --机构编号
,create_tm  --创建时间
,final_modif_tm  --最后修改时间

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name --批量文件名称
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num --序号
,replace(replace(t1.coll_flow_num,chr(13),''),chr(10),'') as coll_flow_num --催收流水号
,replace(replace(t1.case_id,chr(13),''),chr(10),'') as case_id --案件编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.way_cd,chr(13),''),chr(10),'') as way_cd --催记方式代码
,replace(replace(t1.coll_act_type_cd,chr(13),''),chr(10),'') as coll_act_type_cd --催收动作类型代码
,t1.coll_dt as coll_dt --催收日期
,replace(replace(t1.coll_rest_type_cd,chr(13),''),chr(10),'') as coll_rest_type_cd --催收结果类型代码
,t1.promis_repay_amt as promis_repay_amt --承诺偿还金额
,t1.promis_repay_dt as promis_repay_dt --承诺偿还日期
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,t1.create_tm as create_tm --创建时间
,t1.final_modif_tm as final_modif_tm --最后修改时间
from ${iml_schema}.evt_wld_coll_flow t1    --微粒贷催收流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_evt_wld_coll_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
