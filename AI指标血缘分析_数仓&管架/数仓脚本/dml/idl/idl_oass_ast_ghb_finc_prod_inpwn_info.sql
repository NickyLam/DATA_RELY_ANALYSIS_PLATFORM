/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_ghb_finc_prod_inpwn_info
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
alter table ${idl_schema}.oass_ast_ghb_finc_prod_inpwn_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_ghb_finc_prod_inpwn_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_ghb_finc_prod_inpwn_info (
etl_dt  --ETL处理日期
,finc_prod_id  --理财产品编号
,finc_prod_name  --理财产品名称
,cap_stl_acct_num  --资金结算账号
,margin_acct_num  --保证金账号
,cap_avl_days  --资金到帐天数
,value_dt  --起息日期
,exp_dt  --到期日期
,inpwn_lot  --质押份额
,expe_yld_rat  --预期收益率
,curr_cd  --币种代码
,tot_lot  --总份额
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,remark  --
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id --理财产品编号
,replace(replace(t1.finc_prod_name,chr(13),''),chr(10),'') as finc_prod_name --理财产品名称
,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num --资金结算账号
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num --保证金账号
,t1.cap_avl_days as cap_avl_days --资金到帐天数
,t1.value_dt as value_dt --起息日期
,t1.exp_dt as exp_dt --到期日期
,t1.inpwn_lot as inpwn_lot --质押份额
,t1.expe_yld_rat as expe_yld_rat --预期收益率
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.tot_lot as tot_lot --总份额
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_ghb_finc_prod_inpwn_info t1    --本行理财产品质押信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_ghb_finc_prod_inpwn_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
