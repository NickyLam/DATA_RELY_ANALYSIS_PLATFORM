/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_chn_termn_equip_basic_info_h
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
alter table ${idl_schema}.oass_chn_termn_equip_basic_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_chn_termn_equip_basic_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_chn_termn_equip_basic_info_h (
etl_dt  --数据日期
,chn_id  --渠道编号
,termn_id  --设备IP
,belong_org_id  --所属机构编号
,in_bank_flg  --在行标志
,equip_type_cd  --设备类型代码
,equip_type_name  --设备类型名称
,equip_model  --设备型号
,equip_status_cd  --设备状态代码
,equip_matnce_id  --设备维护商编号
,equip_install_dt  --设备安装日期
,cash_flg  --现金标志
,install_way_cd  --安装方式代码
,dist_cd  --行政区划代码
,equip_ser_num  --设备序列号
,equip_addr  --设备地址
,termn_status_cd  --终端状态代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,equip_id  --设备编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id --渠道编号
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id --设备IP
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id --所属机构编号
,replace(replace(t1.in_bank_flg,chr(13),''),chr(10),'') as in_bank_flg --在行标志
,replace(replace(t1.equip_type_cd,chr(13),''),chr(10),'') as equip_type_cd --设备类型代码
,replace(replace(t1.equip_type_name,chr(13),''),chr(10),'') as equip_type_name --设备类型名称
,replace(replace(t1.equip_model,chr(13),''),chr(10),'') as equip_model --设备型号
,replace(replace(t1.equip_status_cd,chr(13),''),chr(10),'') as equip_status_cd --设备状态代码
,replace(replace(t1.equip_matnce_id,chr(13),''),chr(10),'') as equip_matnce_id --设备维护商编号
,t1.equip_install_dt as equip_install_dt --设备安装日期
,replace(replace(t1.cash_flg,chr(13),''),chr(10),'') as cash_flg --现金标志
,replace(replace(t1.install_way_cd,chr(13),''),chr(10),'') as install_way_cd --安装方式代码
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
,replace(replace(t1.equip_ser_num,chr(13),''),chr(10),'') as equip_ser_num --设备序列号
,replace(replace(t1.equip_addr,chr(13),''),chr(10),'') as equip_addr --设备地址
,replace(replace(t1.termn_status_cd,chr(13),''),chr(10),'') as termn_status_cd --终端状态代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.equip_id,chr(13),''),chr(10),'') as equip_id --设备编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.chn_termn_equip_basic_info_h t1    --设备基本信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_chn_termn_equip_basic_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
