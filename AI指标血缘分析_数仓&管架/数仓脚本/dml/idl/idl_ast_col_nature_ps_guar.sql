/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_nature_ps_guar
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
--alter table ${idl_schema}.ast_col_nature_ps_guar drop partition p_${last_date};
alter table ${idl_schema}.ast_col_nature_ps_guar drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_nature_ps_guar add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_nature_ps_guar (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,guartor_type_cd  -- 保证人类型代码
    ,guartor_id  -- 保证人编号
    ,guartor_name  -- 保证人名称
    ,guartor_cert_no  -- 保证人证件号码
    ,guartor_cert_type_cd  -- 保证人证件类型代码
    ,guartor_nat_std_indus_cls_cd  -- 保证人国标行业分类代码
    ,guartor_net_asset_amt  -- 保证人净资产金额
    ,guartor_econ_compnt_cd  -- 保证人经济成分代码
    ,guartor_guar_indep_cd  -- 保证人担保独立性代码
    ,guartor_rgst_cd  -- 保证人注册地代码
    ,guartor_rgst_ext_rating_cd  -- 保证人注册地外部评级结果代码
    ,guartor_ext_rating_dt  -- 保证人外部评级日期
    ,guartor_ext_rating_rest_cd  -- 保证人外部评级结果代码
    ,guartor_intnal_rating_dt  -- 保证人内部评级日期
    ,guartor_intnal_rating_rest_cd  -- 保证人内部评级结果代码
    ,guar_aim_cd  -- 保证目的代码
    ,stage_guar_flg  -- 阶段性担保标志
    ,other_comnt  -- 其他说明
    ,curr_cd  -- 币种代码
    ,resdnt_flg  -- 是否居民标志
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.guartor_type_cd,chr(13),''),chr(10),'')  -- 保证人类型代码
    ,replace(replace(t1.guartor_id,chr(13),''),chr(10),'')  -- 保证人编号
    ,replace(replace(t1.guartor_name,chr(13),''),chr(10),'')  -- 保证人名称
    ,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'')  -- 保证人证件号码
    ,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'')  -- 保证人证件类型代码
    ,replace(replace(t1.guartor_nat_std_indus_cls_cd,chr(13),''),chr(10),'')  -- 保证人国标行业分类代码
    ,t1.guartor_net_asset_amt  -- 保证人净资产金额
    ,replace(replace(t1.guartor_econ_compnt_cd,chr(13),''),chr(10),'')  -- 保证人经济成分代码
    ,replace(replace(t1.guartor_guar_indep_cd,chr(13),''),chr(10),'')  -- 保证人担保独立性代码
    ,replace(replace(t1.guartor_rgst_cd,chr(13),''),chr(10),'')  -- 保证人注册地代码
    ,replace(replace(t1.guartor_rgst_ext_rating_cd,chr(13),''),chr(10),'')  -- 保证人注册地外部评级结果代码
    ,t1.guartor_ext_rating_dt  -- 保证人外部评级日期
    ,replace(replace(t1.guartor_ext_rating_rest_cd,chr(13),''),chr(10),'')  -- 保证人外部评级结果代码
    ,t1.guartor_intnal_rating_dt  -- 保证人内部评级日期
    ,replace(replace(t1.guartor_intnal_rating_rest_cd,chr(13),''),chr(10),'')  -- 保证人内部评级结果代码
    ,replace(replace(t1.guar_aim_cd,chr(13),''),chr(10),'')  -- 保证目的代码
    ,replace(replace(t1.stage_guar_flg,chr(13),''),chr(10),'')  -- 阶段性担保标志
    ,replace(replace(t1.other_comnt,chr(13),''),chr(10),'')  -- 其他说明
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'')  -- 是否居民标志
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.ast_col_nature_ps_guar t1    --押品自然人保证
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_nature_ps_guar',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);