/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_ext_info_ctmsf1
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
drop table ${iml_schema}.prd_bond_ext_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_ext_info_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond_ext_info add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_ext_info modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_ext_info_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_ext_info partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_ext_info_ctmsf1_tm
compress ${option_switch} for query high
as
select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,net_dlvy_flg -- 净交割标志
    ,trust_org_cd -- 托管机构代码
    ,asset_type_cd -- 资产类型代码
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,rpp_proc_way_cd -- 还本处理方式代码
    ,deflt_flg -- 违约标志
    ,subtn_bond_flg -- 永续债标志
    ,issue_main_belong_cty_rg_cd -- 发行主体所属国家地区代码
    ,issue_rg_cd -- 发行地区代码
    ,actl_mang_land_cty_rg_cd -- 实际经营地国家和地区代码
    ,loc_gov_cls_cd -- 地方政府债分类代码
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,irevbl_guar_flg -- 不可撤销担保标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_ext_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_ext_info_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond_ext_info partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_security_extra-
insert into ${iml_schema}.prd_bond_ext_info_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,net_dlvy_flg -- 净交割标志
    ,trust_org_cd -- 托管机构代码
    ,asset_type_cd -- 资产类型代码
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,rpp_proc_way_cd -- 还本处理方式代码
    ,deflt_flg -- 违约标志
    ,subtn_bond_flg -- 永续债标志
    ,issue_main_belong_cty_rg_cd -- 发行主体所属国家地区代码
    ,issue_rg_cd -- 发行地区代码
    ,actl_mang_land_cty_rg_cd -- 实际经营地国家和地区代码
    ,loc_gov_cls_cd -- 地方政府债分类代码
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,irevbl_guar_flg -- 不可撤销担保标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,P1.ALLOW_NETTING -- 净交割标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DEPOSITORY_TRUST END -- 托管机构代码
    ,P1.ASSET_TYPE -- 资产类型代码
    ,P1.CB_STOCK_ID -- 股票代码
    ,P1.CB_STOCK_NAME -- 股票名称
    ,P1.PAYMENT_BACK_MODE -- 还本处理方式代码
    ,P1.BREACH_CONTRACT -- 违约标志
    ,P1.PERPETUAL -- 永续债标志
    ,nvl(trim(P1.ISSUER_COUNTRY_NAME),'XXX') -- 发行主体所属国家地区代码
    ,nvl(trim(P1.ISSUER_LOCATION),'XXX') -- 发行地区代码
    ,nvl(trim(p2.FIELD_VALUE),'XXX') -- 实际经营地国家和地区代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOCAL_GOVERNMENT_CLASSIFY END -- 地方政府债分类代码
    ,decode(trim(p3.field_value),'是','1','否','0','-') -- STC标志
    ,decode(trim(p4.field_value),'是','1','否','0','-') -- 优先档次标志
    ,decode(trim(p5.field_value),'是','1','否','0','-')  -- 不可撤销担保标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_security_extra' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_tbs_security_extra p1
  left join ${iol_schema}.ctms_tbs_v_security_cus_field p2
    on p2.security_code = p1.security_code
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p2.field_id = 122
  left join ${iol_schema}.ctms_tbs_v_security_cus_field p3
    on p3.security_code = p1.security_code
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p3.field_id = 501
  left join ${iol_schema}.ctms_tbs_v_security_cus_field p4
    on p4.security_code = p1.security_code
   and p4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p4.field_id = 502
  left join ${iol_schema}.ctms_tbs_v_security_cus_field p5
    on p5.security_code = p1.security_code
   and p5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p5.field_id = 141
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.depository_trust = r1.src_code_val
   and r1.sorc_sys_cd = 'CTMS'
   and r1.src_tab_en_name = 'CTMS_TBS_SECURITY_EXTRA'
   and r1.src_field_en_name = 'DEPOSITORY_TRUST'
   and r1.target_tab_en_name = 'PRD_BOND_EXT_INFO'
   and r1.target_tab_field_en_name = 'TRUST_ORG_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.local_government_classify = r2.src_code_val
   and r2.sorc_sys_cd = 'CTMS'
   and r2.src_tab_en_name = 'CTMS_TBS_SECURITY_EXTRA'
   and r2.src_field_en_name = 'LOCAL_GOVERNMENT_CLASSIFY'
   and r2.target_tab_en_name = 'PRD_BOND_EXT_INFO'
   and r2.target_tab_field_en_name = 'LOC_GOV_CLS_CD'
    where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;



commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_ext_info_ctmsf1_tm 
  	                                group by 
  	                                        bond_id
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
insert /*+ append */ into ${iml_schema}.prd_bond_ext_info_ctmsf1_ex(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,net_dlvy_flg -- 净交割标志
    ,trust_org_cd -- 托管机构代码
    ,asset_type_cd -- 资产类型代码
    ,stock_cd -- 股票代码
    ,stock_name -- 股票名称
    ,rpp_proc_way_cd -- 还本处理方式代码
    ,deflt_flg -- 违约标志
    ,subtn_bond_flg -- 永续债标志
    ,issue_main_belong_cty_rg_cd -- 发行主体所属国家地区代码
    ,issue_rg_cd -- 发行地区代码
    ,actl_mang_land_cty_rg_cd -- 实际经营地国家和地区代码
    ,loc_gov_cls_cd -- 地方政府债分类代码
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,irevbl_guar_flg -- 不可撤销担保标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.net_dlvy_flg, o.net_dlvy_flg) as net_dlvy_flg -- 净交割标志
    ,nvl(n.trust_org_cd, o.trust_org_cd) as trust_org_cd -- 托管机构代码
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.stock_cd, o.stock_cd) as stock_cd -- 股票代码
    ,nvl(n.stock_name, o.stock_name) as stock_name -- 股票名称
    ,nvl(n.rpp_proc_way_cd, o.rpp_proc_way_cd) as rpp_proc_way_cd -- 还本处理方式代码
    ,nvl(n.deflt_flg, o.deflt_flg) as deflt_flg -- 违约标志
    ,nvl(n.subtn_bond_flg, o.subtn_bond_flg) as subtn_bond_flg -- 永续债标志
    ,nvl(n.issue_main_belong_cty_rg_cd, o.issue_main_belong_cty_rg_cd) as issue_main_belong_cty_rg_cd -- 发行主体所属国家地区代码
    ,nvl(n.issue_rg_cd, o.issue_rg_cd) as issue_rg_cd -- 发行地区代码
    ,nvl(n.actl_mang_land_cty_rg_cd, o.actl_mang_land_cty_rg_cd) as actl_mang_land_cty_rg_cd -- 实际经营地国家和地区代码
    ,nvl(n.loc_gov_cls_cd, o.loc_gov_cls_cd) as loc_gov_cls_cd -- 地方政府债分类代码
    ,nvl(n.stc_flg, o.stc_flg) as stc_flg -- STC标志
    ,nvl(n.prior_level_flg, o.prior_level_flg) as prior_level_flg -- 优先档次标志
    ,nvl(n.irevbl_guar_flg, o.irevbl_guar_flg) as irevbl_guar_flg -- 不可撤销担保标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bond_id is null
                and o.lp_id is null
            ) or (
                o.net_dlvy_flg <> n.net_dlvy_flg
                or o.trust_org_cd <> n.trust_org_cd
                or o.asset_type_cd <> n.asset_type_cd
                or o.stock_cd <> n.stock_cd
                or o.stock_name <> n.stock_name
                or o.rpp_proc_way_cd <> n.rpp_proc_way_cd
                or o.deflt_flg <> n.deflt_flg
                or o.subtn_bond_flg <> n.subtn_bond_flg
                or o.issue_main_belong_cty_rg_cd <> n.issue_main_belong_cty_rg_cd
                or o.issue_rg_cd <> n.issue_rg_cd
                or o.actl_mang_land_cty_rg_cd <> n.actl_mang_land_cty_rg_cd
                or o.loc_gov_cls_cd <> n.loc_gov_cls_cd
                or o.stc_flg <> n.stc_flg
                or o.prior_level_flg <> n.prior_level_flg
                or o.irevbl_guar_flg <> n.irevbl_guar_flg
            ) or (
                 case when (
                           n.bond_id is null
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
                n.bond_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_ext_info_ctmsf1_tm n
    full join ${iml_schema}.prd_bond_ext_info_ctmsf1_bk o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond_ext_info truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond_ext_info exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.prd_bond_ext_info_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_ext_info drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_ext_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_ext_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_ext_info_ctmsf1_ex purge;
drop table ${iml_schema}.prd_bond_ext_info_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_ext_info', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);