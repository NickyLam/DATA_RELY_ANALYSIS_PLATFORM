/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_finc_prod_famsf2
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
drop table ${iml_schema}.prd_am_finc_prod_famsf2_tm purge;
drop table ${iml_schema}.prd_am_finc_prod_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_am_finc_prod add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_finc_prod modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_finc_prod_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_finc_prod partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_finc_prod_famsf2_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,finc_prod_id -- 理财产品编号
    ,issue_curr_cd -- 发行币种代码
    ,tran_caln_cd -- 交易日历代码
    ,coll_way_cd -- 募集方式代码
    ,oper_mode_cd -- 运作模式代码
    ,entr_way_cd -- 委托方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,super_prod_id -- 上级产品编号
    ,sell_dept_id -- 销售部门编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,inv_port_id -- 投资组合编号
    ,prod_rgst_code -- 产品登记编码
    ,ped_prod_flg -- 周期型产品标志
    ,layered_flg -- 分层标志
    ,layered_type_cd -- 分层类型代码
    ,invest_char_type_cd -- 投资性质类型代码
    ,prft_type_cd -- 收益类型代码
    ,issue_status_cd -- 发行状态代码
    ,cash_mgmt_flg -- 现金管理标志
    ,risk_level_cd -- 风险等级代码
    ,proc_mode_cd -- 处理模式代码
    ,exlus_prod_flg -- 专属产品标志
    ,ped_days -- 周期天数
    ,prod_mgr_name -- 产品经理名称
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,tenor_type_cd -- 期限类型代码
    ,prod_seri_cd -- 产品系列代码
    ,prod_cls_cd -- 产品分类代码
    ,exlus_ibank_org_id -- 专属同业机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_finc_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_am_finc_prod_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_am_finc_prod partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_fin_product-1
insert into ${iml_schema}.prd_am_finc_prod_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,finc_prod_id -- 理财产品编号
    ,issue_curr_cd -- 发行币种代码
    ,tran_caln_cd -- 交易日历代码
    ,coll_way_cd -- 募集方式代码
    ,oper_mode_cd -- 运作模式代码
    ,entr_way_cd -- 委托方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,super_prod_id -- 上级产品编号
    ,sell_dept_id -- 销售部门编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,inv_port_id -- 投资组合编号
    ,prod_rgst_code -- 产品登记编码
    ,ped_prod_flg -- 周期型产品标志
    ,layered_flg -- 分层标志
    ,layered_type_cd -- 分层类型代码
    ,invest_char_type_cd -- 投资性质类型代码
    ,prft_type_cd -- 收益类型代码
    ,issue_status_cd -- 发行状态代码
    ,cash_mgmt_flg -- 现金管理标志
    ,risk_level_cd -- 风险等级代码
    ,proc_mode_cd -- 处理模式代码
    ,exlus_prod_flg -- 专属产品标志
    ,ped_days -- 周期天数
    ,prod_mgr_name -- 产品经理名称
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,tenor_type_cd -- 期限类型代码
    ,prod_seri_cd -- 产品系列代码
    ,prod_cls_cd -- 产品分类代码
    ,exlus_ibank_org_id -- 专属同业机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223002'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,case when P2.PROFIT_FLAG in ('01','02') and substr(trim(p3.investor_type),1,2) in ('01','03','05') then '101030101'  -- 个人保本理财存款
     when P2.PROFIT_FLAG in ('01','02') and substr(trim(p3.investor_type),1,2) in ('02') then '103030101'  -- 单位保本理财存款
     when P2.PROFIT_FLAG in ('03') and substr(trim(p3.investor_type),1,2) in ('01','03','05') then '502010101'  -- 个人非保本理财
     when P2.PROFIT_FLAG in ('03') and substr(trim(p3.investor_type),1,2) in ('02') then '502010201'  -- 对公非保本理财
     when P2.PROFIT_FLAG in ('03') and substr(trim(p3.investor_type),1,2) in ('04') then '502010301'  -- 同业非保本理财
     else ' '
END -- 标准产品编号
    ,P1.FINPROD_ID -- 源产品编号
    ,P1.FINPROD_TYPE2 -- 产品类别代码
    ,P1.FINPROD_ABBR -- 产品简称
    ,P1.FINPROD_NAME -- 产品全称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFIT_TYPE END -- 收益模式代码
    ,P1.FINPROD_MARKET_ID -- 理财产品编号
    ,NVL(TRIM(P1.CCY),'-') -- 发行币种代码
    ,NVL(TRIM(P1.CALENDAR_ID),'-') -- 交易日历代码
    ,NVL(TRIM(P1.ISSUE_TYPE),'0') -- 募集方式代码
    ,NVL(TRIM(P1.OPERATION_TYPE),'00') -- 运作模式代码
    ,NVL(TRIM(P1.ENTRUST_TYPE),'00') -- 委托方式代码
    ,P1.ENTRUSTER -- 委托人编号
    ,P1.TRUSTEE_ID -- 托管人编号
    ,P1.VDATE -- 起息日期
    ,P1.MDATE -- 到期日期
    ,P1.TERM_DAYS -- 产品期限
    ,P1.ACTMDATE -- 实际到期日期
    ,P1.LIQUIDATION_DATE -- 清盘日期
    ,CASE WHEN P1.IS_SUS ='N' THEN '0' WHEN P1.IS_SUS ='Y' THEN '1' ELSE '-' END -- 永续标志
    ,P1.SUSTAINABLE_REMARK -- 永续条款
    ,P1.P_FINPROD_ID -- 上级产品编号
    ,replace(replace(replace(p2.sale_department,'01','800924'),'02','800926'),'03','899001') -- 销售部门编号
    ,P2.PUR_SPEED -- 申购确认期限
    ,P2.RED_SPEED -- 赎回确认期限
    ,P2.PORTFOLIO_ID -- 投资组合编号
    ,P2.PROD_REGIST_CODE -- 产品登记编码
    ,CASE WHEN P2.IS_CYCLE ='N' THEN '0' WHEN P2.IS_CYCLE ='Y' THEN '1' ELSE '-' END -- 周期型产品标志
    ,CASE WHEN P2.IS_LAY ='N' THEN '0' WHEN P2.IS_LAY ='Y' THEN '1' ELSE '-' END -- 分层标志
    ,NVL(TRIM(P2.LAY_TYPE),'00') -- 分层类型代码
    ,NVL(TRIM(P2.INVEST_NATURE),'-') -- 投资性质类型代码
    ,NVL(TRIM(P2.PROFIT_FLAG),'00') -- 收益类型代码
    ,NVL(TRIM(P2.ISSUE_STATUS),'00') -- 发行状态代码
    ,CASE WHEN P2.IS_CASH_MANAGE ='N' THEN '0' WHEN P2.IS_CASH_MANAGE ='Y' THEN '1' ELSE '-' END -- 现金管理标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P2.RISK_LEVEL END -- 风险等级代码
    ,P2.DEAL_MODE -- 处理模式代码
    ,P2.IS_EXCLUSIVE -- 专属产品标志
    ,P2.INVESTMENT_CYCLE -- 周期天数
    ,P2.PROD_MANAGER -- 产品经理名称
    ,P1.CREATE_TIME -- 原创建时间
    ,P1.UPDATE_TIME -- 原更新时间
    ,NVL(TRIM(P2.TERM_TYPE),'00') -- 期限类型代码
    ,NVL(TRIM(P4.PROD_SERIES),'-') -- 产品系列代码
    ,CASE WHEN TRIM(P4.PROD_CLASS) IS NULL THEN '-'
     WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P4.PROD_CLASS END -- 产品分类代码
    ,P4.SAME_ORG -- 专属同业机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product p1
    left join ${iol_schema}.fams_fin_product_add p2 on p1.finprod_id=p2.finprod_id
 and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_prd_sale_param p3 on 'F16_'||p1.finprod_market_id=p3.finprod_id 
  and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_pa_fin_product p4 on p1.finprod_id=p4.finprod_id
 and p4.start_dt <= to_date('${batch_date}','yyyymmdd') and p4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFIT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'PROFIT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_FINC_PROD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P2.RISK_LEVEL= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT_ADD'
        AND R4.SRC_FIELD_EN_NAME= 'RISK_LEVEL'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_AM_FINC_PROD'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P4.PROD_CLASS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_PA_FIN_PRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'PROD_CLASS'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_FINC_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_CLS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.FINPROD_TYPE2 in ('F16','F24','F26')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_am_finc_prod_famsf2_tm 
  	                                group by 
  	                                        prod_id
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
insert /*+ append */ into ${iml_schema}.prd_am_finc_prod_famsf2_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,finc_prod_id -- 理财产品编号
    ,issue_curr_cd -- 发行币种代码
    ,tran_caln_cd -- 交易日历代码
    ,coll_way_cd -- 募集方式代码
    ,oper_mode_cd -- 运作模式代码
    ,entr_way_cd -- 委托方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,super_prod_id -- 上级产品编号
    ,sell_dept_id -- 销售部门编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,inv_port_id -- 投资组合编号
    ,prod_rgst_code -- 产品登记编码
    ,ped_prod_flg -- 周期型产品标志
    ,layered_flg -- 分层标志
    ,layered_type_cd -- 分层类型代码
    ,invest_char_type_cd -- 投资性质类型代码
    ,prft_type_cd -- 收益类型代码
    ,issue_status_cd -- 发行状态代码
    ,cash_mgmt_flg -- 现金管理标志
    ,risk_level_cd -- 风险等级代码
    ,proc_mode_cd -- 处理模式代码
    ,exlus_prod_flg -- 专属产品标志
    ,ped_days -- 周期天数
    ,prod_mgr_name -- 产品经理名称
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,tenor_type_cd -- 期限类型代码
    ,prod_seri_cd -- 产品系列代码
    ,prod_cls_cd -- 产品分类代码
    ,exlus_ibank_org_id -- 专属同业机构编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.src_prod_id, o.src_prod_id) as src_prod_id -- 源产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.prod_fname, o.prod_fname) as prod_fname -- 产品全称
    ,nvl(n.prft_mode_cd, o.prft_mode_cd) as prft_mode_cd -- 收益模式代码
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.issue_curr_cd, o.issue_curr_cd) as issue_curr_cd -- 发行币种代码
    ,nvl(n.tran_caln_cd, o.tran_caln_cd) as tran_caln_cd -- 交易日历代码
    ,nvl(n.coll_way_cd, o.coll_way_cd) as coll_way_cd -- 募集方式代码
    ,nvl(n.oper_mode_cd, o.oper_mode_cd) as oper_mode_cd -- 运作模式代码
    ,nvl(n.entr_way_cd, o.entr_way_cd) as entr_way_cd -- 委托方式代码
    ,nvl(n.csner_id, o.csner_id) as csner_id -- 委托人编号
    ,nvl(n.trustee_id, o.trustee_id) as trustee_id -- 托管人编号
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.prod_tenor, o.prod_tenor) as prod_tenor -- 产品期限
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.liqd_dt, o.liqd_dt) as liqd_dt -- 清盘日期
    ,nvl(n.subtn_flg, o.subtn_flg) as subtn_flg -- 永续标志
    ,nvl(n.subtn_claus, o.subtn_claus) as subtn_claus -- 永续条款
    ,nvl(n.super_prod_id, o.super_prod_id) as super_prod_id -- 上级产品编号
    ,nvl(n.sell_dept_id, o.sell_dept_id) as sell_dept_id -- 销售部门编号
    ,nvl(n.purch_cfm_tenor, o.purch_cfm_tenor) as purch_cfm_tenor -- 申购确认期限
    ,nvl(n.redem_cfm_tenor, o.redem_cfm_tenor) as redem_cfm_tenor -- 赎回确认期限
    ,nvl(n.inv_port_id, o.inv_port_id) as inv_port_id -- 投资组合编号
    ,nvl(n.prod_rgst_code, o.prod_rgst_code) as prod_rgst_code -- 产品登记编码
    ,nvl(n.ped_prod_flg, o.ped_prod_flg) as ped_prod_flg -- 周期型产品标志
    ,nvl(n.layered_flg, o.layered_flg) as layered_flg -- 分层标志
    ,nvl(n.layered_type_cd, o.layered_type_cd) as layered_type_cd -- 分层类型代码
    ,nvl(n.invest_char_type_cd, o.invest_char_type_cd) as invest_char_type_cd -- 投资性质类型代码
    ,nvl(n.prft_type_cd, o.prft_type_cd) as prft_type_cd -- 收益类型代码
    ,nvl(n.issue_status_cd, o.issue_status_cd) as issue_status_cd -- 发行状态代码
    ,nvl(n.cash_mgmt_flg, o.cash_mgmt_flg) as cash_mgmt_flg -- 现金管理标志
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.proc_mode_cd, o.proc_mode_cd) as proc_mode_cd -- 处理模式代码
    ,nvl(n.exlus_prod_flg, o.exlus_prod_flg) as exlus_prod_flg -- 专属产品标志
    ,nvl(n.ped_days, o.ped_days) as ped_days -- 周期天数
    ,nvl(n.prod_mgr_name, o.prod_mgr_name) as prod_mgr_name -- 产品经理名称
    ,nvl(n.init_create_tm, o.init_create_tm) as init_create_tm -- 原创建时间
    ,nvl(n.init_update_tm, o.init_update_tm) as init_update_tm -- 原更新时间
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.prod_seri_cd, o.prod_seri_cd) as prod_seri_cd -- 产品系列代码
    ,nvl(n.prod_cls_cd, o.prod_cls_cd) as prod_cls_cd -- 产品分类代码
    ,nvl(n.exlus_ibank_org_id, o.exlus_ibank_org_id) as exlus_ibank_org_id -- 专属同业机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.std_prod_id <> n.std_prod_id
                or o.src_prod_id <> n.src_prod_id
                or o.prod_cate_cd <> n.prod_cate_cd
                or o.prod_abbr <> n.prod_abbr
                or o.prod_fname <> n.prod_fname
                or o.prft_mode_cd <> n.prft_mode_cd
                or o.finc_prod_id <> n.finc_prod_id
                or o.issue_curr_cd <> n.issue_curr_cd
                or o.tran_caln_cd <> n.tran_caln_cd
                or o.coll_way_cd <> n.coll_way_cd
                or o.oper_mode_cd <> n.oper_mode_cd
                or o.entr_way_cd <> n.entr_way_cd
                or o.csner_id <> n.csner_id
                or o.trustee_id <> n.trustee_id
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.prod_tenor <> n.prod_tenor
                or o.actl_exp_dt <> n.actl_exp_dt
                or o.liqd_dt <> n.liqd_dt
                or o.subtn_flg <> n.subtn_flg
                or o.subtn_claus <> n.subtn_claus
                or o.super_prod_id <> n.super_prod_id
                or o.sell_dept_id <> n.sell_dept_id
                or o.purch_cfm_tenor <> n.purch_cfm_tenor
                or o.redem_cfm_tenor <> n.redem_cfm_tenor
                or o.inv_port_id <> n.inv_port_id
                or o.prod_rgst_code <> n.prod_rgst_code
                or o.ped_prod_flg <> n.ped_prod_flg
                or o.layered_flg <> n.layered_flg
                or o.layered_type_cd <> n.layered_type_cd
                or o.invest_char_type_cd <> n.invest_char_type_cd
                or o.prft_type_cd <> n.prft_type_cd
                or o.issue_status_cd <> n.issue_status_cd
                or o.cash_mgmt_flg <> n.cash_mgmt_flg
                or o.risk_level_cd <> n.risk_level_cd
                or o.proc_mode_cd <> n.proc_mode_cd
                or o.exlus_prod_flg <> n.exlus_prod_flg
                or o.ped_days <> n.ped_days
                or o.prod_mgr_name <> n.prod_mgr_name
                or o.init_create_tm <> n.init_create_tm
                or o.init_update_tm <> n.init_update_tm
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.prod_seri_cd <> n.prod_seri_cd
                or o.prod_cls_cd <> n.prod_cls_cd
                or o.exlus_ibank_org_id <> n.exlus_ibank_org_id
            ) or (
                 case when (
                           n.prod_id is null
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
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_finc_prod_famsf2_tm n
    full join ${iml_schema}.prd_am_finc_prod_famsf2_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_am_finc_prod truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_am_finc_prod exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.prd_am_finc_prod_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_am_finc_prod drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_finc_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_finc_prod_famsf2_tm purge;
drop table ${iml_schema}.prd_am_finc_prod_famsf2_ex purge;
drop table ${iml_schema}.prd_am_finc_prod_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_finc_prod', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);