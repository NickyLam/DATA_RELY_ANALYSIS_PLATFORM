/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_comb_prod_post_info_h_nfssf1
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
alter table ${iml_schema}.agt_comb_prod_post_info_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_comb_prod_post_info_h partition for ('nfssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op purge;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_comb_prod_post_info_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_comb_prod_post_info_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_comb_prod_post_info_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_hstctrans1_v_tbgrphissaleshare-1
insert into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300036'||P1.SELLER_CODE||P1.VIRTUAL_BANK_ACC||P1.PRD_CODE||P1.IMPORT_DATE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.VIRTUAL_BANK_ACC -- 虚拟银行账户编号
    ,P1.PRD_CODE -- 明细产品编号
    ,${iml_schema}.dateformat_min(P1.IMPORT_DATE) -- 导入日期
    ,P1.GROUP_CODE -- 组合产品编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,NVL(TRIM(P1.PRD_TYPE),'-') -- 产品类型代码
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标志代码
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易账户编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TOT_VOL -- 总份额
    ,P1.FROZEN_VOL -- 冻结份额
    ,P1.LONG_FROZEN_VOL -- 长期冻结份额
    ,P1.OTHER_FROZEN -- 本地冻结份额
    ,P1.GROUP_VOL -- 组合投资份额
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.DIV_RATE -- 分红比例
    ,P1.YSTDY_TOT_VOL -- 昨日总份额
    ,P1.TOT_AMT -- 总金额
    ,P1.COST -- 本金
    ,P1.USE_AMT -- 当前可用额度
    ,P1.PRD_VALUE -- 产品市值
    ,P1.TOT_INCOME -- 累计收入
    ,P1.ONWAY_AMT -- 在途资金
    ,P1.PROFIT_LOSS -- 浮动盈亏
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结的未付收益
    ,P1.INCOME_NEW -- 当天新增未付收益
    ,${iml_schema}.dateformat_max2(P1.INCOME_DATE) -- 收益日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_hstctrans1_v_tbgrphissaleshare' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_HSTCTRANS1_V_TBGRPHISSALESHARE'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_COMB_PROD_POST_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.import_date = ${batch_date} 
;
commit;

-- nfss_hstctrans1_v_tbgrpsaleshare-1
insert into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300036'||P1.SELLER_CODE||P1.VIRTUAL_BANK_ACC||P1.PRD_CODE||P1.IMPORT_DATE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.VIRTUAL_BANK_ACC -- 虚拟银行账户编号
    ,P1.PRD_CODE -- 明细产品编号
    ,${iml_schema}.dateformat_min(P1.IMPORT_DATE) -- 导入日期
    ,P1.GROUP_CODE -- 组合产品编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,NVL(TRIM(P1.PRD_TYPE),'-') -- 产品类型代码
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标志代码
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易账户编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TOT_VOL -- 总份额
    ,P1.FROZEN_VOL -- 冻结份额
    ,P1.LONG_FROZEN_VOL -- 长期冻结份额
    ,P1.OTHER_FROZEN -- 本地冻结份额
    ,P1.GROUP_VOL -- 组合投资份额
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.DIV_RATE -- 分红比例
    ,P1.YSTDY_TOT_VOL -- 昨日总份额
    ,P1.TOT_AMT -- 总金额
    ,P1.COST -- 本金
    ,P1.USE_AMT -- 当前可用额度
    ,P1.PRD_VALUE -- 产品市值
    ,P1.TOT_INCOME -- 累计收入
    ,P1.ONWAY_AMT -- 在途资金
    ,P1.PROFIT_LOSS -- 浮动盈亏
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结的未付收益
    ,P1.INCOME_NEW -- 当天新增未付收益
    ,${iml_schema}.dateformat_max2(P1.INCOME_DATE) -- 收益日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_hstctrans1_v_tbgrpsaleshare' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.client_type = r1.src_code_val
   and r1.sorc_sys_cd = 'NFSS'
   and r1.src_tab_en_name = 'NFSS_HSTCTRANS1_V_TBGRPHISSALESHARE'
   and r1.src_field_en_name = 'CLIENT_TYPE'
   and r1.target_tab_en_name = 'AGT_COMB_PROD_POST_INFO_H'
   and r1.target_tab_field_en_name = 'CUST_TYPE_CD'
 where not exists (select *
          from iol.nfss_hstctrans1_v_tbgrphissaleshare p2
         where p1.import_date = p2.import_date
           and p1.seller_code = p2.seller_code
           and p1.bank_no = p2.bank_no
           and p1.virtual_bank_acc = p2.virtual_bank_acc
           and p1.prd_code = p2.prd_code
           and p2.import_date = ${batch_date})
   and p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
   and p1.import_date = ${batch_date} 
 ;
commit;



commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
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
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.vtual_bank_acct_id, o.vtual_bank_acct_id) as vtual_bank_acct_id -- 虚拟银行账户编号
    ,nvl(n.dtl_prod_id, o.dtl_prod_id) as dtl_prod_id -- 明细产品编号
    ,nvl(n.imp_dt, o.imp_dt) as imp_dt -- 导入日期
    ,nvl(n.comb_prod_id, o.comb_prod_id) as comb_prod_id -- 组合产品编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.ec_flg_cd, o.ec_flg_cd) as ec_flg_cd -- 钞汇标志代码
    ,nvl(n.tran_med_type_cd, o.tran_med_type_cd) as tran_med_type_cd -- 交易介质类型代码
    ,nvl(n.tran_acct_id, o.tran_acct_id) as tran_acct_id -- 交易账户编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.tot_lot, o.tot_lot) as tot_lot -- 总份额
    ,nvl(n.froz_lot, o.froz_lot) as froz_lot -- 冻结份额
    ,nvl(n.lonterm_froz_lot, o.lonterm_froz_lot) as lonterm_froz_lot -- 长期冻结份额
    ,nvl(n.loc_froz_lot, o.loc_froz_lot) as loc_froz_lot -- 本地冻结份额
    ,nvl(n.comb_invest_lot, o.comb_invest_lot) as comb_invest_lot -- 组合投资份额
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.init_divd_way_cd, o.init_divd_way_cd) as init_divd_way_cd -- 原分红方式代码
    ,nvl(n.divd_ratio, o.divd_ratio) as divd_ratio -- 分红比例
    ,nvl(n.yd_tot_lot, o.yd_tot_lot) as yd_tot_lot -- 昨日总份额
    ,nvl(n.tot_amt, o.tot_amt) as tot_amt -- 总金额
    ,nvl(n.pric, o.pric) as pric -- 本金
    ,nvl(n.curr_aval_lmt, o.curr_aval_lmt) as curr_aval_lmt -- 当前可用额度
    ,nvl(n.prod_mk_val, o.prod_mk_val) as prod_mk_val -- 产品市值
    ,nvl(n.acm_inco, o.acm_inco) as acm_inco -- 累计收入
    ,nvl(n.cap, o.cap) as cap -- 在途资金
    ,nvl(n.float_prft_loss, o.float_prft_loss) as float_prft_loss -- 浮动盈亏
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.froz_unpaid_prft, o.froz_unpaid_prft) as froz_unpaid_prft -- 冻结的未付收益
    ,nvl(n.td_add_unpaid_prft, o.td_add_unpaid_prft) as td_add_unpaid_prft -- 当天新增未付收益
    ,nvl(n.prft_dt, o.prft_dt) as prft_dt -- 收益日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm n
    full join (select * from ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.seller_id <> n.seller_id
        or o.vtual_bank_acct_id <> n.vtual_bank_acct_id
        or o.dtl_prod_id <> n.dtl_prod_id
        or o.imp_dt <> n.imp_dt
        or o.comb_prod_id <> n.comb_prod_id
        or o.belong_org_id <> n.belong_org_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.intnal_cust_id <> n.intnal_cust_id
        or o.cust_id <> n.cust_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.prod_type_cd <> n.prod_type_cd
        or o.ec_flg_cd <> n.ec_flg_cd
        or o.tran_med_type_cd <> n.tran_med_type_cd
        or o.tran_acct_id <> n.tran_acct_id
        or o.ta_cd <> n.ta_cd
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.finc_acct_id <> n.finc_acct_id
        or o.tot_lot <> n.tot_lot
        or o.froz_lot <> n.froz_lot
        or o.lonterm_froz_lot <> n.lonterm_froz_lot
        or o.loc_froz_lot <> n.loc_froz_lot
        or o.comb_invest_lot <> n.comb_invest_lot
        or o.divd_way_cd <> n.divd_way_cd
        or o.init_divd_way_cd <> n.init_divd_way_cd
        or o.divd_ratio <> n.divd_ratio
        or o.yd_tot_lot <> n.yd_tot_lot
        or o.tot_amt <> n.tot_amt
        or o.pric <> n.pric
        or o.curr_aval_lmt <> n.curr_aval_lmt
        or o.prod_mk_val <> n.prod_mk_val
        or o.acm_inco <> n.acm_inco
        or o.cap <> n.cap
        or o.float_prft_loss <> n.float_prft_loss
        or o.unpaid_prft <> n.unpaid_prft
        or o.froz_unpaid_prft <> n.froz_unpaid_prft
        or o.td_add_unpaid_prft <> n.td_add_unpaid_prft
        or o.prft_dt <> n.prft_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,dtl_prod_id -- 明细产品编号
    ,imp_dt -- 导入日期
    ,comb_prod_id -- 组合产品编号
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ec_flg_cd -- 钞汇标志代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,ta_cd -- TA代码
    ,ta_tran_acct_id -- TA交易账户编号
    ,finc_acct_id -- 理财账户编号
    ,tot_lot -- 总份额
    ,froz_lot -- 冻结份额
    ,lonterm_froz_lot -- 长期冻结份额
    ,loc_froz_lot -- 本地冻结份额
    ,comb_invest_lot -- 组合投资份额
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,divd_ratio -- 分红比例
    ,yd_tot_lot -- 昨日总份额
    ,tot_amt -- 总金额
    ,pric -- 本金
    ,curr_aval_lmt -- 当前可用额度
    ,prod_mk_val -- 产品市值
    ,acm_inco -- 累计收入
    ,cap -- 在途资金
    ,float_prft_loss -- 浮动盈亏
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结的未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,prft_dt -- 收益日期
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
    ,o.seller_id -- 销售商编号
    ,o.vtual_bank_acct_id -- 虚拟银行账户编号
    ,o.dtl_prod_id -- 明细产品编号
    ,o.imp_dt -- 导入日期
    ,o.comb_prod_id -- 组合产品编号
    ,o.belong_org_id -- 所属机构编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.intnal_cust_id -- 内部客户编号
    ,o.cust_id -- 客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.prod_type_cd -- 产品类型代码
    ,o.ec_flg_cd -- 钞汇标志代码
    ,o.tran_med_type_cd -- 交易介质类型代码
    ,o.tran_acct_id -- 交易账户编号
    ,o.ta_cd -- TA代码
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.finc_acct_id -- 理财账户编号
    ,o.tot_lot -- 总份额
    ,o.froz_lot -- 冻结份额
    ,o.lonterm_froz_lot -- 长期冻结份额
    ,o.loc_froz_lot -- 本地冻结份额
    ,o.comb_invest_lot -- 组合投资份额
    ,o.divd_way_cd -- 分红方式代码
    ,o.init_divd_way_cd -- 原分红方式代码
    ,o.divd_ratio -- 分红比例
    ,o.yd_tot_lot -- 昨日总份额
    ,o.tot_amt -- 总金额
    ,o.pric -- 本金
    ,o.curr_aval_lmt -- 当前可用额度
    ,o.prod_mk_val -- 产品市值
    ,o.acm_inco -- 累计收入
    ,o.cap -- 在途资金
    ,o.float_prft_loss -- 浮动盈亏
    ,o.unpaid_prft -- 未付收益
    ,o.froz_unpaid_prft -- 冻结的未付收益
    ,o.td_add_unpaid_prft -- 当天新增未付收益
    ,o.prft_dt -- 收益日期
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
from ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_bk o
    left join ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_comb_prod_post_info_h;
--alter table ${iml_schema}.agt_comb_prod_post_info_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_comb_prod_post_info_h') 
               and substr(subpartition_name,1,8)=upper('p_nfssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_comb_prod_post_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_comb_prod_post_info_h modify partition p_nfssf1 
add subpartition p_nfssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_comb_prod_post_info_h exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl;
alter table ${iml_schema}.agt_comb_prod_post_info_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_comb_prod_post_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_op purge;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_comb_prod_post_info_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_comb_prod_post_info_h', partname => 'p_nfssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
