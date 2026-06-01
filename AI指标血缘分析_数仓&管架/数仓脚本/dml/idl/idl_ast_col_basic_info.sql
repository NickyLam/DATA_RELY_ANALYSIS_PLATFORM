/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_basic_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.ast_col_basic_info drop partition p_${last_date};
alter table ${idl_schema}.ast_col_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_basic_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,col_type_id  -- 押品类型编号
    ,col_mgmt_id  -- 押品管理员工编号
    ,col_mgmt_org_id  -- 押品管理机构编号
    ,setup_dt  -- 建立日期
    ,com_prot_flg  -- 共同财产标志
    ,asset_obg_lot  -- 资产权利人所占份额
    ,guar_effect_way_cd  -- 担保生效方式代码
    ,trast_insure_flg  -- 办理保险标志
    ,col_rgst_trast_status_cd  -- 押品登记办理状态代码
    ,col_insure_trast_status_cd  -- 押品保险办理状态代码
    ,col_insto_status_cd  -- 押品入库状态代码
    ,col_rela_status_cd  -- 押品关联状态代码
    ,col_espec_status_cd  -- 押品特殊状态代码
    ,wt_md_cash_ability_cd  -- 权重法变现能力代码
    ,obank_guar_flg  -- 他行担保标志
    ,gcust_flg  -- 代保管标志
    ,col_val  -- 押品价值
    ,curr_cd  -- 币种代码
    ,val_estim_dt  -- 价值评估日期
    ,data_src_cd  -- 数据来源代码
    ,col_info_check_status_cd  -- 押品信息审核状态代码
    ,col_modif_apv_status_cd  -- 押品修改审批状态代码
    ,np_cash_ability_cd  -- 内评初级法变现能力代码
    ,get_key_info_flg  -- 取得关键信息标志
    ,modifbl_flg  -- 可修改标志
    ,col_name  -- 押品名称
    ,pledge_ctrl_f_adj_coef_cd  -- 质押物控制力调整系数代码
    ,modif_emply_id  -- 修改员工编号
    ,save_hxb_flg  -- 保存我行标志
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.col_type_id,chr(13),''),chr(10),'')  -- 押品类型编号
    ,replace(replace(t1.col_mgmt_id,chr(13),''),chr(10),'')  -- 押品管理员工编号
    ,replace(replace(t1.col_mgmt_org_id,chr(13),''),chr(10),'')  -- 押品管理机构编号
    ,t1.setup_dt  -- 建立日期
    ,replace(replace(t1.com_prot_flg,chr(13),''),chr(10),'')  -- 共同财产标志
    ,t1.asset_obg_lot  -- 资产权利人所占份额
    ,replace(replace(t1.guar_effect_way_cd,chr(13),''),chr(10),'')  -- 担保生效方式代码
    ,replace(replace(t1.trast_insure_flg,chr(13),''),chr(10),'')  -- 办理保险标志
    ,replace(replace(t1.col_rgst_trast_status_cd,chr(13),''),chr(10),'')  -- 押品登记办理状态代码
    ,replace(replace(t1.col_insure_trast_status_cd,chr(13),''),chr(10),'')  -- 押品保险办理状态代码
    ,replace(replace(t1.col_insto_status_cd,chr(13),''),chr(10),'')  -- 押品入库状态代码
    ,replace(replace(t1.col_rela_status_cd,chr(13),''),chr(10),'')  -- 押品关联状态代码
    ,replace(replace(t1.col_espec_status_cd,chr(13),''),chr(10),'')  -- 押品特殊状态代码
    ,replace(replace(t1.wt_md_cash_ability_cd,chr(13),''),chr(10),'')  -- 权重法变现能力代码
    ,replace(replace(t1.obank_guar_flg,chr(13),''),chr(10),'')  -- 他行担保标志
    ,replace(replace(t1.gcust_flg,chr(13),''),chr(10),'')  -- 代保管标志
    ,t1.col_val  -- 押品价值
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.val_estim_dt  -- 价值评估日期
    ,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'')  -- 数据来源代码
    ,replace(replace(t1.col_info_check_status_cd,chr(13),''),chr(10),'')  -- 押品信息审核状态代码
    ,replace(replace(t1.col_modif_apv_status_cd,chr(13),''),chr(10),'')  -- 押品修改审批状态代码
    ,replace(replace(t1.np_cash_ability_cd,chr(13),''),chr(10),'')  -- 内评初级法变现能力代码
    ,replace(replace(t1.get_key_info_flg,chr(13),''),chr(10),'')  -- 取得关键信息标志
    ,replace(replace(t1.modifbl_flg,chr(13),''),chr(10),'')  -- 可修改标志
    ,replace(replace(t1.col_name,chr(13),''),chr(10),'')  -- 押品名称
    ,replace(replace(t1.pledge_ctrl_f_adj_coef_cd,chr(13),''),chr(10),'')  -- 质押物控制力调整系数代码
    ,replace(replace(t1.modif_emply_id,chr(13),''),chr(10),'')  -- 修改员工编号
    ,replace(replace(t1.save_hxb_flg,chr(13),''),chr(10),'')  -- 保存我行标志
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.ast_col_basic_info t1    --押品基本信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);