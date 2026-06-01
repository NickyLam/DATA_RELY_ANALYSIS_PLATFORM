/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_corp_bank_acct_info_h
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
alter table ${idl_schema}.oass_pty_corp_bank_acct_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_corp_bank_acct_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_corp_bank_acct_info_h (
etl_dt  --数据日期
,sorc_sys_cd  --源系统代码
,basic_open_bank_no  --基本开户行行号
,basic_open_bank_name  --基本账户开户行名称
,basic_acct_id  --基本账户账号
,basic_open_acct_dt  --基本账户开户日期
,obank_acct_num  --他行账号
,obank_acct_bank_name  --他行账户行名称
,hxb_acct_num  --我行账号
,hxb_acct_bank_name  --我行账户行名称
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.basic_open_bank_no,chr(13),''),chr(10),'') as basic_open_bank_no --基本开户行行号
,replace(replace(t1.basic_open_bank_name,chr(13),''),chr(10),'') as basic_open_bank_name --基本账户开户行名称
,replace(replace(t1.basic_acct_id,chr(13),''),chr(10),'') as basic_acct_id --基本账户账号
,t1.basic_open_acct_dt as basic_open_acct_dt --基本账户开户日期
,replace(replace(t1.obank_acct_num,chr(13),''),chr(10),'') as obank_acct_num --他行账号
,replace(replace(t1.obank_acct_bank_name,chr(13),''),chr(10),'') as obank_acct_bank_name --他行账户行名称
,replace(replace(t1.hxb_acct_num,chr(13),''),chr(10),'') as hxb_acct_num --我行账号
,replace(replace(t1.hxb_acct_bank_name,chr(13),''),chr(10),'') as hxb_acct_bank_name --我行账户行名称
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_corp_bank_acct_info_h t1    --公司银行账户信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_corp_bank_acct_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
