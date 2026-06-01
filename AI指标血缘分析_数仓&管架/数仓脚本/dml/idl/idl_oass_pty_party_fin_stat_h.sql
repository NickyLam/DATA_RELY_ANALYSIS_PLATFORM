/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_fin_stat_h
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
alter table ${idl_schema}.oass_pty_party_fin_stat_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_fin_stat_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_fin_stat_h (
etl_dt  --数据日期
,lp_id  --法人编号
,rept_curr_cd  --报表币种代码
,rept_corp_cd  --报表单位代码
,rept_cali_type_cd  --报表口径类型代码
,rept_dt  --报表日期
,rept_ped_cd  --报表周期代码
,rept_note  --报表注释
,rept_status_cd  --报表状态代码
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,rgst_user_id  --登记用户编号
,audit_flg  --审计标志
,audit_corp  --审计单位名称
,audit_opinion  --审计意见
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,rec_id  --记录编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.rept_curr_cd,chr(13),''),chr(10),'') as rept_curr_cd --报表币种代码
,replace(replace(t1.rept_corp_cd,chr(13),''),chr(10),'') as rept_corp_cd --报表单位代码
,replace(replace(t1.rept_cali_type_cd,chr(13),''),chr(10),'') as rept_cali_type_cd --报表口径类型代码
,t1.rept_dt as rept_dt --报表日期
,replace(replace(t1.rept_ped_cd,chr(13),''),chr(10),'') as rept_ped_cd --报表周期代码
,replace(replace(t1.rept_note,chr(13),''),chr(10),'') as rept_note --报表注释
,replace(replace(t1.rept_status_cd,chr(13),''),chr(10),'') as rept_status_cd --报表状态代码
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.rgst_user_id,chr(13),''),chr(10),'') as rgst_user_id --登记用户编号
,replace(replace(t1.audit_flg,chr(13),''),chr(10),'') as audit_flg --审计标志
,replace(replace(t1.audit_corp,chr(13),''),chr(10),'') as audit_corp --审计单位名称
,replace(replace(t1.audit_opinion,chr(13),''),chr(10),'') as audit_opinion --审计意见
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.rec_id,chr(13),''),chr(10),'') as rec_id --记录编号
from ${iml_schema}.pty_party_fin_stat_h t1    --当事人财务报表历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_fin_stat_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
