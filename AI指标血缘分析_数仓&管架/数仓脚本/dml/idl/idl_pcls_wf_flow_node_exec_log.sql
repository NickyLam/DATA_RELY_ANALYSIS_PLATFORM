/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pcls_wf_flow_node_exec_log
CreateDate: 20250516
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.pcls_wf_flow_node_exec_log drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pcls_wf_flow_node_exec_log add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pcls_wf_flow_node_exec_log (
etl_dt  --数据日期
,id  --主键
,log_no  --执行记录编码
,flow_no  --工作流流程号
,node_no  --节点编码
,biz_no  --主申请编号
,sub_biz_no  --子申请编号
,org_no  --所属机构编号
,sub_org_no  --子机构编码
,channel_no  --所属渠道
,product_code  --所属产品
,biz_type  --流程类型appl/draw/cas/xx待定
,sub_biz_type  --子流程类型
,instance_no  --工作流实例编号
,exec_status  --waitting：等待执行，running：执行中,finish:执行结束,fail:失败,hang_up：挂起,block：异常挂起
,exec_fail_num  --异常次数
,params  --上下文变量
,date_begin  --开始时间
,date_end  --结束时间
,date_created  --创建时间
,created_by  --创建人
,date_updated  --修改时间
,updated_by  --修改人

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.id as id --主键
,replace(replace(t1.log_no,chr(13),''),chr(10),'') as log_no --执行记录编码
,replace(replace(t1.flow_no,chr(13),''),chr(10),'') as flow_no --工作流流程号
,replace(replace(t1.node_no,chr(13),''),chr(10),'') as node_no --节点编码
,replace(replace(t1.biz_no,chr(13),''),chr(10),'') as biz_no --主申请编号
,replace(replace(t1.sub_biz_no,chr(13),''),chr(10),'') as sub_biz_no --子申请编号
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no --所属机构编号
,replace(replace(t1.sub_org_no,chr(13),''),chr(10),'') as sub_org_no --子机构编码
,replace(replace(t1.channel_no,chr(13),''),chr(10),'') as channel_no --所属渠道
,replace(replace(t1.product_code,chr(13),''),chr(10),'') as product_code --所属产品
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type --流程类型appl/draw/cas/xx待定
,replace(replace(t1.sub_biz_type,chr(13),''),chr(10),'') as sub_biz_type --子流程类型
,replace(replace(t1.instance_no,chr(13),''),chr(10),'') as instance_no --工作流实例编号
,replace(replace(t1.exec_status,chr(13),''),chr(10),'') as exec_status --waitting：等待执行，running：执行中,finish:执行结束,fail:失败,hang_up：挂起,block：异常挂起
,t1.exec_fail_num as exec_fail_num --异常次数
,replace(replace(t1.params,chr(13),''),chr(10),'') as params --上下文变量
,t1.date_begin as date_begin --开始时间
,t1.date_end as date_end --结束时间
,t1.date_created as date_created --创建时间
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by --创建人
,t1.date_updated as date_updated --修改时间
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by --修改人
from ${iol_schema}.pcls_wf_flow_node_exec_log t1    --工作流执行节点表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pcls_wf_flow_node_exec_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
