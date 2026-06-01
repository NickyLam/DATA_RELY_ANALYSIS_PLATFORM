/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ibank_dep_rcpt_ibmsf1
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
drop table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ibank_dep_rcpt add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ibank_dep_rcpt modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_dep_rcpt partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm
compress ${option_switch} for query high
as
select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dep_rcpt_cd -- 存单代码
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,curr_cd -- 币种代码
    ,quot_way_cd -- 报价方式代码
    ,dep_rcpt_name -- 存单名称
    ,prod_type_cd -- 产品类型代码
    ,prod_type_name -- 产品类型名称
    ,int_rat_pct_spd_bp -- 利率%、利差BP
    ,issue_qtty -- 发行量(亿元)
    ,issue_price -- 发行价格
    ,lowt_issue_price -- 最低发行价格
    ,higt_issue_price -- 最高发行价格
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor_val -- 期限值(天)
    ,fir_int_rat_cfm_dt -- 首次利率确定日期
    ,pay_int_freq_cd -- 付息频率代码
    ,issue_way_cd -- 发行方式代码
    ,coupon_type_cd -- 息票类型代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,stl_status_cd -- 结算状态代码
    ,pay_dt -- 缴款日期
    ,cash_dt -- 兑付日期
    ,issue_dt -- 发行日期
    ,annual_int_rat -- 年化利率
    ,int_accr_base_cd -- 计息基准代码
    ,fir_pay_int_dt -- 首次付息日期
    ,invt_bid_way_cd -- 招标方式代码
    ,lowt_yld_rat -- 最低收益率
    ,higt_yld_rat -- 最高收益率
    ,actl_issue_qtty -- 实际发行量(亿元)
    ,issuer_name -- 发行人名称
    ,range -- 范围
    ,rating_org -- 评级机构
    ,rating -- 评级
    ,fac_val -- 票面
    ,start_issue_dt -- 开始发行日期
    ,end_issue_dt -- 结束发行日期
    ,max_subscr_qtty -- 最大认购量
    ,min_subscr_qtty -- 最小认购量
    ,sig_max_subscr_qtty -- 单笔最大认购量
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_dep_rcpt
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ibank_dep_rcpt partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_otc_ncd-
insert into ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dep_rcpt_cd -- 存单代码
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,curr_cd -- 币种代码
    ,quot_way_cd -- 报价方式代码
    ,dep_rcpt_name -- 存单名称
    ,prod_type_cd -- 产品类型代码
    ,prod_type_name -- 产品类型名称
    ,int_rat_pct_spd_bp -- 利率%、利差BP
    ,issue_qtty -- 发行量(亿元)
    ,issue_price -- 发行价格
    ,lowt_issue_price -- 最低发行价格
    ,higt_issue_price -- 最高发行价格
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor_val -- 期限值(天)
    ,fir_int_rat_cfm_dt -- 首次利率确定日期
    ,pay_int_freq_cd -- 付息频率代码
    ,issue_way_cd -- 发行方式代码
    ,coupon_type_cd -- 息票类型代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,stl_status_cd -- 结算状态代码
    ,pay_dt -- 缴款日期
    ,cash_dt -- 兑付日期
    ,issue_dt -- 发行日期
    ,annual_int_rat -- 年化利率
    ,int_accr_base_cd -- 计息基准代码
    ,fir_pay_int_dt -- 首次付息日期
    ,invt_bid_way_cd -- 招标方式代码
    ,lowt_yld_rat -- 最低收益率
    ,higt_yld_rat -- 最高收益率
    ,actl_issue_qtty -- 实际发行量(亿元)
    ,issuer_name -- 发行人名称
    ,range -- 范围
    ,rating_org -- 评级机构
    ,rating -- 评级
    ,fac_val -- 票面
    ,start_issue_dt -- 开始发行日期
    ,end_issue_dt -- 结束发行日期
    ,max_subscr_qtty -- 最大认购量
    ,min_subscr_qtty -- 最小认购量
    ,sig_max_subscr_qtty -- 单笔最大认购量
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101007'||P1.INTORDID -- 凭证编号
    ,'9999' -- 法人编号
    ,P1.I_CODE -- 存单代码
    ,P1.A_TYPE -- 资产类型代码
    ,P1.M_TYPE -- 市场类型代码
    ,P1.CURRENCY -- 币种代码
    ,DECODE(trim(P1.Q_TYPE),'','-','CP',4,P1.Q_TYPE) -- 报价方式代码
    ,P1.B_NAME -- 存单名称
    ,P1.P_TYPE -- 产品类型代码
    ,P1.P_CLASS -- 产品类型名称
    ,P1.B_COUPON -- 利率%、利差BP
    ,P1.NCDCOUNT -- 发行量(亿元)
    ,P1.B_ISSUE_PRICE -- 发行价格
    ,P1.MIN_ISSUE_PRICE -- 最低发行价格
    ,P1.MAX_ISSUE_PRICE -- 最高发行价格
    ,${iml_schema}.dateformat_min(P1.B_START_DATE） -- 起息日期
    ,${iml_schema}.dateformat_max(P1.B_MTR_DATE) -- 到期日期
    ,P1.B_TERM -- 期限值(天)
    ,${iml_schema}.dateformat_min(P1.FIRST_DATE) -- 首次利率确定日期
    ,P1.B_PAY_FREQ -- 付息频率代码
    ,NVL(TRIM(P1.B_ISSUE_MODE),'-') -- 发行方式代码
    ,P1.B_COUPON_TYPE -- 息票类型代码
    ,P1.I_CODE_BENCH -- 基准利率编号
    ,P1.A_TYPE_BENCH -- 基准资产类型编号
    ,P1.M_TYPE_BENCH -- 基准市场类型编号
    ,NVL(TRIM(R1.insstatus),'-') -- 结算状态代码
    ,${iml_schema}.dateformat_max(P1.SET_DATE) -- 缴款日期
    ,${iml_schema}.dateformat_max(P1.HONOUR_DATE) -- 兑付日期
    ,${iml_schema}.dateformat_max(P1.B_ISSUE_DATE) -- 发行日期
    ,P1.ANNUAL_RATE -- 年化利率
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.B_DAYCOUNT END
end -- 计息基准代码
    ,${iml_schema}.dateformat_min(P1.B_FST_PAY_DATE) -- 首次付息日期
    ,NVL(TRIM(P1.TENDER_TYPE),'-') -- 招标方式代码
    ,P1.MIN_RATE -- 最低收益率
    ,P1.MAX_RATE -- 最高收益率
    ,P1.B_ACTUAL_ISSUE_AMOUNT -- 实际发行量(亿元)
    ,P1.ISSUER -- 发行人名称
    ,P1.ISSUERANGE -- 范围
    ,P1.GRADEINST -- 评级机构
    ,P1.GRADE -- 评级
    ,P1.PARVALUE -- 票面
    ,${iml_schema}.dateformat_min(P1.ISSUE_START_DATE) -- 开始发行日期
    ,${iml_schema}.dateformat_max(P1.ISSUE_MTR_DATE) -- 结束发行日期
    ,P1.MAX_BID_AMOUNT -- 最大认购量
    ,P1.MIN_BID_AMOUNT -- 最小认购量
    ,P1.SINGE_MAX_BID_AMOUNT -- 单笔最大认购量
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_otc_ncd' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_otc_ncd p1
    left join ${iol_schema}.ibms_ttrd_otc_trade r1 on P1.INTORDID = R1.INTORDID 
AND R1.ETL_DT <= TO_DATE('${batch_date}','YYYYMMDD') 
AND R1.REF_SYSORDID = 0   --表示主交易单
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.B_DAYCOUNT = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_OTC_NCD'
        AND R3.SRC_FIELD_EN_NAME= 'B_DAYCOUNT'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_IBANK_DEP_RCPT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm 
  	                                group by 
  	                                        vouch_id
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
insert /*+ append */ into ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_ex(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dep_rcpt_cd -- 存单代码
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,curr_cd -- 币种代码
    ,quot_way_cd -- 报价方式代码
    ,dep_rcpt_name -- 存单名称
    ,prod_type_cd -- 产品类型代码
    ,prod_type_name -- 产品类型名称
    ,int_rat_pct_spd_bp -- 利率%、利差BP
    ,issue_qtty -- 发行量(亿元)
    ,issue_price -- 发行价格
    ,lowt_issue_price -- 最低发行价格
    ,higt_issue_price -- 最高发行价格
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor_val -- 期限值(天)
    ,fir_int_rat_cfm_dt -- 首次利率确定日期
    ,pay_int_freq_cd -- 付息频率代码
    ,issue_way_cd -- 发行方式代码
    ,coupon_type_cd -- 息票类型代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,stl_status_cd -- 结算状态代码
    ,pay_dt -- 缴款日期
    ,cash_dt -- 兑付日期
    ,issue_dt -- 发行日期
    ,annual_int_rat -- 年化利率
    ,int_accr_base_cd -- 计息基准代码
    ,fir_pay_int_dt -- 首次付息日期
    ,invt_bid_way_cd -- 招标方式代码
    ,lowt_yld_rat -- 最低收益率
    ,higt_yld_rat -- 最高收益率
    ,actl_issue_qtty -- 实际发行量(亿元)
    ,issuer_name -- 发行人名称
    ,range -- 范围
    ,rating_org -- 评级机构
    ,rating -- 评级
    ,fac_val -- 票面
    ,start_issue_dt -- 开始发行日期
    ,end_issue_dt -- 结束发行日期
    ,max_subscr_qtty -- 最大认购量
    ,min_subscr_qtty -- 最小认购量
    ,sig_max_subscr_qtty -- 单笔最大认购量
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dep_rcpt_cd, o.dep_rcpt_cd) as dep_rcpt_cd -- 存单代码
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.market_type_cd, o.market_type_cd) as market_type_cd -- 市场类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.quot_way_cd, o.quot_way_cd) as quot_way_cd -- 报价方式代码
    ,nvl(n.dep_rcpt_name, o.dep_rcpt_name) as dep_rcpt_name -- 存单名称
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_type_name, o.prod_type_name) as prod_type_name -- 产品类型名称
    ,nvl(n.int_rat_pct_spd_bp, o.int_rat_pct_spd_bp) as int_rat_pct_spd_bp -- 利率%、利差BP
    ,nvl(n.issue_qtty, o.issue_qtty) as issue_qtty -- 发行量(亿元)
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.lowt_issue_price, o.lowt_issue_price) as lowt_issue_price -- 最低发行价格
    ,nvl(n.higt_issue_price, o.higt_issue_price) as higt_issue_price -- 最高发行价格
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tenor_val, o.tenor_val) as tenor_val -- 期限值(天)
    ,nvl(n.fir_int_rat_cfm_dt, o.fir_int_rat_cfm_dt) as fir_int_rat_cfm_dt -- 首次利率确定日期
    ,nvl(n.pay_int_freq_cd, o.pay_int_freq_cd) as pay_int_freq_cd -- 付息频率代码
    ,nvl(n.issue_way_cd, o.issue_way_cd) as issue_way_cd -- 发行方式代码
    ,nvl(n.coupon_type_cd, o.coupon_type_cd) as coupon_type_cd -- 息票类型代码
    ,nvl(n.base_rat_id, o.base_rat_id) as base_rat_id -- 基准利率编号
    ,nvl(n.base_asset_type_id, o.base_asset_type_id) as base_asset_type_id -- 基准资产类型编号
    ,nvl(n.base_market_type_id, o.base_market_type_id) as base_market_type_id -- 基准市场类型编号
    ,nvl(n.stl_status_cd, o.stl_status_cd) as stl_status_cd -- 结算状态代码
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 缴款日期
    ,nvl(n.cash_dt, o.cash_dt) as cash_dt -- 兑付日期
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.annual_int_rat, o.annual_int_rat) as annual_int_rat -- 年化利率
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.invt_bid_way_cd, o.invt_bid_way_cd) as invt_bid_way_cd -- 招标方式代码
    ,nvl(n.lowt_yld_rat, o.lowt_yld_rat) as lowt_yld_rat -- 最低收益率
    ,nvl(n.higt_yld_rat, o.higt_yld_rat) as higt_yld_rat -- 最高收益率
    ,nvl(n.actl_issue_qtty, o.actl_issue_qtty) as actl_issue_qtty -- 实际发行量(亿元)
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(n.range, o.range) as range -- 范围
    ,nvl(n.rating_org, o.rating_org) as rating_org -- 评级机构
    ,nvl(n.rating, o.rating) as rating -- 评级
    ,nvl(n.fac_val, o.fac_val) as fac_val -- 票面
    ,nvl(n.start_issue_dt, o.start_issue_dt) as start_issue_dt -- 开始发行日期
    ,nvl(n.end_issue_dt, o.end_issue_dt) as end_issue_dt -- 结束发行日期
    ,nvl(n.max_subscr_qtty, o.max_subscr_qtty) as max_subscr_qtty -- 最大认购量
    ,nvl(n.min_subscr_qtty, o.min_subscr_qtty) as min_subscr_qtty -- 最小认购量
    ,nvl(n.sig_max_subscr_qtty, o.sig_max_subscr_qtty) as sig_max_subscr_qtty -- 单笔最大认购量
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.vouch_id is null
                and o.lp_id is null
            ) or (
                o.dep_rcpt_cd <> n.dep_rcpt_cd
                or o.asset_type_cd <> n.asset_type_cd
                or o.market_type_cd <> n.market_type_cd
                or o.curr_cd <> n.curr_cd
                or o.quot_way_cd <> n.quot_way_cd
                or o.dep_rcpt_name <> n.dep_rcpt_name
                or o.prod_type_cd <> n.prod_type_cd
                or o.prod_type_name <> n.prod_type_name
                or o.int_rat_pct_spd_bp <> n.int_rat_pct_spd_bp
                or o.issue_qtty <> n.issue_qtty
                or o.issue_price <> n.issue_price
                or o.lowt_issue_price <> n.lowt_issue_price
                or o.higt_issue_price <> n.higt_issue_price
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.tenor_val <> n.tenor_val
                or o.fir_int_rat_cfm_dt <> n.fir_int_rat_cfm_dt
                or o.pay_int_freq_cd <> n.pay_int_freq_cd
                or o.issue_way_cd <> n.issue_way_cd
                or o.coupon_type_cd <> n.coupon_type_cd
                or o.base_rat_id <> n.base_rat_id
                or o.base_asset_type_id <> n.base_asset_type_id
                or o.base_market_type_id <> n.base_market_type_id
                or o.stl_status_cd <> n.stl_status_cd
                or o.pay_dt <> n.pay_dt
                or o.cash_dt <> n.cash_dt
                or o.issue_dt <> n.issue_dt
                or o.annual_int_rat <> n.annual_int_rat
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.invt_bid_way_cd <> n.invt_bid_way_cd
                or o.lowt_yld_rat <> n.lowt_yld_rat
                or o.higt_yld_rat <> n.higt_yld_rat
                or o.actl_issue_qtty <> n.actl_issue_qtty
                or o.issuer_name <> n.issuer_name
                or o.range <> n.range
                or o.rating_org <> n.rating_org
                or o.rating <> n.rating
                or o.fac_val <> n.fac_val
                or o.start_issue_dt <> n.start_issue_dt
                or o.end_issue_dt <> n.end_issue_dt
                or o.max_subscr_qtty <> n.max_subscr_qtty
                or o.min_subscr_qtty <> n.min_subscr_qtty
                or o.sig_max_subscr_qtty <> n.sig_max_subscr_qtty
            ) or (
                 case when (
                           n.vouch_id is null
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
                n.vouch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm n
    full join ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_bk o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ibank_dep_rcpt truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ibank_dep_rcpt exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ibank_dep_rcpt drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ibank_dep_rcpt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_ex purge;
drop table ${iml_schema}.agt_ibank_dep_rcpt_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ibank_dep_rcpt', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);