/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bcdl_cust_sign_info
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
alter table ${idl_schema}.oass_agt_bcdl_cust_sign_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bcdl_cust_sign_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bcdl_cust_sign_info (
etl_dt  --ETL处理日期
,cust_id  --客户编号
,cust_name  --客户名称
,sign_id  --签约编号
,sign_dt  --签约日期
,cust_open_acct_org_id  --客户开户机构编号
,sign_org_id  --签约机构编号
,cert_type_cd  --证件类型代码
,cert_no  --证件号码
,status_cd  --状态代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id --签约编号
,t1.sign_dt as sign_dt --签约日期
,replace(replace(t1.cust_open_acct_org_id,chr(13),''),chr(10),'') as cust_open_acct_org_id --客户开户机构编号
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id --签约机构编号
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd --证件类型代码
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_bcdl_cust_sign_info t1    --银企直联客户签约信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bcdl_cust_sign_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
