/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_int_rat_h
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
alter table ${idl_schema}.oass_agt_int_rat_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_int_rat_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_int_rat_h (
etl_dt  --数据日期
,int_rat_type_cd  --利率类型代码
,int_rat_id  --利率编号
,base_int_rat  --基准利率
,exec_int_rat  --执行利率
,int_rat_float_way_cd  --利率浮动方式代码
,int_rat_float_point  --利率浮动点数
,int_rat_fl_rt  --利率浮动比例
,int_rat_period_cd  --利率周期代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd --利率类型代码
,replace(replace(t1.int_rat_id,chr(13),''),chr(10),'') as int_rat_id --利率编号
,t1.base_int_rat as base_int_rat --基准利率
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd --利率浮动方式代码
,t1.int_rat_float_point as int_rat_float_point --利率浮动点数
,t1.int_rat_fl_rt as int_rat_fl_rt --利率浮动比例
,replace(replace(t1.int_rat_period_cd,chr(13),''),chr(10),'') as int_rat_period_cd --利率周期代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_int_rat_h t1    --协议利率历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_int_rat_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
