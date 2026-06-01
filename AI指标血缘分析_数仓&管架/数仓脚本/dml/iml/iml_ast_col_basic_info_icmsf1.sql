/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_basic_info_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_basic_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_basic_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_basic_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_basic_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_basic_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_basic_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_basic_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_type_id -- 押品类型编号
    ,col_mgmt_id -- 押品管理员工编号
    ,col_mgmt_org_id -- 押品所属机构名称
    ,setup_dt -- 建立日期
    ,com_prot_flg -- 共同财产标志
    ,asset_obg_lot -- 资产权利人所占份额
    ,guar_effect_way_cd -- 担保生效方式代码
    ,trast_insure_flg -- 办理保险标志
    ,col_rgst_trast_status_cd -- 押品登记办理状态代码
    ,col_insure_trast_status_cd -- 押品保险办理状态代码
    ,col_insto_status_cd -- 权证状态类型代码
    ,col_rela_status_cd -- 押品关联状态代码
    ,col_espec_status_cd -- 押品状态代码
    ,wt_md_cash_ability_cd -- 权重法变现能力代码
    ,obank_guar_flg -- 他行担保标志
    ,gcust_flg -- 代保管标志
    ,col_val -- 我行确认价值
    ,curr_cd -- 币种代码
    ,val_estim_dt -- 价值评估日期
    ,data_src_cd -- 数据来源代码
    ,col_info_check_status_cd -- 押品信息审核状态代码
    ,col_modif_apv_status_cd -- 押品修改审批状态代码
    ,np_cash_ability_cd -- 内评初级法变现能力代码
    ,get_key_info_flg -- 取得关键信息标志
    ,modifbl_flg -- 可修改标志
    ,col_name -- 押品名称
    ,pledge_ctrl_f_adj_coef_cd -- 质押物控制力调整系数代码
    ,modif_emply_id -- 修改员工编号
    ,save_hxb_flg -- 保存我行标志
    ,final_modif_dt -- 最后修改日期
    ,prior_comp_weight_qtty -- 优先受偿权数额
    ,fst_flg -- 第一顺位标志
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_basic_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_basic_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_basic_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_si_securityinfo-
insert into ${iml_schema}.ast_col_basic_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_type_id -- 押品类型编号
    ,col_mgmt_id -- 押品管理员工编号
    ,col_mgmt_org_id -- 押品所属机构名称
    ,setup_dt -- 建立日期
    ,com_prot_flg -- 共同财产标志
    ,asset_obg_lot -- 资产权利人所占份额
    ,guar_effect_way_cd -- 担保生效方式代码
    ,trast_insure_flg -- 办理保险标志
    ,col_rgst_trast_status_cd -- 押品登记办理状态代码
    ,col_insure_trast_status_cd -- 押品保险办理状态代码
    ,col_insto_status_cd -- 权证状态类型代码
    ,col_rela_status_cd -- 押品关联状态代码
    ,col_espec_status_cd -- 押品状态代码
    ,wt_md_cash_ability_cd -- 权重法变现能力代码
    ,obank_guar_flg -- 他行担保标志
    ,gcust_flg -- 代保管标志
    ,col_val -- 我行确认价值
    ,curr_cd -- 币种代码
    ,val_estim_dt -- 价值评估日期
    ,data_src_cd -- 数据来源代码
    ,col_info_check_status_cd -- 押品信息审核状态代码
    ,col_modif_apv_status_cd -- 押品修改审批状态代码
    ,np_cash_ability_cd -- 内评初级法变现能力代码
    ,get_key_info_flg -- 取得关键信息标志
    ,modifbl_flg -- 可修改标志
    ,col_name -- 押品名称
    ,pledge_ctrl_f_adj_coef_cd -- 质押物控制力调整系数代码
    ,modif_emply_id -- 修改员工编号
    ,save_hxb_flg -- 保存我行标志
    ,final_modif_dt -- 最后修改日期
    ,prior_comp_weight_qtty -- 优先受偿权数额
    ,fst_flg -- 第一顺位标志
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.GUARTYPE),'-') -- 押品类型编号
    ,P1.CREATEUSER -- 押品管理员工编号
    ,P1.DEPTCODE -- 押品所属机构名称
    ,${iml_schema}.dateformat_min(P1.CREATEDATE) -- 建立日期
    ,nvl(trim(P1.CONOMINIUM),'-') -- 共同财产标志
    ,0 -- 资产权利人所占份额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.EFFECTTYPE END -- 担保生效方式代码
    ,nvl(trim(P1.ISINSURE),'-') -- 办理保险标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.GUAREGISTERSTATE END -- 押品登记办理状态代码
    ,nvl(trim(P1.GUAINSURESTATE),'00') -- 押品保险办理状态代码
    ,nvl(trim(P1.STATE),'00') -- 权证状态类型代码
    ,nvl(trim(P1.USESTATE),'00') -- 押品关联状态代码
    ,nvl(trim(P1.GUASPECIALSTATE),'00') -- 押品状态代码
    ,nvl(trim(P1.BXABILITY),'-') -- 权重法变现能力代码
    ,nvl(trim(P1.ISOTHERGUAR),'-') -- 他行担保标志
    ,nvl(trim(P1.ISGENCUST),'-') -- 代保管标志
    ,nvl(trim(P1.CONFMAMT),'-') -- 我行确认价值
    ,nvl(trim(P1.CONFMCURRENCY),'-') -- 币种代码
    ,${iml_schema}.dateformat_max(P1.EVALDATE) -- 价值评估日期
    ,nvl(trim(P1.DATASOURCEFLAG),'-') -- 数据来源代码
    ,nvl(trim(P1.EXAPSTATE),'-') -- 押品信息审核状态代码
    ,nvl(trim(P1.EDITSTATE),'-') -- 押品修改审批状态代码
    ,nvl(trim(P1.BXABILITY2),'-') -- 内评初级法变现能力代码
    ,nvl(trim(P1.ISGAIN),'-') -- 取得关键信息标志
    ,nvl(trim(P1.ISMODIFY),'-') -- 可修改标志
    ,P1.GUARINFONAME -- 押品名称
    ,nvl(trim(P1.CONTROLCHANGE),'00') -- 质押物控制力调整系数代码
    ,P1.UPDUSER -- 修改员工编号
    ,nvl(trim(P1.ISSAVEOWNER),'-') -- 保存我行标志
    ,${iml_schema}.dateformat_max(P1.UPDATES) -- 最后修改日期
    ,P1.AMOUNT -- 优先受偿权数额
    ,nvl(trim(P1.ISSEQUENCE),'-') -- 第一顺位标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.GUARSIGN END -- 押品登记簿类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_si_securityinfo' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_si_securityinfo p1
   /* left join ${iol_schema}.icms_clr_owner p2 on p1.sccode = p2.clrid
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')*/
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.EFFECTTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_SI_SECURITYINFO'
        AND R2.SRC_FIELD_EN_NAME= 'EFFECTTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AST_COL_BASIC_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'GUAR_EFFECT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.GUAREGISTERSTATE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_SI_SECURITYINFO'
        AND R3.SRC_FIELD_EN_NAME= 'GUAREGISTERSTATE'
        AND R3.TARGET_TAB_EN_NAME= 'AST_COL_BASIC_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'COL_RGST_TRAST_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GUARSIGN = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_SI_SECURITYINFO'
        AND R1.SRC_FIELD_EN_NAME= 'GUARSIGN'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_BASIC_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'COL_RGST_B_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_basic_info_icmsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ast_col_basic_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_type_id -- 押品类型编号
    ,col_mgmt_id -- 押品管理员工编号
    ,col_mgmt_org_id -- 押品所属机构名称
    ,setup_dt -- 建立日期
    ,com_prot_flg -- 共同财产标志
    ,asset_obg_lot -- 资产权利人所占份额
    ,guar_effect_way_cd -- 担保生效方式代码
    ,trast_insure_flg -- 办理保险标志
    ,col_rgst_trast_status_cd -- 押品登记办理状态代码
    ,col_insure_trast_status_cd -- 押品保险办理状态代码
    ,col_insto_status_cd -- 权证状态类型代码
    ,col_rela_status_cd -- 押品关联状态代码
    ,col_espec_status_cd -- 押品状态代码
    ,wt_md_cash_ability_cd -- 权重法变现能力代码
    ,obank_guar_flg -- 他行担保标志
    ,gcust_flg -- 代保管标志
    ,col_val -- 我行确认价值
    ,curr_cd -- 币种代码
    ,val_estim_dt -- 价值评估日期
    ,data_src_cd -- 数据来源代码
    ,col_info_check_status_cd -- 押品信息审核状态代码
    ,col_modif_apv_status_cd -- 押品修改审批状态代码
    ,np_cash_ability_cd -- 内评初级法变现能力代码
    ,get_key_info_flg -- 取得关键信息标志
    ,modifbl_flg -- 可修改标志
    ,col_name -- 押品名称
    ,pledge_ctrl_f_adj_coef_cd -- 质押物控制力调整系数代码
    ,modif_emply_id -- 修改员工编号
    ,save_hxb_flg -- 保存我行标志
    ,final_modif_dt -- 最后修改日期
    ,prior_comp_weight_qtty -- 优先受偿权数额
    ,fst_flg -- 第一顺位标志
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.col_type_id, o.col_type_id) as col_type_id -- 押品类型编号
    ,nvl(n.col_mgmt_id, o.col_mgmt_id) as col_mgmt_id -- 押品管理员工编号
    ,nvl(n.col_mgmt_org_id, o.col_mgmt_org_id) as col_mgmt_org_id -- 押品所属机构名称
    ,nvl(n.setup_dt, o.setup_dt) as setup_dt -- 建立日期
    ,nvl(n.com_prot_flg, o.com_prot_flg) as com_prot_flg -- 共同财产标志
    ,nvl(n.asset_obg_lot, o.asset_obg_lot) as asset_obg_lot -- 资产权利人所占份额
    ,nvl(n.guar_effect_way_cd, o.guar_effect_way_cd) as guar_effect_way_cd -- 担保生效方式代码
    ,nvl(n.trast_insure_flg, o.trast_insure_flg) as trast_insure_flg -- 办理保险标志
    ,nvl(n.col_rgst_trast_status_cd, o.col_rgst_trast_status_cd) as col_rgst_trast_status_cd -- 押品登记办理状态代码
    ,nvl(n.col_insure_trast_status_cd, o.col_insure_trast_status_cd) as col_insure_trast_status_cd -- 押品保险办理状态代码
    ,nvl(n.col_insto_status_cd, o.col_insto_status_cd) as col_insto_status_cd -- 权证状态类型代码
    ,nvl(n.col_rela_status_cd, o.col_rela_status_cd) as col_rela_status_cd -- 押品关联状态代码
    ,nvl(n.col_espec_status_cd, o.col_espec_status_cd) as col_espec_status_cd -- 押品状态代码
    ,nvl(n.wt_md_cash_ability_cd, o.wt_md_cash_ability_cd) as wt_md_cash_ability_cd -- 权重法变现能力代码
    ,nvl(n.obank_guar_flg, o.obank_guar_flg) as obank_guar_flg -- 他行担保标志
    ,nvl(n.gcust_flg, o.gcust_flg) as gcust_flg -- 代保管标志
    ,nvl(n.col_val, o.col_val) as col_val -- 我行确认价值
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.val_estim_dt, o.val_estim_dt) as val_estim_dt -- 价值评估日期
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.col_info_check_status_cd, o.col_info_check_status_cd) as col_info_check_status_cd -- 押品信息审核状态代码
    ,nvl(n.col_modif_apv_status_cd, o.col_modif_apv_status_cd) as col_modif_apv_status_cd -- 押品修改审批状态代码
    ,nvl(n.np_cash_ability_cd, o.np_cash_ability_cd) as np_cash_ability_cd -- 内评初级法变现能力代码
    ,nvl(n.get_key_info_flg, o.get_key_info_flg) as get_key_info_flg -- 取得关键信息标志
    ,nvl(n.modifbl_flg, o.modifbl_flg) as modifbl_flg -- 可修改标志
    ,nvl(n.col_name, o.col_name) as col_name -- 押品名称
    ,nvl(n.pledge_ctrl_f_adj_coef_cd, o.pledge_ctrl_f_adj_coef_cd) as pledge_ctrl_f_adj_coef_cd -- 质押物控制力调整系数代码
    ,nvl(n.modif_emply_id, o.modif_emply_id) as modif_emply_id -- 修改员工编号
    ,nvl(n.save_hxb_flg, o.save_hxb_flg) as save_hxb_flg -- 保存我行标志
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.prior_comp_weight_qtty, o.prior_comp_weight_qtty) as prior_comp_weight_qtty -- 优先受偿权数额
    ,nvl(n.fst_flg, o.fst_flg) as fst_flg -- 第一顺位标志
    ,nvl(n.col_rgst_b_type_cd, o.col_rgst_b_type_cd) as col_rgst_b_type_cd -- 押品登记簿类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.col_type_id <> n.col_type_id
                or o.col_mgmt_id <> n.col_mgmt_id
                or o.col_mgmt_org_id <> n.col_mgmt_org_id
                or o.setup_dt <> n.setup_dt
                or o.com_prot_flg <> n.com_prot_flg
                or o.asset_obg_lot <> n.asset_obg_lot
                or o.guar_effect_way_cd <> n.guar_effect_way_cd
                or o.trast_insure_flg <> n.trast_insure_flg
                or o.col_rgst_trast_status_cd <> n.col_rgst_trast_status_cd
                or o.col_insure_trast_status_cd <> n.col_insure_trast_status_cd
                or o.col_insto_status_cd <> n.col_insto_status_cd
                or o.col_rela_status_cd <> n.col_rela_status_cd
                or o.col_espec_status_cd <> n.col_espec_status_cd
                or o.wt_md_cash_ability_cd <> n.wt_md_cash_ability_cd
                or o.obank_guar_flg <> n.obank_guar_flg
                or o.gcust_flg <> n.gcust_flg
                or o.col_val <> n.col_val
                or o.curr_cd <> n.curr_cd
                or o.val_estim_dt <> n.val_estim_dt
                or o.data_src_cd <> n.data_src_cd
                or o.col_info_check_status_cd <> n.col_info_check_status_cd
                or o.col_modif_apv_status_cd <> n.col_modif_apv_status_cd
                or o.np_cash_ability_cd <> n.np_cash_ability_cd
                or o.get_key_info_flg <> n.get_key_info_flg
                or o.modifbl_flg <> n.modifbl_flg
                or o.col_name <> n.col_name
                or o.pledge_ctrl_f_adj_coef_cd <> n.pledge_ctrl_f_adj_coef_cd
                or o.modif_emply_id <> n.modif_emply_id
                or o.save_hxb_flg <> n.save_hxb_flg
                or o.final_modif_dt <> n.final_modif_dt
                or o.prior_comp_weight_qtty <> n.prior_comp_weight_qtty
                or o.fst_flg <> n.fst_flg
                or o.col_rgst_b_type_cd <> n.col_rgst_b_type_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_basic_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_basic_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_basic_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_basic_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_basic_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_basic_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_basic_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_basic_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_basic_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_basic_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_basic_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);