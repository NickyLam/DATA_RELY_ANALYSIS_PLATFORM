/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_post
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
alter table ${idl_schema}.oass_uuss_uus_post drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_post add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_post (
etl_dt  --数据日期
,postname  --岗位名称
,isbasepost  --基准岗位标识
,linecode  --条线编码
,serialcode  --序列编码
,type  --类型
,enablestate  --启用状态
,placecode  --职务编码
,currdate  --创建日期
,currtime  --创建时间
,updatedate  --更新日期
,updatetime  --更新时间
,createuser  --创建人
,updateuser  --最后修改人
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,postcode  --岗位编号
,organcode  --机构编码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.postname,chr(13),''),chr(10),'') as postname --岗位名称
,replace(replace(t1.isbasepost,chr(13),''),chr(10),'') as isbasepost --基准岗位标识
,replace(replace(t1.linecode,chr(13),''),chr(10),'') as linecode --条线编码
,replace(replace(t1.serialcode,chr(13),''),chr(10),'') as serialcode --序列编码
,replace(replace(t1.type,chr(13),''),chr(10),'') as type --类型
,replace(replace(t1.enablestate,chr(13),''),chr(10),'') as enablestate --启用状态
,replace(replace(t1.placecode,chr(13),''),chr(10),'') as placecode --职务编码
,replace(replace(t1.currdate,chr(13),''),chr(10),'') as currdate --创建日期
,replace(replace(t1.currtime,chr(13),''),chr(10),'') as currtime --创建时间
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate --更新日期
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime --更新时间
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser --创建人
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser --最后修改人
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode --岗位编号
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode --机构编码
from ${iol_schema}.uuss_uus_post t1    --岗位表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_post',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
