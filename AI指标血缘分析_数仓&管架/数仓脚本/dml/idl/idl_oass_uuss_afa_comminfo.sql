/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_afa_comminfo
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
alter table ${idl_schema}.oass_uuss_afa_comminfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_afa_comminfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_afa_comminfo (
etl_dt  --数据日期
,itemname  --通讯配置项名称
,serverip  --服务器IP
,serverport  --服务器端口
,conntimeout  --连接超时
,transtimeout  --传输超时
,encoding  --编码
,remark  --备注
,status  --配置状态 0:正常 1:失效
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,sendersysid  --发起方系统标识
,recversysid  --接收方系统标识

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.itemname,chr(13),''),chr(10),'') as itemname --通讯配置项名称
,replace(replace(t1.serverip,chr(13),''),chr(10),'') as serverip --服务器IP
,replace(replace(t1.serverport,chr(13),''),chr(10),'') as serverport --服务器端口
,replace(replace(t1.conntimeout,chr(13),''),chr(10),'') as conntimeout --连接超时
,replace(replace(t1.transtimeout,chr(13),''),chr(10),'') as transtimeout --传输超时
,replace(replace(t1.encoding,chr(13),''),chr(10),'') as encoding --编码
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --配置状态 0:正常 1:失效
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.sendersysid,chr(13),''),chr(10),'') as sendersysid --发起方系统标识
,replace(replace(t1.recversysid,chr(13),''),chr(10),'') as recversysid --接收方系统标识
from ${iol_schema}.uuss_afa_comminfo t1    --通讯信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_afa_comminfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
