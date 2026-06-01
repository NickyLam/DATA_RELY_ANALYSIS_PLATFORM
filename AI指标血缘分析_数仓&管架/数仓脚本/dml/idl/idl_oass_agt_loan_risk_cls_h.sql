/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_risk_cls_h
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
alter table ${idl_schema}.oass_agt_loan_risk_cls_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_risk_cls_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_risk_cls_h (
etl_dt  --数据日期
,agt_id  --协议编号
,obj_id  --对象编号
,obj_type_name  --对象类型名称
,cust_id  --客户编号
,cust_name  --客户名称
,prod_id  --产品编号
,curr_cd  --币种代码
,loan_amt  --贷款金额
,loan_bal  --贷款余额
,loan_tenor_cd  --贷款期限代码
,cls_closing_dt  --分类截止日期
,sys_cls_rest_cd  --系统分类结果代码
,manu_cls_rest_cd  --人工分类结果代码
,manu_cls_reason_descb  --人工分类理由描述
,final_rest_cd  --最终结果代码
,cls_way_cd  --分类方式代码
,belong_strip_line_cd  --所属条线代码
,cls_status_cd  --分类状态代码
,low_risk_flg  --低风险标志
,curr_mon_happ_flg  --当月发生标志
,remark  --备注
,oper_teller_id  --业务经办人编号
,oper_org_id  --经办机构编号
,oper_dt  --经办日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,cmplt_dt  --完成日期
,lp_id  --法人编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,risk_cls_id  --风险分类编号
,rela_flow_num  --关联流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id --对象编号
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name --对象类型名称
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.loan_amt as loan_amt --贷款金额
,t1.loan_bal as loan_bal --贷款余额
,replace(replace(t1.loan_tenor_cd,chr(13),''),chr(10),'') as loan_tenor_cd --贷款期限代码
,t1.cls_closing_dt as cls_closing_dt --分类截止日期
,replace(replace(t1.sys_cls_rest_cd,chr(13),''),chr(10),'') as sys_cls_rest_cd --系统分类结果代码
,replace(replace(t1.manu_cls_rest_cd,chr(13),''),chr(10),'') as manu_cls_rest_cd --人工分类结果代码
,replace(replace(t1.manu_cls_reason_descb,chr(13),''),chr(10),'') as manu_cls_reason_descb --人工分类理由描述
,replace(replace(t1.final_rest_cd,chr(13),''),chr(10),'') as final_rest_cd --最终结果代码
,replace(replace(t1.cls_way_cd,chr(13),''),chr(10),'') as cls_way_cd --分类方式代码
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,replace(replace(t1.cls_status_cd,chr(13),''),chr(10),'') as cls_status_cd --分类状态代码
,replace(replace(t1.low_risk_flg,chr(13),''),chr(10),'') as low_risk_flg --低风险标志
,replace(replace(t1.curr_mon_happ_flg,chr(13),''),chr(10),'') as curr_mon_happ_flg --当月发生标志
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id --业务经办人编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,t1.cmplt_dt as cmplt_dt --完成日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.risk_cls_id,chr(13),''),chr(10),'') as risk_cls_id --风险分类编号
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num --关联流水号
from ${iml_schema}.agt_loan_risk_cls_h t1    --公司贷款风险分类历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_risk_cls_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
