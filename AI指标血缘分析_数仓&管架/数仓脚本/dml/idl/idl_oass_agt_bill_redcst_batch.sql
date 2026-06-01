/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_redcst_batch
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
alter table ${idl_schema}.oass_agt_bill_redcst_batch drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_redcst_batch add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_redcst_batch (
etl_dt  --ETL处理日期
,cont_id  --合同编号
,prod_id  --产品编号
,std_prod_id  --标准产品编号
,ctr_nt_id  --成交单编号
,quot_bill_id  --报价单编号
,appl_form_modif_rela_id  --申请单修改关联编号
,hq_org_id  --总行机构编号
,org_id  --机构编号
,appl_dt  --申请日期
,bus_type_cd  --业务类型代码
,dealer_id  --交易员编号
,cfm_ps_id  --确认人编号
,pbc_org_cd  --人行机构代码
,pbc_org_acquirer_id  --人行机构受理人编号
,pbc_org_acquirer_name  --人行机构受理人名称
,pbc_org_checker_id  --人行机构复核人编号
,pbc_org_checker_name  --人行机构复核人名称
,pbc_org_apver_id  --人行机构审批人编号
,pbc_org_apver_name  --人行机构审批人名称
,apver_apv_opinion  --审批人审批意见
,bill_type_cd  --票据类型代码
,bill_med_cd  --票据介质代码
,bill_cnt  --票据张数
,bill_tot  --票据总额
,repo_amt  --回购金额
,hold_tenor  --持票期限
,clear_speed_cd  --清算速度代码
,clear_type_cd  --清算类型代码
,stl_way_cd  --结算方式代码
,stl_amt  --转贴现金额
,exp_stl_amt  --到期结算金额
,stl_dt  --结算日期
,exp_stl_dt  --到期结算日期
,int_rat  --利率
,int_paybl  --应付利息
,dept_id  --部门编号
,cust_mgr_id  --客户经理编号
,apv_rest_cd  --审批结果代码
,apv_status_cd  --审批状态代码
,msg_status_cd  --报文状态代码
,clear_status_cd  --清算状态代码
,entry_status_cd  --记账状态代码
,final_modif_tm  --最后修改时间
,creator_id  --创建人编号
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,batch_id  --批次编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id --成交单编号
,replace(replace(t1.quot_bill_id,chr(13),''),chr(10),'') as quot_bill_id --报价单编号
,replace(replace(t1.appl_form_modif_rela_id,chr(13),''),chr(10),'') as appl_form_modif_rela_id --申请单修改关联编号
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id --总行机构编号
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,t1.appl_dt as appl_dt --申请日期
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd --业务类型代码
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id --交易员编号
,replace(replace(t1.cfm_ps_id,chr(13),''),chr(10),'') as cfm_ps_id --确认人编号
,replace(replace(t1.pbc_org_cd,chr(13),''),chr(10),'') as pbc_org_cd --人行机构代码
,replace(replace(t1.pbc_org_acquirer_id,chr(13),''),chr(10),'') as pbc_org_acquirer_id --人行机构受理人编号
,replace(replace(t1.pbc_org_acquirer_name,chr(13),''),chr(10),'') as pbc_org_acquirer_name --人行机构受理人名称
,replace(replace(t1.pbc_org_checker_id,chr(13),''),chr(10),'') as pbc_org_checker_id --人行机构复核人编号
,replace(replace(t1.pbc_org_checker_name,chr(13),''),chr(10),'') as pbc_org_checker_name --人行机构复核人名称
,replace(replace(t1.pbc_org_apver_id,chr(13),''),chr(10),'') as pbc_org_apver_id --人行机构审批人编号
,replace(replace(t1.pbc_org_apver_name,chr(13),''),chr(10),'') as pbc_org_apver_name --人行机构审批人名称
,replace(replace(t1.apver_apv_opinion,chr(13),''),chr(10),'') as apver_apv_opinion --审批人审批意见
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd --票据类型代码
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd --票据介质代码
,t1.bill_cnt as bill_cnt --票据张数
,t1.bill_tot as bill_tot --票据总额
,t1.repo_amt as repo_amt --回购金额
,t1.hold_tenor as hold_tenor --持票期限
,replace(replace(t1.clear_speed_cd,chr(13),''),chr(10),'') as clear_speed_cd --清算速度代码
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd --清算类型代码
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd --结算方式代码
,t1.stl_amt as stl_amt --转贴现金额
,t1.exp_stl_amt as exp_stl_amt --到期结算金额
,t1.stl_dt as stl_dt --结算日期
,t1.exp_stl_dt as exp_stl_dt --到期结算日期
,t1.int_rat as int_rat --利率
,t1.int_paybl as int_paybl --应付利息
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id --部门编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.apv_rest_cd,chr(13),''),chr(10),'') as apv_rest_cd --审批结果代码
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.msg_status_cd,chr(13),''),chr(10),'') as msg_status_cd --报文状态代码
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd --清算状态代码
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd --记账状态代码
,t1.final_modif_tm as final_modif_tm --最后修改时间
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id --创建人编号
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_bill_redcst_batch t1    --票据再贴现批次
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_redcst_batch',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
