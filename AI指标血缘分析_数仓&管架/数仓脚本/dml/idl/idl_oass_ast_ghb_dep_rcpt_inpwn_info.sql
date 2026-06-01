/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_ghb_dep_rcpt_inpwn_info
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
alter table ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info (
etl_dt  --数据日期
,dep_rcpt_vouch_num  --存单凭证号
,aval_amt  --可用金额
,cust_acct_num_id  --客户账号编号
,effect_dt  --生效日期
,exp_dt  --到期日期
,acct_bal  --账户余额
,cust_sub_acct_num  --客户子账户号
,stop_pay_advise_id  --止付通知书编号
,curr_cd  --币种代码
,dep_term_cd  --存期代码
,int_rat  --利率
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,remark  --备注
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.dep_rcpt_vouch_num,chr(13),''),chr(10),'') as dep_rcpt_vouch_num --存单凭证号
,t1.aval_amt as aval_amt --可用金额
,replace(replace(t1.cust_acct_num_id,chr(13),''),chr(10),'') as cust_acct_num_id --客户账号编号
,t1.effect_dt as effect_dt --生效日期
,t1.exp_dt as exp_dt --到期日期
,t1.acct_bal as acct_bal --账户余额
,replace(replace(t1.cust_sub_acct_num,chr(13),''),chr(10),'') as cust_sub_acct_num --客户子账户号
,replace(replace(t1.stop_pay_advise_id,chr(13),''),chr(10),'') as stop_pay_advise_id --止付通知书编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd --存期代码
,t1.int_rat as int_rat --利率
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info t1    --本行存单质押信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_ghb_dep_rcpt_inpwn_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
