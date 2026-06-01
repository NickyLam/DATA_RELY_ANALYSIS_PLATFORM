/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_am_non_std_asset_tran_famsf1
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
drop table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_am_non_std_asset_tran add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_am_non_std_asset_tran modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_am_non_std_asset_tran partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,acru_int -- 应计利息
    ,bag_pric -- 成交本金
    ,dlvyd_acru_int_tot -- 交割日应计利息总额
    ,tot_dlvy_amt -- 总交割金额
    ,actl_yld_rat -- 实际收益率
    ,valid_flg -- 有效标志
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,tran_type_cd -- 交易类型代码
    ,init_tran_flg -- 原始交易标志
    ,asset_tran_dt -- 资产转移日期
    ,last_pay_int_dt -- 上次付息日期
    ,int_paybl_tot -- 应付利息总额
    ,wrtoff_dt -- 冲销日期
    ,effect_dt -- 生效日期
    ,actl_pay_dt -- 实际支付日期
    ,expe_yld_rat -- 预期收益率
    ,curr_cd -- 币种代码
    ,non_std_tran_id -- 非标交易编号
    ,acru_int_tot -- 应计利息总额
    ,unpaid_int_int_flg -- 未付息利息标志
    ,rpp_day_post -- 还本日持仓
    ,rev_tran_flow_num -- 反向交易流水号
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,asset_cls4_cd -- 资产四分类代码
    ,input_way_cd -- 录入方式代码
    ,tran_odd_no -- 交易单号
    ,corp_net_price -- 单位净价
    ,net_price_tot -- 净价总额
    ,corp_full_price -- 单位全价
    ,exp_yld_rat -- 到期收益率
    ,col_int_flow_num -- 收息流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_non_std_asset_tran
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_am_non_std_asset_tran partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_tru_deal-
insert into ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,acru_int -- 应计利息
    ,bag_pric -- 成交本金
    ,dlvyd_acru_int_tot -- 交割日应计利息总额
    ,tot_dlvy_amt -- 总交割金额
    ,actl_yld_rat -- 实际收益率
    ,valid_flg -- 有效标志
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,tran_type_cd -- 交易类型代码
    ,init_tran_flg -- 原始交易标志
    ,asset_tran_dt -- 资产转移日期
    ,last_pay_int_dt -- 上次付息日期
    ,int_paybl_tot -- 应付利息总额
    ,wrtoff_dt -- 冲销日期
    ,effect_dt -- 生效日期
    ,actl_pay_dt -- 实际支付日期
    ,expe_yld_rat -- 预期收益率
    ,curr_cd -- 币种代码
    ,non_std_tran_id -- 非标交易编号
    ,acru_int_tot -- 应计利息总额
    ,unpaid_int_int_flg -- 未付息利息标志
    ,rpp_day_post -- 还本日持仓
    ,rev_tran_flow_num -- 反向交易流水号
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,asset_cls4_cd -- 资产四分类代码
    ,input_way_cd -- 录入方式代码
    ,tran_odd_no -- 交易单号
    ,corp_net_price -- 单位净价
    ,net_price_tot -- 净价总额
    ,corp_full_price -- 单位全价
    ,exp_yld_rat -- 到期收益率
    ,col_int_flow_num -- 收息流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225107'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 交易流水号
    ,P1.TRADEID -- 业务编号
    ,P1.SOURCE -- 线上标志
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.INPUTDATE)) -- 录入日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.DEALDATE)) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 交割日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 到期日期
    ,P1.COUNTERID -- 交易对手编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.COUNTERTYPE END -- 交易对手类型代码
    ,P1.ACCOUNT -- 本方账户编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PS END -- 交易方向代码
    ,P1.TRUSTUUID -- 产品编号
    ,P1.ACCUIR -- 应计利息
    ,P1.PRINAMT -- 成交本金
    ,P1.ACCUIRAMT -- 交割日应计利息总额
    ,P1.SETTAMT -- 总交割金额
    ,P1.YIELD -- 实际收益率
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.HOMETRADER -- 本方交易员编号
    ,P1.COUNTERTRADER -- 对手方交易员编号
    ,P1.DEALTYPE -- 交易类型代码
    ,P1.ISORIGINAL -- 原始交易标志
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.SETTDATE)) -- 资产转移日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.LASTINTPAYDATE)) -- 上次付息日期
    ,P1.THEORYREPAYPRINAMT -- 应付利息总额
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.REVDATE)) -- 冲销日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.EFFDATE)) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.ACTPAYDATE)) -- 实际支付日期
    ,P1.BASICYIELD -- 预期收益率
    ,P1.CCY -- 币种代码
    ,P1.TRPRUUID -- 非标交易编号
    ,P1.TOTALACCUIRAMT -- 应计利息总额
    ,P1.TRANSFERTYPE -- 未付息利息标志
    ,P1.ACTPOSITIONAMT -- 还本日持仓
    ,P1.REVSEQNO -- 反向交易流水号
    ,P1.FATHERSEQNO -- 父交易编号
    ,P1.ORIGINALSEQNO -- 原交易编号
    ,P1.REFSEQNO -- 转仓流水号
    ,P1.SPLITFLAG -- 拆分交易标志
    ,P1.TRADEMODE -- 资产池标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.INVESTTYPE END -- 资产四分类代码
    ,nvl(trim(P1.CALTYPE),'-') -- 录入方式代码
    ,P1.TRADENO -- 交易单号
    ,P1.CPRICE -- 单位净价
    ,P1.CPRICEAMT -- 净价总额
    ,P1.DPRICE -- 单位全价
    ,P1.MYIELD -- 到期收益率
    ,P1.SERIALNO -- 收息流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_tru_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_tru_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COUNTERTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_TRU_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'COUNTERTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AM_NON_STD_ASSET_TRAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_TRU_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'PS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AM_NON_STD_ASSET_TRAN'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.INVESTTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_TRU_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'INVESTTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AM_NON_STD_ASSET_TRAN'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ASSET_CLS4_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_am_non_std_asset_tran_famsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,acru_int -- 应计利息
    ,bag_pric -- 成交本金
    ,dlvyd_acru_int_tot -- 交割日应计利息总额
    ,tot_dlvy_amt -- 总交割金额
    ,actl_yld_rat -- 实际收益率
    ,valid_flg -- 有效标志
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,tran_type_cd -- 交易类型代码
    ,init_tran_flg -- 原始交易标志
    ,asset_tran_dt -- 资产转移日期
    ,last_pay_int_dt -- 上次付息日期
    ,int_paybl_tot -- 应付利息总额
    ,wrtoff_dt -- 冲销日期
    ,effect_dt -- 生效日期
    ,actl_pay_dt -- 实际支付日期
    ,expe_yld_rat -- 预期收益率
    ,curr_cd -- 币种代码
    ,non_std_tran_id -- 非标交易编号
    ,acru_int_tot -- 应计利息总额
    ,unpaid_int_int_flg -- 未付息利息标志
    ,rpp_day_post -- 还本日持仓
    ,rev_tran_flow_num -- 反向交易流水号
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,asset_cls4_cd -- 资产四分类代码
    ,input_way_cd -- 录入方式代码
    ,tran_odd_no -- 交易单号
    ,corp_net_price -- 单位净价
    ,net_price_tot -- 净价总额
    ,corp_full_price -- 单位全价
    ,exp_yld_rat -- 到期收益率
    ,col_int_flow_num -- 收息流水号
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 线上标志
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.dlvy_dt, o.dlvy_dt) as dlvy_dt -- 交割日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_type_cd, o.cntpty_type_cd) as cntpty_type_cd -- 交易对手类型代码
    ,nvl(n.ghb_acct_id, o.ghb_acct_id) as ghb_acct_id -- 本方账户编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.bag_pric, o.bag_pric) as bag_pric -- 成交本金
    ,nvl(n.dlvyd_acru_int_tot, o.dlvyd_acru_int_tot) as dlvyd_acru_int_tot -- 交割日应计利息总额
    ,nvl(n.tot_dlvy_amt, o.tot_dlvy_amt) as tot_dlvy_amt -- 总交割金额
    ,nvl(n.actl_yld_rat, o.actl_yld_rat) as actl_yld_rat -- 实际收益率
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.ghb_dealer_id, o.ghb_dealer_id) as ghb_dealer_id -- 本方交易员编号
    ,nvl(n.cntpty_dealer_id, o.cntpty_dealer_id) as cntpty_dealer_id -- 对手方交易员编号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.init_tran_flg, o.init_tran_flg) as init_tran_flg -- 原始交易标志
    ,nvl(n.asset_tran_dt, o.asset_tran_dt) as asset_tran_dt -- 资产转移日期
    ,nvl(n.last_pay_int_dt, o.last_pay_int_dt) as last_pay_int_dt -- 上次付息日期
    ,nvl(n.int_paybl_tot, o.int_paybl_tot) as int_paybl_tot -- 应付利息总额
    ,nvl(n.wrtoff_dt, o.wrtoff_dt) as wrtoff_dt -- 冲销日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.actl_pay_dt, o.actl_pay_dt) as actl_pay_dt -- 实际支付日期
    ,nvl(n.expe_yld_rat, o.expe_yld_rat) as expe_yld_rat -- 预期收益率
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.non_std_tran_id, o.non_std_tran_id) as non_std_tran_id -- 非标交易编号
    ,nvl(n.acru_int_tot, o.acru_int_tot) as acru_int_tot -- 应计利息总额
    ,nvl(n.unpaid_int_int_flg, o.unpaid_int_int_flg) as unpaid_int_int_flg -- 未付息利息标志
    ,nvl(n.rpp_day_post, o.rpp_day_post) as rpp_day_post -- 还本日持仓
    ,nvl(n.rev_tran_flow_num, o.rev_tran_flow_num) as rev_tran_flow_num -- 反向交易流水号
    ,nvl(n.parent_tran_id, o.parent_tran_id) as parent_tran_id -- 父交易编号
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.trans_flow_num, o.trans_flow_num) as trans_flow_num -- 转仓流水号
    ,nvl(n.splt_tran_flg, o.splt_tran_flg) as splt_tran_flg -- 拆分交易标志
    ,nvl(n.asset_pool_flg, o.asset_pool_flg) as asset_pool_flg -- 资产池标志
    ,nvl(n.asset_cls4_cd, o.asset_cls4_cd) as asset_cls4_cd -- 资产四分类代码
    ,nvl(n.input_way_cd, o.input_way_cd) as input_way_cd -- 录入方式代码
    ,nvl(n.tran_odd_no, o.tran_odd_no) as tran_odd_no -- 交易单号
    ,nvl(n.corp_net_price, o.corp_net_price) as corp_net_price -- 单位净价
    ,nvl(n.net_price_tot, o.net_price_tot) as net_price_tot -- 净价总额
    ,nvl(n.corp_full_price, o.corp_full_price) as corp_full_price -- 单位全价
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.col_int_flow_num, o.col_int_flow_num) as col_int_flow_num -- 收息流水号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.tran_flow_num <> n.tran_flow_num
                or o.bus_id <> n.bus_id
                or o.onl_flg <> n.onl_flg
                or o.input_dt <> n.input_dt
                or o.tran_dt <> n.tran_dt
                or o.dlvy_dt <> n.dlvy_dt
                or o.exp_dt <> n.exp_dt
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_type_cd <> n.cntpty_type_cd
                or o.ghb_acct_id <> n.ghb_acct_id
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.prod_id <> n.prod_id
                or o.acru_int <> n.acru_int
                or o.bag_pric <> n.bag_pric
                or o.dlvyd_acru_int_tot <> n.dlvyd_acru_int_tot
                or o.tot_dlvy_amt <> n.tot_dlvy_amt
                or o.actl_yld_rat <> n.actl_yld_rat
                or o.valid_flg <> n.valid_flg
                or o.ghb_dealer_id <> n.ghb_dealer_id
                or o.cntpty_dealer_id <> n.cntpty_dealer_id
                or o.tran_type_cd <> n.tran_type_cd
                or o.init_tran_flg <> n.init_tran_flg
                or o.asset_tran_dt <> n.asset_tran_dt
                or o.last_pay_int_dt <> n.last_pay_int_dt
                or o.int_paybl_tot <> n.int_paybl_tot
                or o.wrtoff_dt <> n.wrtoff_dt
                or o.effect_dt <> n.effect_dt
                or o.actl_pay_dt <> n.actl_pay_dt
                or o.expe_yld_rat <> n.expe_yld_rat
                or o.curr_cd <> n.curr_cd
                or o.non_std_tran_id <> n.non_std_tran_id
                or o.acru_int_tot <> n.acru_int_tot
                or o.unpaid_int_int_flg <> n.unpaid_int_int_flg
                or o.rpp_day_post <> n.rpp_day_post
                or o.rev_tran_flow_num <> n.rev_tran_flow_num
                or o.parent_tran_id <> n.parent_tran_id
                or o.init_tran_id <> n.init_tran_id
                or o.trans_flow_num <> n.trans_flow_num
                or o.splt_tran_flg <> n.splt_tran_flg
                or o.asset_pool_flg <> n.asset_pool_flg
                or o.asset_cls4_cd <> n.asset_cls4_cd
                or o.input_way_cd <> n.input_way_cd
                or o.tran_odd_no <> n.tran_odd_no
                or o.corp_net_price <> n.corp_net_price
                or o.net_price_tot <> n.net_price_tot
                or o.corp_full_price <> n.corp_full_price
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.col_int_flow_num <> n.col_int_flow_num
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
from ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm n
    full join ${iml_schema}.agt_am_non_std_asset_tran_famsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_am_non_std_asset_tran truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_am_non_std_asset_tran exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_am_non_std_asset_tran drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_am_non_std_asset_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_ex purge;
drop table ${iml_schema}.agt_am_non_std_asset_tran_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_am_non_std_asset_tran', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);