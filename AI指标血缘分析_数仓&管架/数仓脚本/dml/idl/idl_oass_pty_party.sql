/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party
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
alter table ${idl_schema}.oass_pty_party drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party (
etl_dt  --ETL处理日期
,src_party_id  --源当事人编号
,party_name  --当事人名称
,party_type_cd  --当事人类型代码
,effect_dt  --客户开户日期
,invalid_dt  --客户销户日期
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,src_party_type_cd  --源当事人类型代码
,party_id  --当事人编号
,lp_id  --法人编号
,job_cd --系统来源

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.src_party_id,chr(13),''),chr(10),'') as src_party_id --源当事人编号
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name --当事人名称
,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'') as party_type_cd --当事人类型代码
,t1.effect_dt as effect_dt --客户开户日期
,t1.invalid_dt as invalid_dt --客户销户日期
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.src_party_type_cd,chr(13),''),chr(10),'') as src_party_type_cd --源当事人类型代码
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd --法人编号
from ${iml_schema}.pty_party t1    --当事人
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
