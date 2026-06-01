/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_flow_object
CreateDate: 20250509
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_flow_object drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_flow_object add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_flow_object (
etl_dt  --数据日期
,objecttype  --流程对象任务类型
,objectno  --流程对象编号
,userid  --登记人编号
,relativetaskno  --关联流程对象流水号
,flowname  --流程模型名称
,orgname  --评估单位
,processinstno  --流程实例编号
,phasename  --当前阶段名称
,objattribute2  --流程属性2
,applyno  --申请编号
,baseflowno  --流程号
,flowno  --流程模型编号
,objattribute5  --流程属性5
,archivetime  --归档时刻
,objattribute4  --流程属性4
,username  --登记人名称
,orgid  --登记机构号
,objattribute1  --流程属性1
,objattribute3  --流程属性3
,flowstate  --流程状态
,processtaskno  --流程任务编号
,serialno  --流程对象流水号
,phaseno  --当前阶段编号
,objdescribe  --流程描述
,applytype  --申请类型
,tasktype  --任务类型
,migtflag  --迁移标志：crs rcr ilc upl
,phasetype  --当前阶段类型
,archive  --归档标识
,version  --版本
,inputdate  --登记日期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype --流程对象任务类型
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno --流程对象编号
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid --登记人编号
,replace(replace(t1.relativetaskno,chr(13),''),chr(10),'') as relativetaskno --关联流程对象流水号
,replace(replace(t1.flowname,chr(13),''),chr(10),'') as flowname --流程模型名称
,replace(replace(t1.orgname,chr(13),''),chr(10),'') as orgname --评估单位
,replace(replace(t1.processinstno,chr(13),''),chr(10),'') as processinstno --流程实例编号
,replace(replace(t1.phasename,chr(13),''),chr(10),'') as phasename --当前阶段名称
,replace(replace(t1.objattribute2,chr(13),''),chr(10),'') as objattribute2 --流程属性2
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno --申请编号
,replace(replace(t1.baseflowno,chr(13),''),chr(10),'') as baseflowno --流程号
,replace(replace(t1.flowno,chr(13),''),chr(10),'') as flowno --流程模型编号
,replace(replace(t1.objattribute5,chr(13),''),chr(10),'') as objattribute5 --流程属性5
,t1.archivetime as archivetime --归档时刻
,replace(replace(t1.objattribute4,chr(13),''),chr(10),'') as objattribute4 --流程属性4
,replace(replace(t1.username,chr(13),''),chr(10),'') as username --登记人名称
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid --登记机构号
,replace(replace(t1.objattribute1,chr(13),''),chr(10),'') as objattribute1 --流程属性1
,replace(replace(t1.objattribute3,chr(13),''),chr(10),'') as objattribute3 --流程属性3
,replace(replace(t1.flowstate,chr(13),''),chr(10),'') as flowstate --流程状态
,replace(replace(t1.processtaskno,chr(13),''),chr(10),'') as processtaskno --流程任务编号
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流程对象流水号
,replace(replace(t1.phaseno,chr(13),''),chr(10),'') as phaseno --当前阶段编号
,replace(replace(t1.objdescribe,chr(13),''),chr(10),'') as objdescribe --流程描述
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype --申请类型
,replace(replace(t1.tasktype,chr(13),''),chr(10),'') as tasktype --任务类型
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.phasetype,chr(13),''),chr(10),'') as phasetype --当前阶段类型
,replace(replace(t1.archive,chr(13),''),chr(10),'') as archive --归档标识
,replace(replace(t1.version,chr(13),''),chr(10),'') as version --版本
,t1.inputdate as inputdate --登记日期
from ${iol_schema}.icms_flow_object t1    --流程对象表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_flow_object',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
