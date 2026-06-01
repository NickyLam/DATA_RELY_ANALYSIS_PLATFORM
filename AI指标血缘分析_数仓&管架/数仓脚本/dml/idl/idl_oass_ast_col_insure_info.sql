/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_insure_info
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
alter table ${idl_schema}.oass_ast_col_insure_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_insure_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_insure_info (
etl_dt  --ETL处理日期
,insure_seq_num  --保险序号
,insure_pl_id  --保险单编号
,insu_comp_name  --保险公司名称
,insu_comp_orgnz_cd  --保险公司组织机构代码
,full_amt_insure_flg  --全额投保标志
,insure_insud_amt  --保险承保金额
,begin_dt  --起始日期
,exp_dt  --到期日期
,check_guar_dt  --核保日期
,fst_ctfer_name  --第一核保人姓名
,secd_ctfer_name  --第二核保人姓名
,operr_id  --操作员编号
,insure_status_cd  --保险状态代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.insure_seq_num,chr(13),''),chr(10),'') as insure_seq_num --保险序号
,replace(replace(t1.insure_pl_id,chr(13),''),chr(10),'') as insure_pl_id --保险单编号
,replace(replace(t1.insu_comp_name,chr(13),''),chr(10),'') as insu_comp_name --保险公司名称
,replace(replace(t1.insu_comp_orgnz_cd,chr(13),''),chr(10),'') as insu_comp_orgnz_cd --保险公司组织机构代码
,replace(replace(t1.full_amt_insure_flg,chr(13),''),chr(10),'') as full_amt_insure_flg --全额投保标志
,t1.insure_insud_amt as insure_insud_amt --保险承保金额
,t1.begin_dt as begin_dt --起始日期
,t1.exp_dt as exp_dt --到期日期
,t1.check_guar_dt as check_guar_dt --核保日期
,replace(replace(t1.fst_ctfer_name,chr(13),''),chr(10),'') as fst_ctfer_name --第一核保人姓名
,replace(replace(t1.secd_ctfer_name,chr(13),''),chr(10),'') as secd_ctfer_name --第二核保人姓名
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --操作员编号
,replace(replace(t1.insure_status_cd,chr(13),''),chr(10),'') as insure_status_cd --保险状态代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_insure_info t1    --押品保险信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_insure_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
