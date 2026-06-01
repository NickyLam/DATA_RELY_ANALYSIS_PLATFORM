/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_vouch_acct_rela_h
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
alter table ${idl_schema}.oass_agt_vouch_acct_rela_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_vouch_acct_rela_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_vouch_acct_rela_h (
etl_dt  --数据日期
,cust_acct_num  --客户账号
,dep_vouch_cate_cd  --存款凭证类别代码
,vouch_no  --凭证号码
,prod_id  --产品编号
,curr_cd  --币种代码
,sub_acct_num  --子账号
,card_no  --卡号
,vouch_kind_cd  --凭证种类代码
,vouch_status_cd  --凭证状态代码
,vouch_orig_status_cd  --凭证原状态代码
,tran_ref_no  --交易参考号
,pm_flg  --抵质押标志
,pm_id  --抵质押编号
,cust_id  --客户编号
,tran_memo_descb  --交易摘要描述
,tran_dt  --交易日期
,cancel_rs_cd  --作废原因代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num --客户账号
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd --存款凭证类别代码
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no --凭证号码
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num --子账号
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no --卡号
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd --凭证种类代码
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd --凭证状态代码
,replace(replace(t1.vouch_orig_status_cd,chr(13),''),chr(10),'') as vouch_orig_status_cd --凭证原状态代码
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.pm_flg,chr(13),''),chr(10),'') as pm_flg --抵质押标志
,replace(replace(t1.pm_id,chr(13),''),chr(10),'') as pm_id --抵质押编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb --交易摘要描述
,t1.tran_dt as tran_dt --交易日期
,replace(replace(t1.cancel_rs_cd,chr(13),''),chr(10),'') as cancel_rs_cd --作废原因代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_vouch_acct_rela_h t1    --凭证账户关系历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_vouch_acct_rela_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
