/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ref_bill_bus_code_subj_rela
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
alter table ${idl_schema}.oass_ref_bill_bus_code_subj_rela drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ref_bill_bus_code_subj_rela add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ref_bill_bus_code_subj_rela (
etl_dt  --ETL处理日期
,bus_code  --业务编码
,amt_type_cd  --金额类型代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,subj_id  --科目编号
,subj_name  --科目名称

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.bus_code,chr(13),''),chr(10),'') as bus_code --业务编码
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd --金额类型代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name --科目名称
from ${iml_schema}.ref_bill_bus_code_subj_rela t1    --票据业务编码和科目关系
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ref_bill_bus_code_subj_rela',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
