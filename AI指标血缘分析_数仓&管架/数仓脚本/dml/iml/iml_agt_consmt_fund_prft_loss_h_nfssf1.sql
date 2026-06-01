/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_consmt_fund_prft_loss_h_nfssf1
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
alter table ${iml_schema}.agt_consmt_fund_prft_loss_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_prft_loss_h partition for ('nfssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op purge;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_consmt_fund_prft_loss_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_prft_loss_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_prft_loss_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tbshareext-
insert into ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170010'||P1.IN_CLIENT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 基金产品编号
    ,${iml_schema}.dateformat_min(P1.BEG_DATE) -- 期初日期
    ,P1.BEG_NAV -- 期初净值
    ,${iml_schema}.dateformat_max(P1.END_DATE) -- 期末日期
    ,P1.END_NAV -- 期末净值
    ,P1.TOT_VOL -- 基金份额
    ,P1.ALLOT_AMT -- 认购金额
    ,P1.ALLOT_CFM_AMT -- 认购确认金额
    ,P1.SUB_AMT -- 申购金额
    ,P1.AUTO_SUB_AMT -- 定投金额
    ,P1.CONV_IN_AMT -- 转换入金额
    ,P1.TRUST_IN_AMT -- 转托管入金额
    ,P1.ASSIGN_IN_AMT -- 非交易过户入金额
    ,P1.FORCE_ADD_AMT -- 份额强增折算金额
    ,P1.RED_AMT -- 赎回金额
    ,P1.FORCE_RED_AMT -- 强制赎回金额
    ,P1.CONV_OUT_AMT -- 转换出金额
    ,P1.TRUST_OUT_AMT -- 转托管出金额
    ,P1.ASSIGN_OUT_AMT -- 非交易过户出金额
    ,P1.DIV_VOL_AMT -- 分红份额折算金额
    ,P1.DIV_VOL -- 分红份额
    ,P1.DIV_AMT -- 分红金额
    ,P1.FUND_END_AMT -- 基金清盘及终止金额
    ,P1.FORCE_SUB_AMT -- 份额强减折算金额
    ,P1.INCOME_RATE*100 -- 投资收益率
    ,P1.TOTAL_COST -- 累计投入资金额
    ,P1.TOTAL_INCOME -- 累计投资收益
    ,P1.AVG_PRICE -- 平均买入价格
    ,P1.AMT3 -- 余额宝垫资收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbshareext' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbshareext p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,bank_acct_id
  	                                        ,bank_id
  	                                        ,fund_prod_id
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
        into ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
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
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.fund_prod_id, o.fund_prod_id) as fund_prod_id -- 基金产品编号
    ,nvl(n.tm_bg_dt, o.tm_bg_dt) as tm_bg_dt -- 期初日期
    ,nvl(n.tm_bg_nv, o.tm_bg_nv) as tm_bg_nv -- 期初净值
    ,nvl(n.term_end_dt, o.term_end_dt) as term_end_dt -- 期末日期
    ,nvl(n.term_end_nv, o.term_end_nv) as term_end_nv -- 期末净值
    ,nvl(n.fund_lot, o.fund_lot) as fund_lot -- 基金份额
    ,nvl(n.subscr_amt, o.subscr_amt) as subscr_amt -- 认购金额
    ,nvl(n.subscr_cfm_amt, o.subscr_cfm_amt) as subscr_cfm_amt -- 认购确认金额
    ,nvl(n.purch_amt, o.purch_amt) as purch_amt -- 申购金额
    ,nvl(n.aip_amt, o.aip_amt) as aip_amt -- 定投金额
    ,nvl(n.tran_in_amt, o.tran_in_amt) as tran_in_amt -- 转换入金额
    ,nvl(n.turn_trust_in_amt, o.turn_trust_in_amt) as turn_trust_in_amt -- 转托管入金额
    ,nvl(n.non_tran_tran_in_amt, o.non_tran_tran_in_amt) as non_tran_tran_in_amt -- 非交易过户入金额
    ,nvl(n.lot_man_incre_convt_amt, o.lot_man_incre_convt_amt) as lot_man_incre_convt_amt -- 份额强增折算金额
    ,nvl(n.redem_amt, o.redem_amt) as redem_amt -- 赎回金额
    ,nvl(n.force_redem_amt, o.force_redem_amt) as force_redem_amt -- 强制赎回金额
    ,nvl(n.tran_wdraw_lmt, o.tran_wdraw_lmt) as tran_wdraw_lmt -- 转换出金额
    ,nvl(n.turn_trust_wdraw_lmt, o.turn_trust_wdraw_lmt) as turn_trust_wdraw_lmt -- 转托管出金额
    ,nvl(n.non_tran_tran_wdraw_lmt, o.non_tran_tran_wdraw_lmt) as non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,nvl(n.divd_lot_convt_amt, o.divd_lot_convt_amt) as divd_lot_convt_amt -- 分红份额折算金额
    ,nvl(n.divd_lot, o.divd_lot) as divd_lot -- 分红份额
    ,nvl(n.divd_amt, o.divd_amt) as divd_amt -- 分红金额
    ,nvl(n.fund_liqd_and_termnt_amt, o.fund_liqd_and_termnt_amt) as fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,nvl(n.lot_man_reduc_convt_amt, o.lot_man_reduc_convt_amt) as lot_man_reduc_convt_amt -- 份额强减折算金额
    ,nvl(n.invest_yld_rat, o.invest_yld_rat) as invest_yld_rat -- 投资收益率
    ,nvl(n.acm_put_into_cap_lmt, o.acm_put_into_cap_lmt) as acm_put_into_cap_lmt -- 累计投入资金额
    ,nvl(n.acm_invest_prft, o.acm_invest_prft) as acm_invest_prft -- 累计投资收益
    ,nvl(n.avg_buy_price, o.avg_buy_price) as avg_buy_price -- 平均买入价格
    ,nvl(n.yeb_adv_prft, o.yeb_adv_prft) as yeb_adv_prft -- 余额宝垫资收益
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bank_acct_id is null
            and n.bank_id is null
            and n.fund_prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bank_acct_id is null
            and n.bank_id is null
            and n.fund_prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bank_acct_id is null
            and n.bank_id is null
            and n.fund_prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm n
    full join (select * from ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.bank_acct_id = n.bank_acct_id
            and o.bank_id = n.bank_id
            and o.fund_prod_id = n.fund_prod_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.bank_acct_id is null
        and o.bank_id is null
        and o.fund_prod_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.bank_acct_id is null
        and n.bank_id is null
        and n.fund_prod_id is null
    )
    or (
        o.intnal_cust_id <> n.intnal_cust_id
        or o.cust_id <> n.cust_id
        or o.ta_cd <> n.ta_cd
        or o.tm_bg_dt <> n.tm_bg_dt
        or o.tm_bg_nv <> n.tm_bg_nv
        or o.term_end_dt <> n.term_end_dt
        or o.term_end_nv <> n.term_end_nv
        or o.fund_lot <> n.fund_lot
        or o.subscr_amt <> n.subscr_amt
        or o.subscr_cfm_amt <> n.subscr_cfm_amt
        or o.purch_amt <> n.purch_amt
        or o.aip_amt <> n.aip_amt
        or o.tran_in_amt <> n.tran_in_amt
        or o.turn_trust_in_amt <> n.turn_trust_in_amt
        or o.non_tran_tran_in_amt <> n.non_tran_tran_in_amt
        or o.lot_man_incre_convt_amt <> n.lot_man_incre_convt_amt
        or o.redem_amt <> n.redem_amt
        or o.force_redem_amt <> n.force_redem_amt
        or o.tran_wdraw_lmt <> n.tran_wdraw_lmt
        or o.turn_trust_wdraw_lmt <> n.turn_trust_wdraw_lmt
        or o.non_tran_tran_wdraw_lmt <> n.non_tran_tran_wdraw_lmt
        or o.divd_lot_convt_amt <> n.divd_lot_convt_amt
        or o.divd_lot <> n.divd_lot
        or o.divd_amt <> n.divd_amt
        or o.fund_liqd_and_termnt_amt <> n.fund_liqd_and_termnt_amt
        or o.lot_man_reduc_convt_amt <> n.lot_man_reduc_convt_amt
        or o.invest_yld_rat <> n.invest_yld_rat
        or o.acm_put_into_cap_lmt <> n.acm_put_into_cap_lmt
        or o.acm_invest_prft <> n.acm_invest_prft
        or o.avg_buy_price <> n.avg_buy_price
        or o.yeb_adv_prft <> n.yeb_adv_prft
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_cust_id -- 内部客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,ta_cd -- TA代码
    ,fund_prod_id -- 基金产品编号
    ,tm_bg_dt -- 期初日期
    ,tm_bg_nv -- 期初净值
    ,term_end_dt -- 期末日期
    ,term_end_nv -- 期末净值
    ,fund_lot -- 基金份额
    ,subscr_amt -- 认购金额
    ,subscr_cfm_amt -- 认购确认金额
    ,purch_amt -- 申购金额
    ,aip_amt -- 定投金额
    ,tran_in_amt -- 转换入金额
    ,turn_trust_in_amt -- 转托管入金额
    ,non_tran_tran_in_amt -- 非交易过户入金额
    ,lot_man_incre_convt_amt -- 份额强增折算金额
    ,redem_amt -- 赎回金额
    ,force_redem_amt -- 强制赎回金额
    ,tran_wdraw_lmt -- 转换出金额
    ,turn_trust_wdraw_lmt -- 转托管出金额
    ,non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,divd_lot_convt_amt -- 分红份额折算金额
    ,divd_lot -- 分红份额
    ,divd_amt -- 分红金额
    ,fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt -- 份额强减折算金额
    ,invest_yld_rat -- 投资收益率
    ,acm_put_into_cap_lmt -- 累计投入资金额
    ,acm_invest_prft -- 累计投资收益
    ,avg_buy_price -- 平均买入价格
    ,yeb_adv_prft -- 余额宝垫资收益
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
    ,o.intnal_cust_id -- 内部客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.bank_id -- 银行编号
    ,o.cust_id -- 客户编号
    ,o.ta_cd -- TA代码
    ,o.fund_prod_id -- 基金产品编号
    ,o.tm_bg_dt -- 期初日期
    ,o.tm_bg_nv -- 期初净值
    ,o.term_end_dt -- 期末日期
    ,o.term_end_nv -- 期末净值
    ,o.fund_lot -- 基金份额
    ,o.subscr_amt -- 认购金额
    ,o.subscr_cfm_amt -- 认购确认金额
    ,o.purch_amt -- 申购金额
    ,o.aip_amt -- 定投金额
    ,o.tran_in_amt -- 转换入金额
    ,o.turn_trust_in_amt -- 转托管入金额
    ,o.non_tran_tran_in_amt -- 非交易过户入金额
    ,o.lot_man_incre_convt_amt -- 份额强增折算金额
    ,o.redem_amt -- 赎回金额
    ,o.force_redem_amt -- 强制赎回金额
    ,o.tran_wdraw_lmt -- 转换出金额
    ,o.turn_trust_wdraw_lmt -- 转托管出金额
    ,o.non_tran_tran_wdraw_lmt -- 非交易过户出金额
    ,o.divd_lot_convt_amt -- 分红份额折算金额
    ,o.divd_lot -- 分红份额
    ,o.divd_amt -- 分红金额
    ,o.fund_liqd_and_termnt_amt -- 基金清盘及终止金额
    ,o.lot_man_reduc_convt_amt -- 份额强减折算金额
    ,o.invest_yld_rat -- 投资收益率
    ,o.acm_put_into_cap_lmt -- 累计投入资金额
    ,o.acm_invest_prft -- 累计投资收益
    ,o.avg_buy_price -- 平均买入价格
    ,o.yeb_adv_prft -- 余额宝垫资收益
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
from ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_bk o
    left join ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.bank_acct_id = n.bank_acct_id
            and o.bank_id = n.bank_id
            and o.fund_prod_id = n.fund_prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.bank_acct_id = d.bank_acct_id
            and o.bank_id = d.bank_id
            and o.fund_prod_id = d.fund_prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_consmt_fund_prft_loss_h;
--alter table ${iml_schema}.agt_consmt_fund_prft_loss_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_consmt_fund_prft_loss_h') 
               and substr(subpartition_name,1,8)=upper('p_nfssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_consmt_fund_prft_loss_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_consmt_fund_prft_loss_h modify partition p_nfssf1 
add subpartition p_nfssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_consmt_fund_prft_loss_h exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl;
alter table ${iml_schema}.agt_consmt_fund_prft_loss_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_consmt_fund_prft_loss_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_op purge;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_consmt_fund_prft_loss_h', partname => 'p_nfssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
