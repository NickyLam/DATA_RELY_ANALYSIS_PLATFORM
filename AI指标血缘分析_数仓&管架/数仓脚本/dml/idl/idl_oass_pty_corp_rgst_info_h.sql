/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_corp_rgst_info_h
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
alter table ${idl_schema}.oass_pty_corp_rgst_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_corp_rgst_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_corp_rgst_info_h (
etl_dt  --数据日期
,found_dt  --成立日期
,rgst_cd  --登记注册代码
,oper_field_prop_cd  --经营场地所有权代码
,oper_range  --经营范围
,corp_rgst_type_cd  --企业登记注册类型代码
,paid_in_capital  --实收资本
,paid_in_capital_curr_cd  --实收资本币种代码
,invtor_cty_cd  --投资方国家代码
,rgst_cap  --注册资本
,rgst_cap_curr_cd  --注册资本币种代码
,asset_tot  --集团资产总额
,leg_oper_situ  --合法经营情况
,oper_field_area  --经营场地面积
,major_prod_serv_situ  --主要产品和服务情况
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,work_rg_dist_cd  --办公地区行政区划代码
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.found_dt as found_dt --成立日期
,replace(replace(t1.rgst_cd,chr(13),''),chr(10),'') as rgst_cd --登记注册代码
,replace(replace(t1.oper_field_prop_cd,chr(13),''),chr(10),'') as oper_field_prop_cd --经营场地所有权代码
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range --经营范围
,replace(replace(t1.corp_rgst_type_cd,chr(13),''),chr(10),'') as corp_rgst_type_cd --企业登记注册类型代码
,t1.paid_in_capital as paid_in_capital --实收资本
,replace(replace(t1.paid_in_capital_curr_cd,chr(13),''),chr(10),'') as paid_in_capital_curr_cd --实收资本币种代码
,replace(replace(t1.invtor_cty_cd,chr(13),''),chr(10),'') as invtor_cty_cd --投资方国家代码
,t1.rgst_cap as rgst_cap --注册资本
,replace(replace(t1.rgst_cap_curr_cd,chr(13),''),chr(10),'') as rgst_cap_curr_cd --注册资本币种代码
,t1.asset_tot as asset_tot --集团资产总额
,replace(replace(t1.leg_oper_situ,chr(13),''),chr(10),'') as leg_oper_situ --合法经营情况
,t1.oper_field_area as oper_field_area --经营场地面积
,replace(replace(t1.major_prod_serv_situ,chr(13),''),chr(10),'') as major_prod_serv_situ --主要产品和服务情况
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.work_rg_dist_cd,chr(13),''),chr(10),'') as work_rg_dist_cd --办公地区行政区划代码
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_corp_rgst_info_h t1    --公司登记注册信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_corp_rgst_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
