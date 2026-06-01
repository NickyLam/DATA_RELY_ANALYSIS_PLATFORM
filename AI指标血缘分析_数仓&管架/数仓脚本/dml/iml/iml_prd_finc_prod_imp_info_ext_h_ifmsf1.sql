/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_finc_prod_imp_info_ext_h_ifmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_ext_h partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_ext_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_ext_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc_prod_imp_info_ext_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbprddailyext-
insert into ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm(
    issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    ${iml_schema}.DATEFORMAT_MIN(P1.ISS_DATE) -- 发布日期
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CFM_DATE) -- 确认日期
    ,P1.PRD_CODE -- 产品代码
    ,P1.NAV_FLAG -- 净值类型代码
    ,NVL(TRIM(P1.PERIODIC_STATUS),'-') -- 定期定额状态代码
    ,NVL(TRIM(P1.CHG_AGC_STATUS),'-') -- 转托管状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.ANNOUNC_FLAG -- 公告标志
    ,NVL(TRIM(P1.PISS_TYPE),'-') -- 个人发行方式代码
    ,NVL(TRIM(P1.OISS_TYPE),'-') -- 机构发行方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.DIVIDENT_DATE) -- 分红日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.REG_DATE) -- 权益登记日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.XR_DATE) -- 除权日期
    ,NVL(TRIM(P1.SUB_TYPE),'-') -- 认购方式代码
    ,NVL(TRIM(P1.TRANSFEE_TYPE),'-') -- 收费方式代码
    ,P1.YEARINCOME_RATE -- 货币基金年收益率
    ,P1.BREACH_RED_FLAG -- 允许违约赎回标志
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.QUARTER_RATE -- 季度年化收益率
    ,P1.QUARTER_RATE_FLAG -- 季度年化收益率正负代码
    ,P1.CYCLE_RATE -- 周期收益率
    ,P1.CYCLE_RATE_FLAG -- 周期收益率正负代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.NAV_DATE) -- 资管净值日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbprddailyext' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbprddailyext p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURR_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBPRDDAILYEXT'
        AND R1.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FINC_PROD_IMP_INFO_EXT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm 
  	                                group by 
  	                                        issue_dt
  	                                        ,lp_id
  	                                        ,cfm_dt
  	                                        ,prod_cd
  	                                        ,nv_type_cd
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发布日期
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.prod_cd, o.prod_cd) as prod_cd -- 产品代码
    ,nvl(n.nv_type_cd, o.nv_type_cd) as nv_type_cd -- 净值类型代码
    ,nvl(n.reg_quota_status_cd, o.reg_quota_status_cd) as reg_quota_status_cd -- 定期定额状态代码
    ,nvl(n.turn_trust_status_cd, o.turn_trust_status_cd) as turn_trust_status_cd -- 转托管状态代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.affi_flg, o.affi_flg) as affi_flg -- 公告标志
    ,nvl(n.indv_issue_way_cd, o.indv_issue_way_cd) as indv_issue_way_cd -- 个人发行方式代码
    ,nvl(n.org_issue_way_cd, o.org_issue_way_cd) as org_issue_way_cd -- 机构发行方式代码
    ,nvl(n.divd_dt, o.divd_dt) as divd_dt -- 分红日期
    ,nvl(n.eqty_rgst_dt, o.eqty_rgst_dt) as eqty_rgst_dt -- 权益登记日期
    ,nvl(n.ex_righ_dt, o.ex_righ_dt) as ex_righ_dt -- 除权日期
    ,nvl(n.subscr_way_cd, o.subscr_way_cd) as subscr_way_cd -- 认购方式代码
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.curr_fund_year_yld_rat, o.curr_fund_year_yld_rat) as curr_fund_year_yld_rat -- 货币基金年收益率
    ,nvl(n.allow_deflt_redem_flg, o.allow_deflt_redem_flg) as allow_deflt_redem_flg -- 允许违约赎回标志
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.quar_aual_yld, o.quar_aual_yld) as quar_aual_yld -- 季度年化收益率
    ,nvl(n.quar_aual_yld_pm_cd, o.quar_aual_yld_pm_cd) as quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,nvl(n.ped_yld_rat, o.ped_yld_rat) as ped_yld_rat -- 周期收益率
    ,nvl(n.ped_yld_rat_pm_cd, o.ped_yld_rat_pm_cd) as ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,nvl(n.am_nv_dt, o.am_nv_dt) as am_nv_dt -- 资管净值日期
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_cd is null
            and n.nv_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_cd is null
            and n.nv_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.issue_dt is null
            and n.lp_id is null
            and n.cfm_dt is null
            and n.prod_cd is null
            and n.nv_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.issue_dt = n.issue_dt
            and o.lp_id = n.lp_id
            and o.cfm_dt = n.cfm_dt
            and o.prod_cd = n.prod_cd
            and o.nv_type_cd = n.nv_type_cd
where (
        o.issue_dt is null
        and o.lp_id is null
        and o.cfm_dt is null
        and o.prod_cd is null
        and o.nv_type_cd is null
    )
    or (
        n.issue_dt is null
        and n.lp_id is null
        and n.cfm_dt is null
        and n.prod_cd is null
        and n.nv_type_cd is null
    )
    or (
        o.reg_quota_status_cd <> n.reg_quota_status_cd
        or o.turn_trust_status_cd <> n.turn_trust_status_cd
        or o.curr_cd <> n.curr_cd
        or o.affi_flg <> n.affi_flg
        or o.indv_issue_way_cd <> n.indv_issue_way_cd
        or o.org_issue_way_cd <> n.org_issue_way_cd
        or o.divd_dt <> n.divd_dt
        or o.eqty_rgst_dt <> n.eqty_rgst_dt
        or o.ex_righ_dt <> n.ex_righ_dt
        or o.subscr_way_cd <> n.subscr_way_cd
        or o.charge_way_cd <> n.charge_way_cd
        or o.curr_fund_year_yld_rat <> n.curr_fund_year_yld_rat
        or o.allow_deflt_redem_flg <> n.allow_deflt_redem_flg
        or o.ta_cd <> n.ta_cd
        or o.quar_aual_yld <> n.quar_aual_yld
        or o.quar_aual_yld_pm_cd <> n.quar_aual_yld_pm_cd
        or o.ped_yld_rat <> n.ped_yld_rat
        or o.ped_yld_rat_pm_cd <> n.ped_yld_rat_pm_cd
        or o.am_nv_dt <> n.am_nv_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op(
            issue_dt -- 发布日期
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,prod_cd -- 产品代码
    ,nv_type_cd -- 净值类型代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,curr_cd -- 币种代码
    ,affi_flg -- 公告标志
    ,indv_issue_way_cd -- 个人发行方式代码
    ,org_issue_way_cd -- 机构发行方式代码
    ,divd_dt -- 分红日期
    ,eqty_rgst_dt -- 权益登记日期
    ,ex_righ_dt -- 除权日期
    ,subscr_way_cd -- 认购方式代码
    ,charge_way_cd -- 收费方式代码
    ,curr_fund_year_yld_rat -- 货币基金年收益率
    ,allow_deflt_redem_flg -- 允许违约赎回标志
    ,ta_cd -- TA代码
    ,quar_aual_yld -- 季度年化收益率
    ,quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,ped_yld_rat -- 周期收益率
    ,ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,am_nv_dt -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.issue_dt -- 发布日期
    ,o.lp_id -- 法人编号
    ,o.cfm_dt -- 确认日期
    ,o.prod_cd -- 产品代码
    ,o.nv_type_cd -- 净值类型代码
    ,o.reg_quota_status_cd -- 定期定额状态代码
    ,o.turn_trust_status_cd -- 转托管状态代码
    ,o.curr_cd -- 币种代码
    ,o.affi_flg -- 公告标志
    ,o.indv_issue_way_cd -- 个人发行方式代码
    ,o.org_issue_way_cd -- 机构发行方式代码
    ,o.divd_dt -- 分红日期
    ,o.eqty_rgst_dt -- 权益登记日期
    ,o.ex_righ_dt -- 除权日期
    ,o.subscr_way_cd -- 认购方式代码
    ,o.charge_way_cd -- 收费方式代码
    ,o.curr_fund_year_yld_rat -- 货币基金年收益率
    ,o.allow_deflt_redem_flg -- 允许违约赎回标志
    ,o.ta_cd -- TA代码
    ,o.quar_aual_yld -- 季度年化收益率
    ,o.quar_aual_yld_pm_cd -- 季度年化收益率正负代码
    ,o.ped_yld_rat -- 周期收益率
    ,o.ped_yld_rat_pm_cd -- 周期收益率正负代码
    ,o.am_nv_dt -- 资管净值日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_bk o
    left join ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op n
        on
            o.issue_dt = n.issue_dt
            and o.lp_id = n.lp_id
            and o.cfm_dt = n.cfm_dt
            and o.prod_cd = n.prod_cd
            and o.nv_type_cd = n.nv_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl d
        on
            o.issue_dt = d.issue_dt
            and o.lp_id = d.lp_id
            and o.cfm_dt = d.cfm_dt
            and o.prod_cd = d.prod_cd
            and o.nv_type_cd = d.nv_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_finc_prod_imp_info_ext_h;
--alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_finc_prod_imp_info_ext_h') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl;
alter table ${iml_schema}.prd_finc_prod_imp_info_ext_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_finc_prod_imp_info_ext_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_finc_prod_imp_info_ext_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_finc_prod_imp_info_ext_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
