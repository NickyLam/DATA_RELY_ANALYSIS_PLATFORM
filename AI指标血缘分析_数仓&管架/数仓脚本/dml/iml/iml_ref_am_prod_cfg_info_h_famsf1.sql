/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_am_prod_cfg_info_h_famsf1
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
drop table ${iml_schema}.ref_am_prod_cfg_info_h_famsf1_tm purge;
alter table ${iml_schema}.ref_am_prod_cfg_info_h add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_am_prod_cfg_info_h modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_am_prod_cfg_info_h_famsf1_tm
compress ${option_switch} for query high
as
select
    finc_prod_id -- 理财产品编号
    ,lp_id -- 法人编号
    ,acctnt_cls -- 会计分类
    ,asset_id -- 资产编号
    ,stat_dt -- 统计日期
    ,prod_type -- 产品类型
    ,prod_name -- 产品名称
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,paid_in_capital -- 实收资本
    ,cust_yld_rat -- 客户收益率
    ,asset_type -- 资产类型
    ,asset_name -- 资产名称
    ,fac_val -- 面值
    ,buy_net_price_cost -- 买入净价成本
    ,int_adj -- 利息调整
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,int_recvbl -- 应收利息
    ,acru_int -- 应计利息
    ,bond_evltion_net_price -- 债券估值净价
    ,asset_impam_amt -- 资产减值金额
    ,evha_val_chag -- 公允价值变动
    ,fac_val_int_rat -- 票面利率
    ,actl_int_rat -- 实际利率
    ,repo_int_rat -- 回购利率
    ,asset_value_dt -- 资产起息日期
    ,asset_matu_dt -- 资产到期日期
    ,issue_price -- 发行价格
    ,pay_int_freq -- 付息频率
    ,rpp_freq -- 还本频率
    ,last_pay_int_dt -- 上一付息日期
    ,int_accr_base -- 计息基准
    ,pay_status -- 支付状态
    ,last_int_accr_begin_dt -- 上一计息起始日期
    ,last_int_accr_end_dt -- 上一计息结束日期
    ,prft_type_cd -- 收益类型代码
    ,g06_pente_bf_asset_cls_cd -- G06穿透前资产分类代码
    ,g06_pente_post_asset_cls_cd -- G06穿透后资产分类代码
    ,exp_yld_rat -- 到期收益率
    ,asset_level1_cls_cd -- 资产一级分类代码
    ,asset_level2_cls_cd -- 资产二级分类代码
    ,asset_level3_cls_cd -- 资产三级分类代码
    ,asset_level4_cls_cd -- 资产四级分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_am_prod_cfg_info_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_rep_prod_config_statistics-1
insert into ${iml_schema}.ref_am_prod_cfg_info_h_famsf1_tm(
    finc_prod_id -- 理财产品编号
    ,acctnt_cls -- 法人编号
    ,lp_id -- 会计分类
    ,asset_id -- 资产编号
    ,stat_dt -- 统计日期
    ,prod_type -- 产品类型
    ,prod_name -- 产品名称
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,paid_in_capital -- 实收资本
    ,cust_yld_rat -- 客户收益率
    ,asset_type -- 资产类型
    ,asset_name -- 资产名称
    ,fac_val -- 面值
    ,buy_net_price_cost -- 买入净价成本
    ,int_adj -- 利息调整
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,int_recvbl -- 应收利息
    ,acru_int -- 应计利息
    ,bond_evltion_net_price -- 债券估值净价
    ,asset_impam_amt -- 资产减值金额
    ,evha_val_chag -- 公允价值变动
    ,fac_val_int_rat -- 票面利率
    ,actl_int_rat -- 实际利率
    ,repo_int_rat -- 回购利率
    ,asset_value_dt -- 资产起息日期
    ,asset_matu_dt -- 资产到期日期
    ,issue_price -- 发行价格
    ,pay_int_freq -- 付息频率
    ,rpp_freq -- 还本频率
    ,last_pay_int_dt -- 上一付息日期
    ,int_accr_base -- 计息基准
    ,pay_status -- 支付状态
    ,last_int_accr_begin_dt -- 上一计息起始日期
    ,last_int_accr_end_dt -- 上一计息结束日期
    ,prft_type_cd -- 收益类型代码
    ,g06_pente_bf_asset_cls_cd -- G06穿透前资产分类代码
    ,g06_pente_post_asset_cls_cd -- G06穿透后资产分类代码
    ,exp_yld_rat -- 到期收益率
    ,asset_level1_cls_cd -- 资产一级分类代码
    ,asset_level2_cls_cd -- 资产二级分类代码
    ,asset_level3_cls_cd -- 资产三级分类代码
    ,asset_level4_cls_cd -- 资产四级分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRODCODE -- 理财产品编号
    ,P1.BOOKTYPE -- 法人编号
    ,'9999' -- 会计分类
    ,P1.ASSETCODE -- 资产编号
    ,${iml_schema}.dateformat_max2(P1.CDATE) -- 统计日期
    ,P1.ACCOUNTTYPE -- 产品类型
    ,P1.PRODNAME -- 产品名称
    ,${iml_schema}.dateformat_min(P1.PRODVDATE) -- 产品起息日期
    ,${iml_schema}.dateformat_max2(P1.PRODMDATE) -- 产品到期日期
    ,P1.ACTPRINAMT -- 实收资本
    ,to_number(nvl(trim(P1.CUSTRATE),'0')) -- 客户收益率
    ,P1.ASSETTYPE -- 资产类型
    ,P1.ASSETNAME -- 资产名称
    ,P1.FACEAMT -- 面值
    ,P1.NETCOST -- 买入净价成本
    ,P1.INTADJUST -- 利息调整
    ,P1.FIRSTAMT -- 首期结算金额
    ,P1.EXPIREAMT -- 到期结算金额
    ,P1.UNPAYAMT1 -- 应收利息
    ,P1.UNPAYAMT2 -- 应计利息
    ,P1.NETVALUATION -- 债券估值净价
    ,P1.TDYLOSSAMT -- 资产减值金额
    ,P1.FAIRVALUE -- 公允价值变动
    ,P1.FACERATE -- 票面利率
    ,P1.ACTRATE -- 实际利率
    ,P1.REPORATE -- 回购利率
    ,${iml_schema}.dateformat_min(P1.ASSETVDATE) -- 资产起息日期
    ,${iml_schema}.dateformat_max2(P1.ASSETMDATE) -- 资产到期日期
    ,P1.ISSUEPRICE -- 发行价格
    ,P1.INTFREQUENCY -- 付息频率
    ,P1.PAYFREQUENCY -- 还本频率
    ,${iml_schema}.dateformat_min(P1.LASTPAYDATE) -- 上一付息日期
    ,P1.BASIS -- 计息基准
    ,P1.PAYSTATUS -- 支付状态
    ,${iml_schema}.dateformat_min(P1.LASTVDATE) -- 上一计息起始日期
    ,${iml_schema}.dateformat_max2(P1.LASTMDATE) -- 上一计息结束日期
    ,nvl(trim(P1.PROFITTYPE),'-') -- 收益类型代码
    ,nvl(trim(P1.ASSETTYPEBEFOREG60),'-') -- G06穿透前资产分类代码
    ,nvl(trim(P1.ASSETTYPEAFTERG60),'-') -- G06穿透后资产分类代码
    ,P1.SECYIELD -- 到期收益率
    ,nvl(trim(P1.ASSETTYPEONE),'-') -- 资产一级分类代码
    ,nvl(trim(P1.ASSETTYPETWO),'100799') -- 资产二级分类代码
    ,nvl(trim(P1.ASSETTYPETHREE),'-') -- 资产三级分类代码
    ,nvl(trim(P1.ASSTTYPEFOUR),'1003020611') -- 资产四级分类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_rep_prod_config_statistics' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_rep_prod_config_statistics p1
where p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.ref_am_prod_cfg_info_h truncate subpartition p_famsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.ref_am_prod_cfg_info_h exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.ref_am_prod_cfg_info_h_famsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_am_prod_cfg_info_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_am_prod_cfg_info_h_famsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_am_prod_cfg_info_h', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);