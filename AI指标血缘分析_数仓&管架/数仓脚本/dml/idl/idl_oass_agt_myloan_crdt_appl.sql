/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_myloan_crdt_appl
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_myloan_crdt_appl drop partition p_${last_date};
alter table ${idl_schema}.oass_agt_myloan_crdt_appl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_myloan_crdt_appl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_myloan_crdt_appl (
etl_dt  --ETL处理日期
,crdt_appl_id  --授信申请编号
,appl_flow_num  --申请流水号
,prod_id  --产品编号
,appl_dt  --申请日期
,cust_name  --客户名称
,cust_id  --客户编号
,crdt_lmt  --授信额度
,apv_start_tm  --审批开始时间
,apv_end_tm  --审批结束时间
,apv_status_cd  --审批状态代码
,final_jud_advise_sucs_flg  --终审通知成功标志
,final_jud_advise_tm  --终审通知时间
,cust_mgr_id  --客户经理编号
,rgst_org_id  --登记机构编号
,farm_flg  --农户标志
,refuse_rs  --拒绝原因
,mobile_no  --手机号码
,crdt_sugst_lmt  --授信建议额度
,netw_vrfction_status_cd  --联网核查状态代码
,prod_name  --产品名称
,apv_rest_cd  --审批结果代码
,bus_scene_cd  --业务场景代码
,lmt_status_cd  --额度状态代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,bank_supv_custs_mang_lab  --银监客群经营标签
,pbc_custs_mang_lab  --人行客群经营标签
,appl_id  --申请编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id --授信申请编号
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num --申请流水号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,t1.appl_dt as appl_dt --申请日期
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.crdt_lmt as crdt_lmt --授信额度
,t1.apv_start_tm as apv_start_tm --审批开始时间
,t1.apv_end_tm as apv_end_tm --审批结束时间
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.final_jud_advise_sucs_flg,chr(13),''),chr(10),'') as final_jud_advise_sucs_flg --终审通知成功标志
,t1.final_jud_advise_tm as final_jud_advise_tm --终审通知时间
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg --农户标志
,replace(replace(t1.refuse_rs,chr(13),''),chr(10),'') as refuse_rs --拒绝原因
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no --手机号码
,t1.crdt_sugst_lmt as crdt_sugst_lmt --授信建议额度
,replace(replace(t1.netw_vrfction_status_cd,chr(13),''),chr(10),'') as netw_vrfction_status_cd --联网核查状态代码
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name --产品名称
,replace(replace(t1.apv_rest_cd,chr(13),''),chr(10),'') as apv_rest_cd --审批结果代码
,replace(replace(t1.bus_scene_cd,chr(13),''),chr(10),'') as bus_scene_cd --业务场景代码
,replace(replace(t1.lmt_status_cd,chr(13),''),chr(10),'') as lmt_status_cd --额度状态代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.bank_supv_custs_mang_lab,chr(13),''),chr(10),'') as bank_supv_custs_mang_lab --银监客群经营标签
,replace(replace(t1.pbc_custs_mang_lab,chr(13),''),chr(10),'') as pbc_custs_mang_lab --人行客群经营标签
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id --申请编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_myloan_crdt_appl t1    --网商贷授信申请
where etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_myloan_crdt_appl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
