/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_qxb_prod_info_fsmsf1
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
drop table ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm purge;
drop table ${iml_schema}.prd_qxb_prod_info_fsmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_qxb_prod_info add partition p_fsmsf1 values ('fsmsf1')(
        subpartition p_fsmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_qxb_prod_info modify partition p_fsmsf1
    add subpartition p_fsmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_qxb_prod_info_fsmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_qxb_prod_info partition for ('fsmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,fund_id -- 销售模式代码
    ,sell_mode_cd -- 基金编号
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_status_cd -- 基金状态代码
    ,mger_id -- 管理人编号
    ,curr_cd -- 币种代码
    ,fund_fname -- 基金全称
    ,charge_way_cd -- 收费方式代码
    ,divd_way_cd -- 分红方式代码
    ,risk_level_cd -- 风险等级代码
    ,prod_lowt_hold_lot -- 产品最低持有份额
    ,daily_redem_max_size -- 每日赎回最大规模
    ,subscr_final_day_close_tm -- 认购最后一天收市时间
    ,allow_tran_cd_comb -- 允许的交易手段代码组合
    ,prod_coll_start_dt -- 产品募集开始日期
    ,prod_coll_end_dt -- 产品募集结束日期
    ,fund_found_dt -- 基金成立日期
    ,bus_swi_cd_comb -- 业务开关代码组合
    ,fund_mgr -- 基金经理
    ,ta_clear_tran_acct_id -- TA清算划款账户编号
    ,purch_clear_acct_id -- 申购清算账户编号
    ,redem_divd_clear_acct_id -- 赎回分红清算账户编号
    ,comm_fee_clear_acct_id -- 手续费清算账户编号
    ,adv_acct_id -- 垫资户账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_qxb_prod_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_qxb_prod_info_fsmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_qxb_prod_info partition for ('fsmsf1') where 0=1;

-- 2.1 insert data to tm table
-- fsms_yeb_cfg_fund-
insert into ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,fund_id -- 销售模式代码
    ,sell_mode_cd -- 基金编号
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_status_cd -- 基金状态代码
    ,mger_id -- 管理人编号
    ,curr_cd -- 币种代码
    ,fund_fname -- 基金全称
    ,charge_way_cd -- 收费方式代码
    ,divd_way_cd -- 分红方式代码
    ,risk_level_cd -- 风险等级代码
    ,prod_lowt_hold_lot -- 产品最低持有份额
    ,daily_redem_max_size -- 每日赎回最大规模
    ,subscr_final_day_close_tm -- 认购最后一天收市时间
    ,allow_tran_cd_comb -- 允许的交易手段代码组合
    ,prod_coll_start_dt -- 产品募集开始日期
    ,prod_coll_end_dt -- 产品募集结束日期
    ,fund_found_dt -- 基金成立日期
    ,bus_swi_cd_comb -- 业务开关代码组合
    ,fund_mgr -- 基金经理
    ,ta_clear_tran_acct_id -- TA清算划款账户编号
    ,purch_clear_acct_id -- 申购清算账户编号
    ,redem_divd_clear_acct_id -- 赎回分红清算账户编号
    ,comm_fee_clear_acct_id -- 手续费清算账户编号
    ,adv_acct_id -- 垫资户账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222007' -- 产品编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.TANO -- TA代码
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.FUNDCODE -- 基金编号
    ,P1.FUNDNAME -- 基金简称
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.FUNDTYPE END -- 基金类型代码
    ,NVL(TRIM(P1.FUNDSTATUS),'-') -- 基金状态代码
    ,P1.MANAGERCODE -- 管理人编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,P1.FUNDENGNAME -- 基金全称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SHARETYPE END -- 收费方式代码
    ,NVL(TRIM(P1.DIVIDEND),'-') -- 分红方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.RISKLEVEL END -- 风险等级代码
    ,TRIM(P1.HOLDMIN) -- 产品最低持有份额
    ,TRIM(P1.REDEEMMAXSIZE) -- 每日赎回最大规模
    ,P1.APPSUBSLASTTIME -- 认购最后一天收市时间
    ,P1.TRADINGMETHOD -- 允许的交易手段代码组合
    ,${iml_schema}.dateformat_min(TRIM(P1.IPOSTARTDATE)) -- 产品募集开始日期
    ,${iml_schema}.dateformat_max(TRIM(P1.IPOENDDATE)) -- 产品募集结束日期
    ,${iml_schema}.dateformat_min(TRIM(P1.ESTABLISHDATE)) -- 基金成立日期
    ,P1.BUSINESS_FLAG -- 业务开关代码组合
    ,P1.FUNDMANAGER -- 基金经理
    ,TRIM(P1.TAACCTNO) -- TA清算划款账户编号
    ,TRIM(P1.BUYACCTNO) -- 申购清算账户编号
    ,TRIM(P1.REDEEMACCTNO) -- 赎回分红清算账户编号
    ,TRIM(P1.FEEACCTNO) -- 手续费清算账户编号
    ,TRIM(P1.ADVANCEACCTNO) -- 垫资户账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_cfg_fund' -- 源表名称
    ,'fsmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_cfg_fund p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.FUNDTYPE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FSMS'
        AND R4.SRC_TAB_EN_NAME= 'FSMS_YEB_CFG_FUND'
        AND R4.SRC_FIELD_EN_NAME= 'FUNDTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_QXB_PROD_INFO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'FUND_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURRENCYTYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_CFG_FUND'
        AND R1.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_QXB_PROD_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SHARETYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FSMS'
        AND R3.SRC_TAB_EN_NAME= 'FSMS_YEB_CFG_FUND'
        AND R3.SRC_FIELD_EN_NAME= 'SHARETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_QXB_PROD_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RISKLEVEL= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_CFG_FUND'
        AND R2.SRC_FIELD_EN_NAME= 'RISKLEVEL'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_QXB_PROD_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,ibank_no
  	                                        ,ta_cd
  	                                        ,fund_id
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
insert /*+ append */ into ${iml_schema}.prd_qxb_prod_info_fsmsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,fund_id -- 销售模式代码
    ,sell_mode_cd -- 基金编号
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_status_cd -- 基金状态代码
    ,mger_id -- 管理人编号
    ,curr_cd -- 币种代码
    ,fund_fname -- 基金全称
    ,charge_way_cd -- 收费方式代码
    ,divd_way_cd -- 分红方式代码
    ,risk_level_cd -- 风险等级代码
    ,prod_lowt_hold_lot -- 产品最低持有份额
    ,daily_redem_max_size -- 每日赎回最大规模
    ,subscr_final_day_close_tm -- 认购最后一天收市时间
    ,allow_tran_cd_comb -- 允许的交易手段代码组合
    ,prod_coll_start_dt -- 产品募集开始日期
    ,prod_coll_end_dt -- 产品募集结束日期
    ,fund_found_dt -- 基金成立日期
    ,bus_swi_cd_comb -- 业务开关代码组合
    ,fund_mgr -- 基金经理
    ,ta_clear_tran_acct_id -- TA清算划款账户编号
    ,purch_clear_acct_id -- 申购清算账户编号
    ,redem_divd_clear_acct_id -- 赎回分红清算账户编号
    ,comm_fee_clear_acct_id -- 手续费清算账户编号
    ,adv_acct_id -- 垫资户账户编号
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
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.fund_id, o.fund_id) as fund_id -- 销售模式代码
    ,nvl(n.sell_mode_cd, o.sell_mode_cd) as sell_mode_cd -- 基金编号
    ,nvl(n.fund_abbr, o.fund_abbr) as fund_abbr -- 基金简称
    ,nvl(n.fund_type_cd, o.fund_type_cd) as fund_type_cd -- 基金类型代码
    ,nvl(n.fund_status_cd, o.fund_status_cd) as fund_status_cd -- 基金状态代码
    ,nvl(n.mger_id, o.mger_id) as mger_id -- 管理人编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.fund_fname, o.fund_fname) as fund_fname -- 基金全称
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.prod_lowt_hold_lot, o.prod_lowt_hold_lot) as prod_lowt_hold_lot -- 产品最低持有份额
    ,nvl(n.daily_redem_max_size, o.daily_redem_max_size) as daily_redem_max_size -- 每日赎回最大规模
    ,nvl(n.subscr_final_day_close_tm, o.subscr_final_day_close_tm) as subscr_final_day_close_tm -- 认购最后一天收市时间
    ,nvl(n.allow_tran_cd_comb, o.allow_tran_cd_comb) as allow_tran_cd_comb -- 允许的交易手段代码组合
    ,nvl(n.prod_coll_start_dt, o.prod_coll_start_dt) as prod_coll_start_dt -- 产品募集开始日期
    ,nvl(n.prod_coll_end_dt, o.prod_coll_end_dt) as prod_coll_end_dt -- 产品募集结束日期
    ,nvl(n.fund_found_dt, o.fund_found_dt) as fund_found_dt -- 基金成立日期
    ,nvl(n.bus_swi_cd_comb, o.bus_swi_cd_comb) as bus_swi_cd_comb -- 业务开关代码组合
    ,nvl(n.fund_mgr, o.fund_mgr) as fund_mgr -- 基金经理
    ,nvl(n.ta_clear_tran_acct_id, o.ta_clear_tran_acct_id) as ta_clear_tran_acct_id -- TA清算划款账户编号
    ,nvl(n.purch_clear_acct_id, o.purch_clear_acct_id) as purch_clear_acct_id -- 申购清算账户编号
    ,nvl(n.redem_divd_clear_acct_id, o.redem_divd_clear_acct_id) as redem_divd_clear_acct_id -- 赎回分红清算账户编号
    ,nvl(n.comm_fee_clear_acct_id, o.comm_fee_clear_acct_id) as comm_fee_clear_acct_id -- 手续费清算账户编号
    ,nvl(n.adv_acct_id, o.adv_acct_id) as adv_acct_id -- 垫资户账户编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.ibank_no is null
                and o.ta_cd is null
                and o.fund_id is null
            ) or (
                o.sell_mode_cd <> n.sell_mode_cd
                or o.fund_abbr <> n.fund_abbr
                or o.fund_type_cd <> n.fund_type_cd
                or o.fund_status_cd <> n.fund_status_cd
                or o.mger_id <> n.mger_id
                or o.curr_cd <> n.curr_cd
                or o.fund_fname <> n.fund_fname
                or o.charge_way_cd <> n.charge_way_cd
                or o.divd_way_cd <> n.divd_way_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.prod_lowt_hold_lot <> n.prod_lowt_hold_lot
                or o.daily_redem_max_size <> n.daily_redem_max_size
                or o.subscr_final_day_close_tm <> n.subscr_final_day_close_tm
                or o.allow_tran_cd_comb <> n.allow_tran_cd_comb
                or o.prod_coll_start_dt <> n.prod_coll_start_dt
                or o.prod_coll_end_dt <> n.prod_coll_end_dt
                or o.fund_found_dt <> n.fund_found_dt
                or o.bus_swi_cd_comb <> n.bus_swi_cd_comb
                or o.fund_mgr <> n.fund_mgr
                or o.ta_clear_tran_acct_id <> n.ta_clear_tran_acct_id
                or o.purch_clear_acct_id <> n.purch_clear_acct_id
                or o.redem_divd_clear_acct_id <> n.redem_divd_clear_acct_id
                or o.comm_fee_clear_acct_id <> n.comm_fee_clear_acct_id
                or o.adv_acct_id <> n.adv_acct_id
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.ibank_no is null
                           and n.ta_cd is null
                           and n.fund_id is null
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
                and n.ibank_no is null
                and n.ta_cd is null
                and n.fund_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm n
    full join ${iml_schema}.prd_qxb_prod_info_fsmsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.ibank_no = n.ibank_no
            and o.ta_cd = n.ta_cd
            and o.fund_id = n.fund_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_qxb_prod_info truncate partition for ('fsmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_qxb_prod_info exchange subpartition p_fsmsf1_${batch_date} with table ${iml_schema}.prd_qxb_prod_info_fsmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_qxb_prod_info drop subpartition p_fsmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_qxb_prod_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_qxb_prod_info_fsmsf1_tm purge;
drop table ${iml_schema}.prd_qxb_prod_info_fsmsf1_ex purge;
drop table ${iml_schema}.prd_qxb_prod_info_fsmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_qxb_prod_info', partname => 'p_fsmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);