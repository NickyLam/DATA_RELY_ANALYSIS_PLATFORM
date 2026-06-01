/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_nv_type_am_famsf1
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
drop table ${iml_schema}.prd_nv_type_am_famsf1_tm purge;
drop table ${iml_schema}.prd_nv_type_am_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_nv_type_am add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_nv_type_am modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_nv_type_am_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_nv_type_am partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_nv_type_am_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,edit_num -- 版本号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,trust_bank_id -- 托管银行编号
    ,risk_level_cd -- 风险等级代码
    ,finc_mgr_id -- 理财经理编号
    ,curr_cd -- 币种代码
    ,divd_way_cd -- 分红方式代码
    ,prod_acct_id -- 产品账户编号
    ,move_way_cd -- 运行方式代码
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,exp_cash_dt -- 到期兑付日期
    ,coll_way_cd -- 募集方式代码
    ,sell_chn_cd -- 销售渠道代码
    ,subscr_sp_amt -- 认购起点金额
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,supp_amt -- 追加金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,cap_coll_dt -- 资金归集日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,sell_obj_cd -- 销售对象代码
    ,level1_cls_cd -- 一级分类代码
    ,level2_cls_cd -- 二级分类代码
    ,level3_cls_cd -- 三级分类代码
    ,prod_status_cd -- 产品状态代码
    ,issue_status_cd -- 发行状态代码
    ,prod_rgst_code -- 产品登记编码
    ,allow_redem_flg -- 允许赎回标志
    ,prod_pd -- 产品期次
    ,invtor_type_cd -- 投资者类型代码
    ,sell_rg_cd -- 销售地区代码
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,int_accr_base_cd -- 计息基准代码
    ,lot_mtsa_proc_way_cd -- 份额尾数处理方式代码
    ,nv_mtsa_proc_way_cd -- 单位净值尾数处理方式代码
    ,trust_curr_int_provi_flg -- 托管活期利息计提标志
    ,curr_int_provi_end_dt -- 活期利息计提结束日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_nv_type_am
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_nv_type_am_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_nv_type_am partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_prd_info_n-
insert into ${iml_schema}.prd_nv_type_am_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,edit_num -- 版本号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,trust_bank_id -- 托管银行编号
    ,risk_level_cd -- 风险等级代码
    ,finc_mgr_id -- 理财经理编号
    ,curr_cd -- 币种代码
    ,divd_way_cd -- 分红方式代码
    ,prod_acct_id -- 产品账户编号
    ,move_way_cd -- 运行方式代码
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,exp_cash_dt -- 到期兑付日期
    ,coll_way_cd -- 募集方式代码
    ,sell_chn_cd -- 销售渠道代码
    ,subscr_sp_amt -- 认购起点金额
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,supp_amt -- 追加金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,cap_coll_dt -- 资金归集日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,sell_obj_cd -- 销售对象代码
    ,level1_cls_cd -- 一级分类代码
    ,level2_cls_cd -- 二级分类代码
    ,level3_cls_cd -- 三级分类代码
    ,prod_status_cd -- 产品状态代码
    ,issue_status_cd -- 发行状态代码
    ,prod_rgst_code -- 产品登记编码
    ,allow_redem_flg -- 允许赎回标志
    ,prod_pd -- 产品期次
    ,invtor_type_cd -- 投资者类型代码
    ,sell_rg_cd -- 销售地区代码
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,int_accr_base_cd -- 计息基准代码
    ,lot_mtsa_proc_way_cd -- 份额尾数处理方式代码
    ,nv_mtsa_proc_way_cd -- 单位净值尾数处理方式代码
    ,trust_curr_int_provi_flg -- 托管活期利息计提标志
    ,curr_int_provi_end_dt -- 活期利息计提结束日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.PRODID) -- 产品编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.VERSION) -- 版本号
    ,P1.PRODCODE -- 用户产品编号
    ,P1.PRODSIMPLENAME -- 产品简称
    ,P1.PRODNAME -- 产品名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFITFLAG END -- 收益类型代码
    ,P1.TRUBANKID -- 托管银行编号
    ,P1.RISKLEVEL -- 风险等级代码
    ,P1.MANAGER -- 理财经理编号
    ,P1.CURRENCY -- 币种代码
    ,P1.BONUSMODE -- 分红方式代码
    ,P1.PRODCODE -- 产品账户编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ISSUETYPE END -- 运行方式代码
    ,P1.TERMINATIONFLAG -- 允许提前终止标志
    ,P1.VDATE -- 产品起息日期
    ,P1.MDATE -- 产品到期日期
    ,P1.SDATE -- 到期兑付日期
    ,P1.RAISEMODE -- 募集方式代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.SALETARGET END -- 销售渠道代码
    ,P1.SUBSCRIBEBASE -- 认购起点金额
    ,P1.RAISEAMTMAX -- 募集上限金额
    ,P1.RAISEAMTMIN -- 募集下限金额
    ,P1.ADDITIONALAMT -- 追加金额
    ,P1.RAISESTARTDATE -- 募集开始日期
    ,P1.RAISEENDDATE -- 募集结束日期
    ,P1.CASHCOLLECTDATE -- 资金归集日期
    ,P1.TERM -- 期限
    ,P1.TERMTYPE -- 期限类型代码
    ,P1.SALEOBJECT -- 销售对象代码
    ,P1.PRODSERIES -- 一级分类代码
    ,P1.PRODSERIES2 -- 二级分类代码
    ,P1.PRODSERIES3 -- 三级分类代码
    ,P1.STATUS -- 产品状态代码
    ,nvl(trim(P1.ISSUESTATUS),'-') -- 发行状态代码
    ,P1.PROREGISTCODE -- 产品登记编码
    ,P1.REDFLAG -- 允许赎回标志
    ,P1.PRDPERIOD -- 产品期次
    ,P1.INVESTORTYPE -- 投资者类型代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SALESAREA END -- 销售地区代码
    ,P1.TMDATE -- 实际到期日期
    ,P1.WMDATE -- 清盘日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BASIS END -- 计息基准代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DIGITTYPE END -- 份额尾数处理方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.VALUETYPE END -- 单位净值尾数处理方式代码
    ,P1.CURDEPOFLAG -- 托管活期利息计提标志
    ,P1.CURRENTDATE -- 活期利息计提结束日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_prd_info_n' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_prd_info_n p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFITFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R1.SRC_FIELD_EN_NAME= 'PROFITFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ISSUETYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R3.SRC_FIELD_EN_NAME= 'ISSUETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MOVE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SALETARGET = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'FAMS'
        AND R7.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R7.SRC_FIELD_EN_NAME= 'SALETARGET'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'SELL_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SALESAREA = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R6.SRC_FIELD_EN_NAME= 'SALESAREA'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'SELL_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BASIS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R2.SRC_FIELD_EN_NAME= 'BASIS'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DIGITTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R4.SRC_FIELD_EN_NAME= 'DIGITTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'LOT_MTSA_PROC_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.VALUETYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_PRD_INFO_N'
        AND R5.SRC_FIELD_EN_NAME= 'VALUETYPE'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_NV_TYPE_AM'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'NV_MTSA_PROC_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_nv_type_am_famsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,edit_num
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
insert /*+ append */ into ${iml_schema}.prd_nv_type_am_famsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,edit_num -- 版本号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,trust_bank_id -- 托管银行编号
    ,risk_level_cd -- 风险等级代码
    ,finc_mgr_id -- 理财经理编号
    ,curr_cd -- 币种代码
    ,divd_way_cd -- 分红方式代码
    ,prod_acct_id -- 产品账户编号
    ,move_way_cd -- 运行方式代码
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,exp_cash_dt -- 到期兑付日期
    ,coll_way_cd -- 募集方式代码
    ,sell_chn_cd -- 销售渠道代码
    ,subscr_sp_amt -- 认购起点金额
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,supp_amt -- 追加金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,cap_coll_dt -- 资金归集日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,sell_obj_cd -- 销售对象代码
    ,level1_cls_cd -- 一级分类代码
    ,level2_cls_cd -- 二级分类代码
    ,level3_cls_cd -- 三级分类代码
    ,prod_status_cd -- 产品状态代码
    ,issue_status_cd -- 发行状态代码
    ,prod_rgst_code -- 产品登记编码
    ,allow_redem_flg -- 允许赎回标志
    ,prod_pd -- 产品期次
    ,invtor_type_cd -- 投资者类型代码
    ,sell_rg_cd -- 销售地区代码
    ,actl_exp_dt -- 实际到期日期
    ,liqd_dt -- 清盘日期
    ,int_accr_base_cd -- 计息基准代码
    ,lot_mtsa_proc_way_cd -- 份额尾数处理方式代码
    ,nv_mtsa_proc_way_cd -- 单位净值尾数处理方式代码
    ,trust_curr_int_provi_flg -- 托管活期利息计提标志
    ,curr_int_provi_end_dt -- 活期利息计提结束日期
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
    ,nvl(n.edit_num, o.edit_num) as edit_num -- 版本号
    ,nvl(n.user_prod_id, o.user_prod_id) as user_prod_id -- 用户产品编号
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prft_type_cd, o.prft_type_cd) as prft_type_cd -- 收益类型代码
    ,nvl(n.trust_bank_id, o.trust_bank_id) as trust_bank_id -- 托管银行编号
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.finc_mgr_id, o.finc_mgr_id) as finc_mgr_id -- 理财经理编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.prod_acct_id, o.prod_acct_id) as prod_acct_id -- 产品账户编号
    ,nvl(n.move_way_cd, o.move_way_cd) as move_way_cd -- 运行方式代码
    ,nvl(n.allow_adv_termnt_flg, o.allow_adv_termnt_flg) as allow_adv_termnt_flg -- 允许提前终止标志
    ,nvl(n.prod_value_dt, o.prod_value_dt) as prod_value_dt -- 产品起息日期
    ,nvl(n.prod_exp_dt, o.prod_exp_dt) as prod_exp_dt -- 产品到期日期
    ,nvl(n.exp_cash_dt, o.exp_cash_dt) as exp_cash_dt -- 到期兑付日期
    ,nvl(n.coll_way_cd, o.coll_way_cd) as coll_way_cd -- 募集方式代码
    ,nvl(n.sell_chn_cd, o.sell_chn_cd) as sell_chn_cd -- 销售渠道代码
    ,nvl(n.subscr_sp_amt, o.subscr_sp_amt) as subscr_sp_amt -- 认购起点金额
    ,nvl(n.coll_uplmi_amt, o.coll_uplmi_amt) as coll_uplmi_amt -- 募集上限金额
    ,nvl(n.coll_lolmi_amt, o.coll_lolmi_amt) as coll_lolmi_amt -- 募集下限金额
    ,nvl(n.supp_amt, o.supp_amt) as supp_amt -- 追加金额
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.cap_coll_dt, o.cap_coll_dt) as cap_coll_dt -- 资金归集日期
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.sell_obj_cd, o.sell_obj_cd) as sell_obj_cd -- 销售对象代码
    ,nvl(n.level1_cls_cd, o.level1_cls_cd) as level1_cls_cd -- 一级分类代码
    ,nvl(n.level2_cls_cd, o.level2_cls_cd) as level2_cls_cd -- 二级分类代码
    ,nvl(n.level3_cls_cd, o.level3_cls_cd) as level3_cls_cd -- 三级分类代码
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.issue_status_cd, o.issue_status_cd) as issue_status_cd -- 发行状态代码
    ,nvl(n.prod_rgst_code, o.prod_rgst_code) as prod_rgst_code -- 产品登记编码
    ,nvl(n.allow_redem_flg, o.allow_redem_flg) as allow_redem_flg -- 允许赎回标志
    ,nvl(n.prod_pd, o.prod_pd) as prod_pd -- 产品期次
    ,nvl(n.invtor_type_cd, o.invtor_type_cd) as invtor_type_cd -- 投资者类型代码
    ,nvl(n.sell_rg_cd, o.sell_rg_cd) as sell_rg_cd -- 销售地区代码
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.liqd_dt, o.liqd_dt) as liqd_dt -- 清盘日期
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.lot_mtsa_proc_way_cd, o.lot_mtsa_proc_way_cd) as lot_mtsa_proc_way_cd -- 份额尾数处理方式代码
    ,nvl(n.nv_mtsa_proc_way_cd, o.nv_mtsa_proc_way_cd) as nv_mtsa_proc_way_cd -- 单位净值尾数处理方式代码
    ,nvl(n.trust_curr_int_provi_flg, o.trust_curr_int_provi_flg) as trust_curr_int_provi_flg -- 托管活期利息计提标志
    ,nvl(n.curr_int_provi_end_dt, o.curr_int_provi_end_dt) as curr_int_provi_end_dt -- 活期利息计提结束日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.edit_num is null
            ) or (
                o.user_prod_id <> n.user_prod_id
                or o.prod_abbr <> n.prod_abbr
                or o.prod_name <> n.prod_name
                or o.prft_type_cd <> n.prft_type_cd
                or o.trust_bank_id <> n.trust_bank_id
                or o.risk_level_cd <> n.risk_level_cd
                or o.finc_mgr_id <> n.finc_mgr_id
                or o.curr_cd <> n.curr_cd
                or o.divd_way_cd <> n.divd_way_cd
                or o.prod_acct_id <> n.prod_acct_id
                or o.move_way_cd <> n.move_way_cd
                or o.allow_adv_termnt_flg <> n.allow_adv_termnt_flg
                or o.prod_value_dt <> n.prod_value_dt
                or o.prod_exp_dt <> n.prod_exp_dt
                or o.exp_cash_dt <> n.exp_cash_dt
                or o.coll_way_cd <> n.coll_way_cd
                or o.sell_chn_cd <> n.sell_chn_cd
                or o.subscr_sp_amt <> n.subscr_sp_amt
                or o.coll_uplmi_amt <> n.coll_uplmi_amt
                or o.coll_lolmi_amt <> n.coll_lolmi_amt
                or o.supp_amt <> n.supp_amt
                or o.coll_start_dt <> n.coll_start_dt
                or o.coll_end_dt <> n.coll_end_dt
                or o.cap_coll_dt <> n.cap_coll_dt
                or o.tenor <> n.tenor
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.sell_obj_cd <> n.sell_obj_cd
                or o.level1_cls_cd <> n.level1_cls_cd
                or o.level2_cls_cd <> n.level2_cls_cd
                or o.level3_cls_cd <> n.level3_cls_cd
                or o.prod_status_cd <> n.prod_status_cd
                or o.issue_status_cd <> n.issue_status_cd
                or o.prod_rgst_code <> n.prod_rgst_code
                or o.allow_redem_flg <> n.allow_redem_flg
                or o.prod_pd <> n.prod_pd
                or o.invtor_type_cd <> n.invtor_type_cd
                or o.sell_rg_cd <> n.sell_rg_cd
                or o.actl_exp_dt <> n.actl_exp_dt
                or o.liqd_dt <> n.liqd_dt
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.lot_mtsa_proc_way_cd <> n.lot_mtsa_proc_way_cd
                or o.nv_mtsa_proc_way_cd <> n.nv_mtsa_proc_way_cd
                or o.trust_curr_int_provi_flg <> n.trust_curr_int_provi_flg
                or o.curr_int_provi_end_dt <> n.curr_int_provi_end_dt
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.edit_num is null
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
                and n.edit_num is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_nv_type_am_famsf1_tm n
    full join ${iml_schema}.prd_nv_type_am_famsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.edit_num = n.edit_num
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_nv_type_am truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_nv_type_am exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_nv_type_am_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_nv_type_am drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_nv_type_am to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_nv_type_am_famsf1_tm purge;
drop table ${iml_schema}.prd_nv_type_am_famsf1_ex purge;
drop table ${iml_schema}.prd_nv_type_am_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_nv_type_am', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);