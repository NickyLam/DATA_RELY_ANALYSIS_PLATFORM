/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_fin_ind_h
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
alter table ${idl_schema}.oass_pty_party_fin_ind_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_fin_ind_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_fin_ind_h (
etl_dt  --数据日期
,lp_id  --法人编号
,sorc_sys_cd  --源系统代码
,ind_val  --指标值
,sal_acct_num  --工资账号
,open_acct_bank  --工资账号开户银行
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,fin_ind_cd  --财务指标代码
,party_id  --当事人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,t1.ind_val as ind_val --指标值
,replace(replace(t1.sal_acct_num,chr(13),''),chr(10),'') as sal_acct_num --工资账号
,replace(replace(t1.open_acct_bank,chr(13),''),chr(10),'') as open_acct_bank --工资账号开户银行
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.fin_ind_cd,chr(13),''),chr(10),'') as fin_ind_cd --财务指标代码
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
from ${iml_schema}.pty_party_fin_ind_h t1    --当事人财务指标历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_fin_ind_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
