/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_finc_acct
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
alter table ${idl_schema}.oass_agt_finc_acct drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_finc_acct add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_finc_acct (
etl_dt  --数据日期
,lp_id  --法人编号
,ta_cd  --TA代码
,finc_acct_id  --理财账户编号
,belong_org_id  --所属机构编号
,ta_tran_acct_id  --TA交易账户编号
,cust_mgr_id  --客户经理编号
,open_acct_way_cd  --开户方式代码
,cust_type_cd  --客户类型代码
,bus_cate_cd  --业务类别代码
,acct_status_cd  --账户状态代码
,open_dt  --开通日期
,sign_acct_id  --签约账户编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,intnal_cust_acct  --内部客户账户

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id --理财账户编号
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id --所属机构编号
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id --TA交易账户编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.open_acct_way_cd,chr(13),''),chr(10),'') as open_acct_way_cd --开户方式代码
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd --客户类型代码
,replace(replace(t1.bus_cate_cd,chr(13),''),chr(10),'') as bus_cate_cd --业务类别代码
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd --账户状态代码
,t1.open_dt as open_dt --开通日期
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id --签约账户编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.intnal_cust_acct,chr(13),''),chr(10),'') as intnal_cust_acct --内部客户账户
from ${iml_schema}.agt_finc_acct t1    --理财账户
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_finc_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
