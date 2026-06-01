/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_teller_info_h
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
alter table ${idl_schema}.oass_pty_teller_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_teller_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_teller_info_h (
etl_dt  --数据日期
,teller_id  --柜员编号
,teller_name  --柜员名称
,org_id  --机构编号
,teller_status_cd  --柜员状态代码
,teller_type_cd  --柜员类型代码
,emply_id  --员工编号
,cust_mgr_id  --客户经理编号
,cust_mgr_flg  --客户经理标志
,cust_mgr_lev_cd  --客户经理级别代码
,teller_lev_cd  --柜员级别代码
,teller_director_id  --柜员主管编号
,high_teller_flg  --高柜标志
,teller_create_dt  --柜员创建日期
,logon_dt  --登陆日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,teller_subclass_cd  --柜员细类代码
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id --柜员编号
,replace(replace(t1.teller_name,chr(13),''),chr(10),'') as teller_name --柜员名称
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.teller_status_cd,chr(13),''),chr(10),'') as teller_status_cd --柜员状态代码
,replace(replace(t1.teller_type_cd,chr(13),''),chr(10),'') as teller_type_cd --柜员类型代码
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id --员工编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.cust_mgr_flg,chr(13),''),chr(10),'') as cust_mgr_flg --客户经理标志
,replace(replace(t1.cust_mgr_lev_cd,chr(13),''),chr(10),'') as cust_mgr_lev_cd --客户经理级别代码
,replace(replace(t1.teller_lev_cd,chr(13),''),chr(10),'') as teller_lev_cd --柜员级别代码
,replace(replace(t1.teller_director_id,chr(13),''),chr(10),'') as teller_director_id --柜员主管编号
,replace(replace(t1.high_teller_flg,chr(13),''),chr(10),'') as high_teller_flg --高柜标志
,t1.teller_create_dt as teller_create_dt --柜员创建日期
,t1.logon_dt as logon_dt --登陆日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.teller_subclass_cd,chr(13),''),chr(10),'') as teller_subclass_cd --柜员细类代码
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_teller_info_h t1    --柜员信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_teller_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
