/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ref_emply_post_para
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
alter table ${idl_schema}.oass_ref_emply_post_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ref_emply_post_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ref_emply_post_para (
etl_dt  --ETL处理日期
,post_name  --职务名称
,post_cate_id  --职务类别编号
,start_use_status_flg  --启用状态标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,post_id  --职务编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name --职务名称
,replace(replace(t1.post_cate_id,chr(13),''),chr(10),'') as post_cate_id --职务类别编号
,replace(replace(t1.start_use_status_flg,chr(13),''),chr(10),'') as start_use_status_flg --启用状态标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id --职务编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ref_emply_post_para t1    --员工职务参数
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ref_emply_post_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
