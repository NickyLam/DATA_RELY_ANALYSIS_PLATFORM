/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ym_fund_info_mpcsf1
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
drop table ${iml_schema}.prd_ym_fund_info_mpcsf1_tm purge;
drop table ${iml_schema}.prd_ym_fund_info_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ym_fund_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ym_fund_info modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ym_fund_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ym_fund_info partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ym_fund_info_mpcsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,fund_cd -- 基金代码
    ,fund_fname -- 基金全称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,prod_risk_level_cd -- 产品风险等级代码
    ,cfm_days -- 确认天数
    ,redem_avl_days -- 赎回到账天数
    ,divd_way_cd -- 分红方式代码
    ,curr_cd -- 币种代码
    ,sell_status_cd -- 销售状态代码
    ,fund_fee_type_cd -- 基金费类型代码
    ,aip_open_flg -- 定投开通标志
    ,tran_open_flg -- 转换开通标志
    ,fund_mgmt_fee_rat -- 基金管理费率
    ,fund_trust_fee_rat -- 基金托管费率
    ,fe_subscr_fee_rat -- 前端认购费率
    ,fe_purch_fee_rat -- 前端申购费率
    ,redem_fee_rat -- 赎回费率
    ,indv_fir_subscr_lowt_amt -- 个人首次认购最低金额
    ,indv_supp_subscr_lowt_amt -- 个人追加认购最低金额
    ,indv_higt_subscr_amt -- 个人最高认购金额
    ,indv_fir_purch_lowt_amt -- 个人首次申购最低金额
    ,indv_supp_purch_lowt_amt -- 个人追加申购最低金额
    ,indv_higt_purch_amt -- 个人最高申购金额
    ,indv_aip_purch_lowt_amt -- 个人定投申购最低金额
    ,indv_aip_purch_higt_amt -- 个人定投申购最高金额
    ,indv_hold_lowt_lot -- 个人持有最低份额
    ,indv_redem_lowt_lot -- 个人赎回最低份额
    ,indv_tran_lowt_lot -- 个人转换最低份额
    ,found_dt -- 成立日期
    ,fund_mger -- 基金管理人
    ,fund_trustee -- 基金托管人
    ,fund_mgr -- 基金经理
    ,asset_size -- 资产规模
    ,lot_size -- 份额规模
    ,ten_holding -- 十大重仓股
    ,sell_serv_fee_rat -- 销售服务费率
    ,sign_elec_cont_flg -- 签订电子合同标志
    ,fund_prod_type_cd -- 基金产品类型代码
    ,purch_open_flg -- 申购开通标志
    ,subscr_open_flg -- 认购开通标志
    ,buy_open_flg -- 购买开通标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ym_fund_info_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ym_fund_info partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a92fund-
insert into ${iml_schema}.prd_ym_fund_info_mpcsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,fund_cd -- 基金代码
    ,fund_fname -- 基金全称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,prod_risk_level_cd -- 产品风险等级代码
    ,cfm_days -- 确认天数
    ,redem_avl_days -- 赎回到账天数
    ,divd_way_cd -- 分红方式代码
    ,curr_cd -- 币种代码
    ,sell_status_cd -- 销售状态代码
    ,fund_fee_type_cd -- 基金费类型代码
    ,aip_open_flg -- 定投开通标志
    ,tran_open_flg -- 转换开通标志
    ,fund_mgmt_fee_rat -- 基金管理费率
    ,fund_trust_fee_rat -- 基金托管费率
    ,fe_subscr_fee_rat -- 前端认购费率
    ,fe_purch_fee_rat -- 前端申购费率
    ,redem_fee_rat -- 赎回费率
    ,indv_fir_subscr_lowt_amt -- 个人首次认购最低金额
    ,indv_supp_subscr_lowt_amt -- 个人追加认购最低金额
    ,indv_higt_subscr_amt -- 个人最高认购金额
    ,indv_fir_purch_lowt_amt -- 个人首次申购最低金额
    ,indv_supp_purch_lowt_amt -- 个人追加申购最低金额
    ,indv_higt_purch_amt -- 个人最高申购金额
    ,indv_aip_purch_lowt_amt -- 个人定投申购最低金额
    ,indv_aip_purch_higt_amt -- 个人定投申购最高金额
    ,indv_hold_lowt_lot -- 个人持有最低份额
    ,indv_redem_lowt_lot -- 个人赎回最低份额
    ,indv_tran_lowt_lot -- 个人转换最低份额
    ,found_dt -- 成立日期
    ,fund_mger -- 基金管理人
    ,fund_trustee -- 基金托管人
    ,fund_mgr -- 基金经理
    ,asset_size -- 资产规模
    ,lot_size -- 份额规模
    ,ten_holding -- 十大重仓股
    ,sell_serv_fee_rat -- 销售服务费率
    ,sign_elec_cont_flg -- 签订电子合同标志
    ,fund_prod_type_cd -- 基金产品类型代码
    ,purch_open_flg -- 申购开通标志
    ,subscr_open_flg -- 认购开通标志
    ,buy_open_flg -- 购买开通标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223007'||P1.FUNDCODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PAYSYS -- 服务平台简称
    ,P1.INSTID -- 商户编号
    ,P1.FUNDCODE -- 基金代码
    ,P1.FUNDFULLNAME -- 基金全称
    ,P1.FUNDNAME -- 基金简称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.FUNDTYPE END -- 基金类型代码
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.RISKLEVEL END -- 产品风险等级代码
    ,P1.CONFIRMPACE -- 确认天数
    ,P1.REFUNDPACE -- 赎回到账天数
    ,nvl(trim(P1.DEFAULTDIVIDENDMETHOD),'-') -- 分红方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCY END -- 币种代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SALESTAT END -- 销售状态代码
    ,nvl(trim(P1.SHARETYPE),'-') -- 基金费类型代码
    ,nvl(trim(P1.SUPPORTPERIODIC),'-') -- 定投开通标志
    ,nvl(trim(P1.SUPPORTCONVERT),'-') -- 转换开通标志
    ,P1.MANAGERRATE -- 基金管理费率
    ,P1.TRUSTEERATE -- 基金托管费率
    ,P1.SUBSCRIBERATE -- 前端认购费率
    ,P1.ALLOTRATE -- 前端申购费率
    ,P1.REDEEMRATE -- 赎回费率
    ,P1.MININDIVISUBSCRIBEAMOUNT -- 个人首次认购最低金额
    ,P1.MININDIVIAPPENDSUBSCRIBEAMOUNT -- 个人追加认购最低金额
    ,P1.MAXINDIVISUBSCRIBEAMOUNT -- 个人最高认购金额
    ,P1.MININDIVIALLOTAMOUNT -- 个人首次申购最低金额
    ,P1.MININDIVIAPPENDALLOTAMOUNT -- 个人追加申购最低金额
    ,P1.MAXINDIVIALLOTAMOUNT -- 个人最高申购金额
    ,P1.MININDIVIPERIODICAMOUNT -- 个人定投申购最低金额
    ,P1.MAXINDIVIPERIODICAMOUNT -- 个人定投申购最高金额
    ,P1.MININDIVIHOLDVOL -- 个人持有最低份额
    ,P1.MININDIVIREDEEMVOL -- 个人赎回最低份额
    ,P1.MININDIVICONVERTVOL -- 个人转换最低份额
    ,${iml_schema}.dateformat_min(TRIM(P1.SETUPDATE)) -- 成立日期
    ,P1.FUNDCORP -- 基金管理人
    ,P1.TRUSTEE -- 基金托管人
    ,P1.FUNDMANAGER -- 基金经理
    ,P1.ASSETAMOUNT -- 资产规模
    ,P1.ASSETVOL -- 份额规模
    ,P1.STOCKPORTFOLIO -- 十大重仓股
    ,P1.SALERATE -- 销售服务费率
    ,nvl(trim(P1.ECFLAG),'-') -- 签订电子合同标志
    ,nvl(trim(P1.PRODTYPE),'-') -- 基金产品类型代码
    ,nvl(trim(P1.SUPPORTALLOT),'-') -- 申购开通标志
    ,nvl(trim(P1.SUPPORTSUBSCRIBE),'-') -- 认购开通标志
    ,nvl(trim(P1.SUPPORTBUY),'-') -- 购买开通标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92fund' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92fund p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.FUNDTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A92FUND'
        AND R1.SRC_FIELD_EN_NAME= 'FUNDTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'FUND_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.RISKLEVEL = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'MPCS'
        AND R10.SRC_TAB_EN_NAME= 'MPCS_A92FUND'
        AND R10.SRC_FIELD_EN_NAME= 'RISKLEVEL'
        AND R10.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_INFO'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'PROD_RISK_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A92FUND'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCY'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SALESTAT = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A92FUND'
        AND R3.SRC_FIELD_EN_NAME= 'SALESTAT'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'SELL_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ym_fund_info_mpcsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_ym_fund_info_mpcsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,fund_cd -- 基金代码
    ,fund_fname -- 基金全称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,prod_risk_level_cd -- 产品风险等级代码
    ,cfm_days -- 确认天数
    ,redem_avl_days -- 赎回到账天数
    ,divd_way_cd -- 分红方式代码
    ,curr_cd -- 币种代码
    ,sell_status_cd -- 销售状态代码
    ,fund_fee_type_cd -- 基金费类型代码
    ,aip_open_flg -- 定投开通标志
    ,tran_open_flg -- 转换开通标志
    ,fund_mgmt_fee_rat -- 基金管理费率
    ,fund_trust_fee_rat -- 基金托管费率
    ,fe_subscr_fee_rat -- 前端认购费率
    ,fe_purch_fee_rat -- 前端申购费率
    ,redem_fee_rat -- 赎回费率
    ,indv_fir_subscr_lowt_amt -- 个人首次认购最低金额
    ,indv_supp_subscr_lowt_amt -- 个人追加认购最低金额
    ,indv_higt_subscr_amt -- 个人最高认购金额
    ,indv_fir_purch_lowt_amt -- 个人首次申购最低金额
    ,indv_supp_purch_lowt_amt -- 个人追加申购最低金额
    ,indv_higt_purch_amt -- 个人最高申购金额
    ,indv_aip_purch_lowt_amt -- 个人定投申购最低金额
    ,indv_aip_purch_higt_amt -- 个人定投申购最高金额
    ,indv_hold_lowt_lot -- 个人持有最低份额
    ,indv_redem_lowt_lot -- 个人赎回最低份额
    ,indv_tran_lowt_lot -- 个人转换最低份额
    ,found_dt -- 成立日期
    ,fund_mger -- 基金管理人
    ,fund_trustee -- 基金托管人
    ,fund_mgr -- 基金经理
    ,asset_size -- 资产规模
    ,lot_size -- 份额规模
    ,ten_holding -- 十大重仓股
    ,sell_serv_fee_rat -- 销售服务费率
    ,sign_elec_cont_flg -- 签订电子合同标志
    ,fund_prod_type_cd -- 基金产品类型代码
    ,purch_open_flg -- 申购开通标志
    ,subscr_open_flg -- 认购开通标志
    ,buy_open_flg -- 购买开通标志
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
    ,nvl(n.serv_plat_abbr, o.serv_plat_abbr) as serv_plat_abbr -- 服务平台简称
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.fund_fname, o.fund_fname) as fund_fname -- 基金全称
    ,nvl(n.fund_abbr, o.fund_abbr) as fund_abbr -- 基金简称
    ,nvl(n.fund_type_cd, o.fund_type_cd) as fund_type_cd -- 基金类型代码
    ,nvl(n.prod_risk_level_cd, o.prod_risk_level_cd) as prod_risk_level_cd -- 产品风险等级代码
    ,nvl(n.cfm_days, o.cfm_days) as cfm_days -- 确认天数
    ,nvl(n.redem_avl_days, o.redem_avl_days) as redem_avl_days -- 赎回到账天数
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sell_status_cd, o.sell_status_cd) as sell_status_cd -- 销售状态代码
    ,nvl(n.fund_fee_type_cd, o.fund_fee_type_cd) as fund_fee_type_cd -- 基金费类型代码
    ,nvl(n.aip_open_flg, o.aip_open_flg) as aip_open_flg -- 定投开通标志
    ,nvl(n.tran_open_flg, o.tran_open_flg) as tran_open_flg -- 转换开通标志
    ,nvl(n.fund_mgmt_fee_rat, o.fund_mgmt_fee_rat) as fund_mgmt_fee_rat -- 基金管理费率
    ,nvl(n.fund_trust_fee_rat, o.fund_trust_fee_rat) as fund_trust_fee_rat -- 基金托管费率
    ,nvl(n.fe_subscr_fee_rat, o.fe_subscr_fee_rat) as fe_subscr_fee_rat -- 前端认购费率
    ,nvl(n.fe_purch_fee_rat, o.fe_purch_fee_rat) as fe_purch_fee_rat -- 前端申购费率
    ,nvl(n.redem_fee_rat, o.redem_fee_rat) as redem_fee_rat -- 赎回费率
    ,nvl(n.indv_fir_subscr_lowt_amt, o.indv_fir_subscr_lowt_amt) as indv_fir_subscr_lowt_amt -- 个人首次认购最低金额
    ,nvl(n.indv_supp_subscr_lowt_amt, o.indv_supp_subscr_lowt_amt) as indv_supp_subscr_lowt_amt -- 个人追加认购最低金额
    ,nvl(n.indv_higt_subscr_amt, o.indv_higt_subscr_amt) as indv_higt_subscr_amt -- 个人最高认购金额
    ,nvl(n.indv_fir_purch_lowt_amt, o.indv_fir_purch_lowt_amt) as indv_fir_purch_lowt_amt -- 个人首次申购最低金额
    ,nvl(n.indv_supp_purch_lowt_amt, o.indv_supp_purch_lowt_amt) as indv_supp_purch_lowt_amt -- 个人追加申购最低金额
    ,nvl(n.indv_higt_purch_amt, o.indv_higt_purch_amt) as indv_higt_purch_amt -- 个人最高申购金额
    ,nvl(n.indv_aip_purch_lowt_amt, o.indv_aip_purch_lowt_amt) as indv_aip_purch_lowt_amt -- 个人定投申购最低金额
    ,nvl(n.indv_aip_purch_higt_amt, o.indv_aip_purch_higt_amt) as indv_aip_purch_higt_amt -- 个人定投申购最高金额
    ,nvl(n.indv_hold_lowt_lot, o.indv_hold_lowt_lot) as indv_hold_lowt_lot -- 个人持有最低份额
    ,nvl(n.indv_redem_lowt_lot, o.indv_redem_lowt_lot) as indv_redem_lowt_lot -- 个人赎回最低份额
    ,nvl(n.indv_tran_lowt_lot, o.indv_tran_lowt_lot) as indv_tran_lowt_lot -- 个人转换最低份额
    ,nvl(n.found_dt, o.found_dt) as found_dt -- 成立日期
    ,nvl(n.fund_mger, o.fund_mger) as fund_mger -- 基金管理人
    ,nvl(n.fund_trustee, o.fund_trustee) as fund_trustee -- 基金托管人
    ,nvl(n.fund_mgr, o.fund_mgr) as fund_mgr -- 基金经理
    ,nvl(n.asset_size, o.asset_size) as asset_size -- 资产规模
    ,nvl(n.lot_size, o.lot_size) as lot_size -- 份额规模
    ,nvl(n.ten_holding, o.ten_holding) as ten_holding -- 十大重仓股
    ,nvl(n.sell_serv_fee_rat, o.sell_serv_fee_rat) as sell_serv_fee_rat -- 销售服务费率
    ,nvl(n.sign_elec_cont_flg, o.sign_elec_cont_flg) as sign_elec_cont_flg -- 签订电子合同标志
    ,nvl(n.fund_prod_type_cd, o.fund_prod_type_cd) as fund_prod_type_cd -- 基金产品类型代码
    ,nvl(n.purch_open_flg, o.purch_open_flg) as purch_open_flg -- 申购开通标志
    ,nvl(n.subscr_open_flg, o.subscr_open_flg) as subscr_open_flg -- 认购开通标志
    ,nvl(n.buy_open_flg, o.buy_open_flg) as buy_open_flg -- 购买开通标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.serv_plat_abbr <> n.serv_plat_abbr
                or o.mercht_id <> n.mercht_id
                or o.fund_cd <> n.fund_cd
                or o.fund_fname <> n.fund_fname
                or o.fund_abbr <> n.fund_abbr
                or o.fund_type_cd <> n.fund_type_cd
                or o.prod_risk_level_cd <> n.prod_risk_level_cd
                or o.cfm_days <> n.cfm_days
                or o.redem_avl_days <> n.redem_avl_days
                or o.divd_way_cd <> n.divd_way_cd
                or o.curr_cd <> n.curr_cd
                or o.sell_status_cd <> n.sell_status_cd
                or o.fund_fee_type_cd <> n.fund_fee_type_cd
                or o.aip_open_flg <> n.aip_open_flg
                or o.tran_open_flg <> n.tran_open_flg
                or o.fund_mgmt_fee_rat <> n.fund_mgmt_fee_rat
                or o.fund_trust_fee_rat <> n.fund_trust_fee_rat
                or o.fe_subscr_fee_rat <> n.fe_subscr_fee_rat
                or o.fe_purch_fee_rat <> n.fe_purch_fee_rat
                or o.redem_fee_rat <> n.redem_fee_rat
                or o.indv_fir_subscr_lowt_amt <> n.indv_fir_subscr_lowt_amt
                or o.indv_supp_subscr_lowt_amt <> n.indv_supp_subscr_lowt_amt
                or o.indv_higt_subscr_amt <> n.indv_higt_subscr_amt
                or o.indv_fir_purch_lowt_amt <> n.indv_fir_purch_lowt_amt
                or o.indv_supp_purch_lowt_amt <> n.indv_supp_purch_lowt_amt
                or o.indv_higt_purch_amt <> n.indv_higt_purch_amt
                or o.indv_aip_purch_lowt_amt <> n.indv_aip_purch_lowt_amt
                or o.indv_aip_purch_higt_amt <> n.indv_aip_purch_higt_amt
                or o.indv_hold_lowt_lot <> n.indv_hold_lowt_lot
                or o.indv_redem_lowt_lot <> n.indv_redem_lowt_lot
                or o.indv_tran_lowt_lot <> n.indv_tran_lowt_lot
                or o.found_dt <> n.found_dt
                or o.fund_mger <> n.fund_mger
                or o.fund_trustee <> n.fund_trustee
                or o.fund_mgr <> n.fund_mgr
                or o.asset_size <> n.asset_size
                or o.lot_size <> n.lot_size
                or o.ten_holding <> n.ten_holding
                or o.sell_serv_fee_rat <> n.sell_serv_fee_rat
                or o.sign_elec_cont_flg <> n.sign_elec_cont_flg
                or o.fund_prod_type_cd <> n.fund_prod_type_cd
                or o.purch_open_flg <> n.purch_open_flg
                or o.subscr_open_flg <> n.subscr_open_flg
                or o.buy_open_flg <> n.buy_open_flg
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
from ${iml_schema}.prd_ym_fund_info_mpcsf1_tm n
    full join ${iml_schema}.prd_ym_fund_info_mpcsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ym_fund_info truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ym_fund_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.prd_ym_fund_info_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ym_fund_info drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ym_fund_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ym_fund_info_mpcsf1_tm purge;
drop table ${iml_schema}.prd_ym_fund_info_mpcsf1_ex purge;
drop table ${iml_schema}.prd_ym_fund_info_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ym_fund_info', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);