/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ref_rg_holiday_para
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
alter table ${idl_schema}.oass_ref_rg_holiday_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ref_rg_holiday_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ref_rg_holiday_para (
etl_dt  --数据日期
,local_cty_rg_cd  --所在国家和地区代码
,local_prov_cd  --所在省代码
,holiday_dt  --假日日期
,holiday_type_descb  --假日类型描述
,wd_flg  --工作日标志
,fit_range_cd  --适用范围代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,lp_id  --法人编号
,holiday_type_cd  --假日类型代码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.local_cty_rg_cd,chr(13),''),chr(10),'') as local_cty_rg_cd --所在国家和地区代码
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,t1.holiday_dt as holiday_dt --假日日期
,replace(replace(t1.holiday_type_descb,chr(13),''),chr(10),'') as holiday_type_descb --假日类型描述
,replace(replace(t1.wd_flg,chr(13),''),chr(10),'') as wd_flg --工作日标志
,replace(replace(t1.fit_range_cd,chr(13),''),chr(10),'') as fit_range_cd --适用范围代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.holiday_type_cd,chr(13),''),chr(10),'') as holiday_type_cd --假日类型代码
from ${iml_schema}.ref_rg_holiday_para t1    --地区节假日参数
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ref_rg_holiday_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
