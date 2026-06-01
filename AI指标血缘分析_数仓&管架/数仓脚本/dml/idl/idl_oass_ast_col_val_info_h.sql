/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_val_info_h
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
alter table ${idl_schema}.oass_ast_col_val_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_val_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_val_info_h (
etl_dt  --数据日期
,estim_way_cd  --评估方式代码
,estim_dt  --估值日期
,curr_cd  --币种代码
,exch_rat  --汇率
,ext_estim_exp_dt  --估值到期日期
,ext_estim_org_id  --外部评估机构编号
,ext_estim_method_cd  --外部评估方法代码
,ext_pre_estim_val  --外部预评价值
,ext_formal_estim_dt  --外部正式评估日期
,ext_estim_val  --外部评估价值
,intnal_estim_val  --内部评估价值
,appl_estim_cfm_val  --申请评估确认价值
,flow_id  --流程编号
,hxb_cfm_val  --我行确认价值
,estim_idtfy_dt  --评估认定日期
,ext_pa_estim_val  --外部初评评估价值
,intnal_pa_estim_val  --内部初评评估价值
,hxb_pa_cfm_val  --我行初评确认价值
,pa_flow_id  --初评流程编号
,evltion_status_cd  --估值状态代码
,froz_flg  --冻结标志
,insto_col_val  --入库押品价值
,insto_org_id  --入库机构编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,ext_pre_estim_flg  --外部预评估标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd --评估方式代码
,t1.estim_dt as estim_dt --估值日期
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.exch_rat as exch_rat --汇率
,t1.ext_estim_exp_dt as ext_estim_exp_dt --估值到期日期
,replace(replace(t1.ext_estim_org_id,chr(13),''),chr(10),'') as ext_estim_org_id --外部评估机构编号
,replace(replace(t1.ext_estim_method_cd,chr(13),''),chr(10),'') as ext_estim_method_cd --外部评估方法代码
,t1.ext_pre_estim_val as ext_pre_estim_val --外部预评价值
,t1.ext_formal_estim_dt as ext_formal_estim_dt --外部正式评估日期
,t1.ext_estim_val as ext_estim_val --外部评估价值
,t1.intnal_estim_val as intnal_estim_val --内部评估价值
,t1.appl_estim_cfm_val as appl_estim_cfm_val --申请评估确认价值
,replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id --流程编号
,t1.hxb_cfm_val as hxb_cfm_val --我行确认价值
,t1.estim_idtfy_dt as estim_idtfy_dt --评估认定日期
,t1.ext_pa_estim_val as ext_pa_estim_val --外部初评评估价值
,t1.intnal_pa_estim_val as intnal_pa_estim_val --内部初评评估价值
,t1.hxb_pa_cfm_val as hxb_pa_cfm_val --我行初评确认价值
,replace(replace(t1.pa_flow_id,chr(13),''),chr(10),'') as pa_flow_id --初评流程编号
,replace(replace(t1.evltion_status_cd,chr(13),''),chr(10),'') as evltion_status_cd --估值状态代码
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg --冻结标志
,t1.insto_col_val as insto_col_val --入库押品价值
,replace(replace(t1.insto_org_id,chr(13),''),chr(10),'') as insto_org_id --入库机构编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.ext_pre_estim_flg,chr(13),''),chr(10),'') as ext_pre_estim_flg --外部预评估标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_val_info_h t1    --押品价值信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_val_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
