/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_phys_addr_h
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
alter table ${idl_schema}.oass_pty_party_phys_addr_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_phys_addr_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_phys_addr_h (
etl_dt  --数据日期
,src_sys_cd  --源系统代码
,phys_addr_type_cd  --物理地址类型代码
,seq_num  --序号
,cont_addr  --联系地址
,zip_cd  --邮政编码
,tel_num  --电话号码
,fax_num  --传真号码
,cty_rg_cd  --国家和地区代码
,phys_addr  --物理地址
,dist_cd  --行政区划代码
,addr_status_type_cd  --地址状态类型代码
,fc_flg  --首选标志
,prov_cd  --省代码
,city_cd  --市代码
,rg_county_cd  --区县代码
,street_name  --街道名称
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd --源系统代码
,replace(replace(t1.phys_addr_type_cd,chr(13),''),chr(10),'') as phys_addr_type_cd --物理地址类型代码
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num --序号
,replace(replace(t1.cont_addr,chr(13),''),chr(10),'') as cont_addr --联系地址
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd --邮政编码
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num --电话号码
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num --传真号码
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd --国家和地区代码
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr --物理地址
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
,replace(replace(t1.addr_status_type_cd,chr(13),''),chr(10),'') as addr_status_type_cd --地址状态类型代码
,replace(replace(t1.fc_flg,chr(13),''),chr(10),'') as fc_flg --首选标志
,replace(replace(t1.prov_cd,chr(13),''),chr(10),'') as prov_cd --省代码
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd --市代码
,replace(replace(t1.rg_county_cd,chr(13),''),chr(10),'') as rg_county_cd --区县代码
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name --街道名称
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_party_phys_addr_h t1    --当事人物理地址历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_phys_addr_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
