/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_guar_cont_rela_h
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
alter table ${idl_schema}.oass_ast_col_guar_cont_rela_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_guar_cont_rela_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_guar_cont_rela_h (
etl_dt  --数据日期
,guar_cont_id  --担保合同编号
,guar_type_cd  --担保类型代码
,loan_stage_cd  --贷款阶段代码
,guar_amt  --担保金额
,guar_curr_cd  --担保币种代码
,effect_status_cd  --生效状态代码
,exp_status_cd  --到期状态代码
,src_sys_cd  --来源系统代码
,setup_dt  --建立日期
,strip_line_cd  --条线代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id --担保合同编号
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.loan_stage_cd,chr(13),''),chr(10),'') as loan_stage_cd --贷款阶段代码
,t1.guar_amt as guar_amt --担保金额
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd --担保币种代码
,replace(replace(t1.effect_status_cd,chr(13),''),chr(10),'') as effect_status_cd --生效状态代码
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd --到期状态代码
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd --来源系统代码
,t1.setup_dt as setup_dt --建立日期
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd --条线代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_guar_cont_rela_h t1    --押品与担保合同关系历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_guar_cont_rela_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
