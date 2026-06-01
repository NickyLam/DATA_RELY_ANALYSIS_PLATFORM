/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_obank_dep_rcpt_inpwn_info
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
alter table ${idl_schema}.oass_ast_obank_dep_rcpt_inpwn_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_obank_dep_rcpt_inpwn_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_obank_dep_rcpt_inpwn_info (
etl_dt  --ETL处理日期
,vouch_id  --凭证编号
,aval_amt  --可用金额
,bank_name  --银行名称
,bank_rgst_cd  --银行注册地代码
,ext_rating_dt  --外部评级日期
,ext_rating_rest_cd  --外部评级结果代码
,effect_dt  --生效日期
,exp_dt  --到期日期
,dep_term  --存期
,int_rat  --利率
,pric_amt  --本金金额
,curr_cd  --币种代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,remark  --备注
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id --凭证编号
,t1.aval_amt as aval_amt --可用金额
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name --银行名称
,replace(replace(t1.bank_rgst_cd,chr(13),''),chr(10),'') as bank_rgst_cd --银行注册地代码
,t1.ext_rating_dt as ext_rating_dt --外部评级日期
,replace(replace(t1.ext_rating_rest_cd,chr(13),''),chr(10),'') as ext_rating_rest_cd --外部评级结果代码
,t1.effect_dt as effect_dt --生效日期
,t1.exp_dt as exp_dt --到期日期
,t1.dep_term as dep_term --存期
,t1.int_rat as int_rat --利率
,t1.pric_amt as pric_amt --本金金额
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info t1    --他行存单质押信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_obank_dep_rcpt_inpwn_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
