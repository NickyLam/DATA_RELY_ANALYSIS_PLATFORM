/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dilg_quot_ctr_nt_bdmsf1
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
drop table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm purge;
drop table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_dilg_quot_ctr_nt add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_dilg_quot_ctr_nt modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dilg_quot_ctr_nt partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_tab_id -- 成交单表编号
    ,batch_id -- 批次编号
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_type_cd -- 业务类型代码
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,quot_bill_id -- 报价单编号
    ,mem_org_cd -- 会员机构代码
    ,non_lp_prod_id -- 非法人产品编号
    ,dealer_id -- 交易员编号
    ,cap_acct -- 资金账户
    ,cntpty_org_cd -- 对手机构代码
    ,cntpty_dealer_id -- 对手交易员编号
    ,cntpty_cap_acct -- 对手资金账户
    ,quot_bill_status_cd -- 报价单状态代码
    ,dcotin_rs_cd -- 中止原因代码
    ,lock_flg -- 锁定标志
    ,final_modif_tm -- 最后修改时间
    ,exp_clear_status_cd -- 到期清算状态代码
    ,nest_lock_ind -- 嵌套锁标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dilg_quot_ctr_nt
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_dilg_quot_ctr_nt partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_ces_quote_deal-
insert into ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_tab_id -- 成交单表编号
    ,batch_id -- 批次编号
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_type_cd -- 业务类型代码
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,quot_bill_id -- 报价单编号
    ,mem_org_cd -- 会员机构代码
    ,non_lp_prod_id -- 非法人产品编号
    ,dealer_id -- 交易员编号
    ,cap_acct -- 资金账户
    ,cntpty_org_cd -- 对手机构代码
    ,cntpty_dealer_id -- 对手交易员编号
    ,cntpty_cap_acct -- 对手资金账户
    ,quot_bill_status_cd -- 报价单状态代码
    ,dcotin_rs_cd -- 中止原因代码
    ,lock_flg -- 锁定标志
    ,final_modif_tm -- 最后修改时间
    ,exp_clear_status_cd -- 到期清算状态代码
    ,nest_lock_ind -- 嵌套锁标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225108'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 成交单表编号
    ,P1.BUSS_CONTRACT_ID -- 批次编号
    ,P1.DEALED_NO -- 成交单编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,NVL(TRIM(P1.BUSI_TYPE),'BT00') -- 业务类型代码
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,NVL(TRIM(P1.TRADE_TYPE),'-') -- 成交方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRADE_DATE) -- 成交日期
    ,CASE WHEN LENGTH( P1.TRADE_TIME)<9 THEN ' ' ELSE  SUBSTR(P1.TRADE_TIME,9) END -- 成交时间
    ,NVL(TRIM(P1.TRADE_STATUS),'-') -- 成交状态代码
    ,NVL(TRIM(P1.SETTLE_STATUS),'-') -- 清算状态代码
    ,P1.QUOTE_NO -- 报价单编号
    ,P1.BRH_NO -- 会员机构代码
    ,P1.PRODUCT_NO -- 非法人产品编号
    ,P1.TRADER_ID -- 交易员编号
    ,P1.FUNDATION_ACCT -- 资金账户
    ,P1.ADVER_BRH_NO -- 对手机构代码
    ,P1.ADVER_TRADER_ID -- 对手交易员编号
    ,P1.ADVER_FUND_ACCT -- 对手资金账户
    ,NVL(TRIM(P1.QUOTE_STATUS),'-') -- 报价单状态代码
    ,NVL(TRIM(P1.TRACE_REASON),'-') -- 中止原因代码
    ,NVL(TRIM(P1.LOCK_FLAG),'-') -- 锁定标志
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_UPD_TIME) -- 最后修改时间
    ,NVL(TRIM(P1.DUE_SETTLE_STATUS),'-') -- 到期清算状态代码
    ,NVL(TRIM(P1.NESTING_LOCK_FLAG),'_') -- 嵌套锁标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_ces_quote_deal' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_ces_quote_deal p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_DIRECT= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CES_QUOTE_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DILG_QUOT_CTR_NT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_ATTR = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CES_QUOTE_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DILG_QUOT_CTR_NT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_tab_id -- 成交单表编号
    ,batch_id -- 批次编号
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_type_cd -- 业务类型代码
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,quot_bill_id -- 报价单编号
    ,mem_org_cd -- 会员机构代码
    ,non_lp_prod_id -- 非法人产品编号
    ,dealer_id -- 交易员编号
    ,cap_acct -- 资金账户
    ,cntpty_org_cd -- 对手机构代码
    ,cntpty_dealer_id -- 对手交易员编号
    ,cntpty_cap_acct -- 对手资金账户
    ,quot_bill_status_cd -- 报价单状态代码
    ,dcotin_rs_cd -- 中止原因代码
    ,lock_flg -- 锁定标志
    ,final_modif_tm -- 最后修改时间
    ,exp_clear_status_cd -- 到期清算状态代码
    ,nest_lock_ind -- 嵌套锁标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.ctr_nt_tab_id, o.ctr_nt_tab_id) as ctr_nt_tab_id -- 成交单表编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.ctr_nt_id, o.ctr_nt_id) as ctr_nt_id -- 成交单编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bag_way_cd, o.bag_way_cd) as bag_way_cd -- 成交方式代码
    ,nvl(n.tra_dt, o.tra_dt) as tra_dt -- 成交日期
    ,nvl(n.bag_tm, o.bag_tm) as bag_tm -- 成交时间
    ,nvl(n.bag_status_cd, o.bag_status_cd) as bag_status_cd -- 成交状态代码
    ,nvl(n.clear_status_cd, o.clear_status_cd) as clear_status_cd -- 清算状态代码
    ,nvl(n.quot_bill_id, o.quot_bill_id) as quot_bill_id -- 报价单编号
    ,nvl(n.mem_org_cd, o.mem_org_cd) as mem_org_cd -- 会员机构代码
    ,nvl(n.non_lp_prod_id, o.non_lp_prod_id) as non_lp_prod_id -- 非法人产品编号
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(n.cap_acct, o.cap_acct) as cap_acct -- 资金账户
    ,nvl(n.cntpty_org_cd, o.cntpty_org_cd) as cntpty_org_cd -- 对手机构代码
    ,nvl(n.cntpty_dealer_id, o.cntpty_dealer_id) as cntpty_dealer_id -- 对手交易员编号
    ,nvl(n.cntpty_cap_acct, o.cntpty_cap_acct) as cntpty_cap_acct -- 对手资金账户
    ,nvl(n.quot_bill_status_cd, o.quot_bill_status_cd) as quot_bill_status_cd -- 报价单状态代码
    ,nvl(n.dcotin_rs_cd, o.dcotin_rs_cd) as dcotin_rs_cd -- 中止原因代码
    ,nvl(n.lock_flg, o.lock_flg) as lock_flg -- 锁定标志
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.exp_clear_status_cd, o.exp_clear_status_cd) as exp_clear_status_cd -- 到期清算状态代码
    ,nvl(n.nest_lock_ind, o.nest_lock_ind) as nest_lock_ind -- 嵌套锁标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.ctr_nt_tab_id <> n.ctr_nt_tab_id
                or o.batch_id <> n.batch_id
                or o.ctr_nt_id <> n.ctr_nt_id
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.bus_type_cd <> n.bus_type_cd
                or o.bill_type_cd <> n.bill_type_cd
                or o.bill_med_cd <> n.bill_med_cd
                or o.bag_way_cd <> n.bag_way_cd
                or o.tra_dt <> n.tra_dt
                or o.bag_tm <> n.bag_tm
                or o.bag_status_cd <> n.bag_status_cd
                or o.clear_status_cd <> n.clear_status_cd
                or o.quot_bill_id <> n.quot_bill_id
                or o.mem_org_cd <> n.mem_org_cd
                or o.non_lp_prod_id <> n.non_lp_prod_id
                or o.dealer_id <> n.dealer_id
                or o.cap_acct <> n.cap_acct
                or o.cntpty_org_cd <> n.cntpty_org_cd
                or o.cntpty_dealer_id <> n.cntpty_dealer_id
                or o.cntpty_cap_acct <> n.cntpty_cap_acct
                or o.quot_bill_status_cd <> n.quot_bill_status_cd
                or o.dcotin_rs_cd <> n.dcotin_rs_cd
                or o.lock_flg <> n.lock_flg
                or o.final_modif_tm <> n.final_modif_tm
                or o.exp_clear_status_cd <> n.exp_clear_status_cd
                or o.nest_lock_ind <> n.nest_lock_ind
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm n
    full join ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dilg_quot_ctr_nt truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_dilg_quot_ctr_nt exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_dilg_quot_ctr_nt drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dilg_quot_ctr_nt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_tm purge;
drop table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_ex purge;
drop table ${iml_schema}.agt_dilg_quot_ctr_nt_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dilg_quot_ctr_nt', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);