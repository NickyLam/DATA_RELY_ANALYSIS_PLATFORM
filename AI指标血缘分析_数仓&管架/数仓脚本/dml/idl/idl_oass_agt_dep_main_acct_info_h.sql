/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_dep_main_acct_info_h
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
alter table ${idl_schema}.oass_agt_dep_main_acct_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_dep_main_acct_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_dep_main_acct_info_h (
etl_dt  --数据日期
,lp_id  --法人编号
,cust_id  --客户编号
,card_no  --卡号
,open_acct_chn_id  --开户渠道编号
,cust_acct_num  --客户账号
,acct_prod_id  --账户产品编号
,acct_sub_acct_num  --账户子账号
,acct_curr_cd  --账户币种代码
,open_acct_org_id  --开户机构编号
,cust_acct_open_acct_dt  --客户账户开户日期
,core_acct_type_cd  --核心账户类型代码
,acct_name  --账户名称
,acct_status_cd  --账户状态代码
,last_acct_status_cd  --上一账户状态代码
,acct_status_modif_dt  --账户状态变更日期
,clos_acct_rs  --销户原因
,clos_acct_teller_id  --销户柜员编号
,acct_lmt_flg  --账户限制标志
,reg_acct_type_cd  --定期账户类型代码
,dep_vouch_cate_cd  --存款凭证类别代码
,vouch_no  --凭证号码
,vouch_status_cd  --凭证状态代码
,init_prod_id  --原产品编号
,cust_mgr_id  --客户经理编号
,general_storage_flg  --通存标志
,general_exch_flg  --通兑标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,acct_id  --账户编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no --卡号
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id --开户渠道编号
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num --客户账号
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id --账户产品编号
,replace(replace(t1.acct_sub_acct_num,chr(13),''),chr(10),'') as acct_sub_acct_num --账户子账号
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd --账户币种代码
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,t1.cust_acct_open_acct_dt as cust_acct_open_acct_dt --客户账户开户日期
,replace(replace(t1.core_acct_type_cd,chr(13),''),chr(10),'') as core_acct_type_cd --核心账户类型代码
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name --账户名称
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd --账户状态代码
,replace(replace(t1.last_acct_status_cd,chr(13),''),chr(10),'') as last_acct_status_cd --上一账户状态代码
,t1.acct_status_modif_dt as acct_status_modif_dt --账户状态变更日期
,replace(replace(t1.clos_acct_rs,chr(13),''),chr(10),'') as clos_acct_rs --销户原因
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id --销户柜员编号
,replace(replace(t1.acct_lmt_flg,chr(13),''),chr(10),'') as acct_lmt_flg --账户限制标志
,replace(replace(t1.reg_acct_type_cd,chr(13),''),chr(10),'') as reg_acct_type_cd --定期账户类型代码
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd --存款凭证类别代码
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no --凭证号码
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd --凭证状态代码
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id --原产品编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg --通存标志
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg --通兑标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
from ${iml_schema}.agt_dep_main_acct_info_h t1    --存款主账户信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_dep_main_acct_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
