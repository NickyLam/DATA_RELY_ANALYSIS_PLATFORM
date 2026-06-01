/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_cust
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
alter table ${idl_schema}.oass_pty_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_cust (
etl_dt  --ETL处理日期
,sorc_sys_cd  --源系统代码
,cust_id  --客户编号
,cust_cate_cd  --客户类别代码
,cust_type_cd  --客户类型代码
,cert_no  --证件号码
,cert_name  --证件名称
,cert_type_cd  --证件类型代码
,open_acct_user_id  --开户柜员编号
,open_acct_org_id  --开户机构编号
,open_acct_dt  --客户开户日期
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_cate_cd,chr(13),''),chr(10),'') as cust_cate_cd --客户类别代码
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd --客户类型代码
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.cert_name,chr(13),''),chr(10),'') as cert_name --证件名称
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd --证件类型代码
,replace(replace(t1.open_acct_user_id,chr(13),''),chr(10),'') as open_acct_user_id --开户柜员编号
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,t1.open_acct_dt as open_acct_dt --客户开户日期
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_cust t1    --客户
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
