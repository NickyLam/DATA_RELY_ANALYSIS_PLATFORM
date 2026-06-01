/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_trust_lot_h_trusf1
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
alter table ${iml_schema}.agt_trust_lot_h add partition p_trusf1 values ('trusf1')(
        subpartition p_trusf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_trusf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_trust_lot_h_trusf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_trust_lot_h partition for ('trusf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_trust_lot_h_trusf1_tm purge;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_op purge;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_trust_lot_h_trusf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_trust_lot_h partition for ('trusf1')
where 0=1
;

create table ${iml_schema}.agt_trust_lot_h_trusf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_trust_lot_h partition for ('trusf1') where 0=1;

create table ${iml_schema}.agt_trust_lot_h_trusf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_trust_lot_h partition for ('trusf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbshare0-
insert into ${iml_schema}.agt_trust_lot_h_trusf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130019'||P1.IN_CLIENT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,nvl(trim(P3.prompt),' ') -- 标准产品编号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易账户编号
    ,P1.TA_CODE -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_DATE) -- 最后变动日期
    ,P1.TOT_VOL -- 份额总数
    ,P1.FROZEN_VOL -- 交易冻结份额
    ,P1.LONG_FROZEN_VOL -- 长期冻结份额
    ,P1.GROUP_VOL -- 组合投资份额
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.DIV_RATE -- 红利比例
    ,P1.YSTDY_TOT_VOL -- 昨日份额总数
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,NVL(TRIM(P1.APPEND_FLAG),'-') -- 追加投资标志
    ,P1.OTHER_FROZEN -- 本地冻结份额
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益客户比例
    ,P1.COST -- 买入成本
    ,P1.TOT_INCOME -- 累计收入
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbshare0' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbshare0 p1
    left join ${iol_schema}.nfss_tcs_tbprdparamvalue p2 on P1.prd_code=P2.prd_code
     and p2.table_name = 'tbproduct'
   and p2.field_code = 'hx_prdtype'
and  p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tcs_tbdict p3 on P2.field_value=P3.val
and P3.hs_key = 'K_HXYHZSJ'
and P3.start_dt <= to_date('${batch_date}','yyyymmdd') 
and P3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TCS_TBSHARE0'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_TRUST_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_trust_lot_h_trusf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,seller_id
  	                                        ,bank_id
  	                                        ,bank_acct_id
  	                                        ,prod_id
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
        into ${iml_schema}.agt_trust_lot_h_trusf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_trust_lot_h_trusf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.tran_med_type_cd, o.tran_med_type_cd) as tran_med_type_cd -- 交易介质类型代码
    ,nvl(n.tran_acct_id, o.tran_acct_id) as tran_acct_id -- 交易账户编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合约编号
    ,nvl(n.final_chg_dt, o.final_chg_dt) as final_chg_dt -- 最后变动日期
    ,nvl(n.lot_tot, o.lot_tot) as lot_tot -- 份额总数
    ,nvl(n.tran_froz_lot, o.tran_froz_lot) as tran_froz_lot -- 交易冻结份额
    ,nvl(n.lonterm_froz_lot, o.lonterm_froz_lot) as lonterm_froz_lot -- 长期冻结份额
    ,nvl(n.comb_invest_lot, o.comb_invest_lot) as comb_invest_lot -- 组合投资份额
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.init_divd_way_cd, o.init_divd_way_cd) as init_divd_way_cd -- 原分红方式代码
    ,nvl(n.bonus_ratio, o.bonus_ratio) as bonus_ratio -- 红利比例
    ,nvl(n.yd_lot_tot, o.yd_lot_tot) as yd_lot_tot -- 昨日份额总数
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.supp_invest_flg, o.supp_invest_flg) as supp_invest_flg -- 追加投资标志
    ,nvl(n.loc_froz_lot, o.loc_froz_lot) as loc_froz_lot -- 本地冻结份额
    ,nvl(n.curr_issue_prft, o.curr_issue_prft) as curr_issue_prft -- 本期收益
    ,nvl(n.prft_cust_ratio, o.prft_cust_ratio) as prft_cust_ratio -- 收益客户比例
    ,nvl(n.buy_cost, o.buy_cost) as buy_cost -- 买入成本
    ,nvl(n.acm_inco, o.acm_inco) as acm_inco -- 累计收入
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.froz_unpaid_prft, o.froz_unpaid_prft) as froz_unpaid_prft -- 冻结未付收益
    ,nvl(n.new_assign_prft, o.new_assign_prft) as new_assign_prft -- 新分配收益
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.bank_acct_id is null
            and n.prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.bank_acct_id is null
            and n.prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.bank_acct_id is null
            and n.prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_trust_lot_h_trusf1_tm n
    full join (select * from ${iml_schema}.agt_trust_lot_h_trusf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.bank_id = n.bank_id
            and o.bank_acct_id = n.bank_acct_id
            and o.prod_id = n.prod_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.seller_id is null
        and o.bank_id is null
        and o.bank_acct_id is null
        and o.prod_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.seller_id is null
        and n.bank_id is null
        and n.bank_acct_id is null
        and n.prod_id is null
    )
    or (
        o.std_prod_id <> n.std_prod_id
        or o.intnal_cust_id <> n.intnal_cust_id
        or o.cust_id <> n.cust_id
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.tran_med_type_cd <> n.tran_med_type_cd
        or o.tran_acct_id <> n.tran_acct_id
        or o.ta_cd <> n.ta_cd
        or o.finc_acct_id <> n.finc_acct_id
        or o.cont_id <> n.cont_id
        or o.final_chg_dt <> n.final_chg_dt
        or o.lot_tot <> n.lot_tot
        or o.tran_froz_lot <> n.tran_froz_lot
        or o.lonterm_froz_lot <> n.lonterm_froz_lot
        or o.comb_invest_lot <> n.comb_invest_lot
        or o.divd_way_cd <> n.divd_way_cd
        or o.init_divd_way_cd <> n.init_divd_way_cd
        or o.bonus_ratio <> n.bonus_ratio
        or o.yd_lot_tot <> n.yd_lot_tot
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.supp_invest_flg <> n.supp_invest_flg
        or o.loc_froz_lot <> n.loc_froz_lot
        or o.curr_issue_prft <> n.curr_issue_prft
        or o.prft_cust_ratio <> n.prft_cust_ratio
        or o.buy_cost <> n.buy_cost
        or o.acm_inco <> n.acm_inco
        or o.unpaid_prft <> n.unpaid_prft
        or o.froz_unpaid_prft <> n.froz_unpaid_prft
        or o.new_assign_prft <> n.new_assign_prft
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_trust_lot_h_trusf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_trust_lot_h_trusf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,std_prod_id -- 标准产品编号
    ,intnal_cust_id -- 内部客户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,cont_id -- 合约编号
    ,final_chg_dt -- 最后变动日期
    ,lot_tot -- 份额总数
    ,tran_froz_lot -- 交易冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,bonus_ratio -- 红利比例
    ,yd_lot_tot -- 昨日份额总数
    ,open_acct_org_id -- 开户机构编号
    ,cust_type_cd -- 客户类型代码
    ,supp_invest_flg -- 追加投资标志
    ,loc_froz_lot -- 本地冻结份额
    ,curr_issue_prft -- 本期收益
    ,prft_cust_ratio -- 收益客户比例
    ,buy_cost -- 买入成本
    ,acm_inco -- 累计收入
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.std_prod_id -- 标准产品编号
    ,o.intnal_cust_id -- 内部客户编号
    ,o.seller_id -- 销售商编号
    ,o.bank_id -- 银行编号
    ,o.cust_id -- 客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.tran_med_type_cd -- 交易介质类型代码
    ,o.tran_acct_id -- 交易账户编号
    ,o.ta_cd -- TA代码
    ,o.finc_acct_id -- 理财账户编号
    ,o.prod_id -- 产品编号
    ,o.cont_id -- 合约编号
    ,o.final_chg_dt -- 最后变动日期
    ,o.lot_tot -- 份额总数
    ,o.tran_froz_lot -- 交易冻结份额
    ,o.lonterm_froz_lot -- 长期冻结份额
    ,o.comb_invest_lot -- 组合投资份额
    ,o.divd_way_cd -- 分红方式代码
    ,o.init_divd_way_cd -- 原分红方式代码
    ,o.bonus_ratio -- 红利比例
    ,o.yd_lot_tot -- 昨日份额总数
    ,o.open_acct_org_id -- 开户机构编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.supp_invest_flg -- 追加投资标志
    ,o.loc_froz_lot -- 本地冻结份额
    ,o.curr_issue_prft -- 本期收益
    ,o.prft_cust_ratio -- 收益客户比例
    ,o.buy_cost -- 买入成本
    ,o.acm_inco -- 累计收入
    ,o.unpaid_prft -- 未付收益
    ,o.froz_unpaid_prft -- 冻结未付收益
    ,o.new_assign_prft -- 新分配收益
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
from ${iml_schema}.agt_trust_lot_h_trusf1_bk o
    left join ${iml_schema}.agt_trust_lot_h_trusf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.bank_id = n.bank_id
            and o.bank_acct_id = n.bank_acct_id
            and o.prod_id = n.prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_trust_lot_h_trusf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.seller_id = d.seller_id
            and o.bank_id = d.bank_id
            and o.bank_acct_id = d.bank_acct_id
            and o.prod_id = d.prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_trust_lot_h;
--alter table ${iml_schema}.agt_trust_lot_h truncate partition for ('trusf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_trust_lot_h') 
               and substr(subpartition_name,1,8)=upper('p_trusf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_trust_lot_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_trust_lot_h modify partition p_trusf1 
add subpartition p_trusf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_trust_lot_h exchange subpartition p_trusf1_${batch_date} with table ${iml_schema}.agt_trust_lot_h_trusf1_cl;
alter table ${iml_schema}.agt_trust_lot_h exchange subpartition p_trusf1_20991231 with table ${iml_schema}.agt_trust_lot_h_trusf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_trust_lot_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_tm purge;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_op purge;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_trust_lot_h_trusf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_trust_lot_h', partname => 'p_trusf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
