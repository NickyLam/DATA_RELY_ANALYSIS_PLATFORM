/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_tran_recvbl_info
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
alter table ${idl_schema}.oass_ast_col_tran_recvbl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_tran_recvbl_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_tran_recvbl_info (
etl_dt  --ETL处理日期
,lc_num  --信用证号码
,fac_val_amt  --票面金额
,inv_id  --发票编号
,inv_dt  --发票日期
,inv_exp_dt  --发票到期日期
,aging  --账龄
,payer_name  --付款人名称
,bkrpt_clear_flg  --破产清算标志
,payer_acct_id  --付款人账户编号
,advise_acct_recvbl_flg  --通知应收账款义务人标志
,cred_rht_prod_flg  --债权产生标志
,other_comnt  --其他说明
,rela_flg  --关系标志
,curr_cd  --币种代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.lc_num,chr(13),''),chr(10),'') as lc_num --信用证号码
,t1.fac_val_amt as fac_val_amt --票面金额
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id --发票编号
,t1.inv_dt as inv_dt --发票日期
,t1.inv_exp_dt as inv_exp_dt --发票到期日期
,t1.aging as aging --账龄
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name --付款人名称
,replace(replace(t1.bkrpt_clear_flg,chr(13),''),chr(10),'') as bkrpt_clear_flg --破产清算标志
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id --付款人账户编号
,replace(replace(t1.advise_acct_recvbl_flg,chr(13),''),chr(10),'') as advise_acct_recvbl_flg --通知应收账款义务人标志
,replace(replace(t1.cred_rht_prod_flg,chr(13),''),chr(10),'') as cred_rht_prod_flg --债权产生标志
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.rela_flg,chr(13),''),chr(10),'') as rela_flg --关系标志
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_tran_recvbl_info t1    --押品交易类应收账款信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_tran_recvbl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
