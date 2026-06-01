/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_finnotesdetail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_finnotesdetail_ex purge;
alter table ${iol_schema}.wind_finnotesdetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_finnotesdetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_finnotesdetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_finnotesdetail where 0=1;

insert /*+ append */ into ${iol_schema}.wind_finnotesdetail_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,bd_loss -- 坏账损失
    ,inv_loss -- 存货跌价损失
    ,gi_loss -- 商誉减值损失
    ,gc_loss -- 发放贷款和垫款减值损失
    ,afa_loss -- 可供出售金融资产减值损失
    ,hi_loss -- 持有至到期投资减值损失
    ,oth_loss -- 其他金融资产减值损失
    ,lti_invinc -- 处置长期股权投资产生的投资收益
    ,fat_invinc -- 处置交易性金融资产取得的投资收益
    ,afa_invinc -- 处置可供出售金融资产取得的投资收益
    ,paei_invinc -- 委托投资损益
    ,fel_invinc -- 对外委托贷款取得的收益
    ,cfeo_invinc -- 受托经营取得的托管费收入
    ,othn_invinc -- 其他非经常性投资收益
    ,lti_cost -- 成本法核算的长期股权投资收益
    ,lur_orival -- 土地使用权-原值
    ,lur_acca -- 土地使用权-累计摊销
    ,lur_imp -- 土地使用权-减值准备
    ,lur_bookval -- 土地使用权-账面价值
    ,lti_equ -- 权益法核算的长期股权投资
    ,monf_res -- 受限制的货币资金
    ,sal_cos -- 工资薪酬(销售费用)
    ,sal_gex -- 工资薪酬(管理费用)
    ,da_cos -- 折旧摊销(销售费用)
    ,da_gex -- 折旧摊销(管理费用)
    ,ren_cos -- 租赁费(销售费用)
    ,ren_gex -- 租赁费(管理费用)
    ,stc_cos -- 仓储运输费(销售费用)
    ,ape_cos -- 广告宣传推广费(销售费用)
    ,ltloan_1y -- 1年内到期的长期借款
    ,bondpay_1y -- 1年内到期的应付债券
    ,stfinbond -- 短期融资债(其他流动负债)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,bd_loss -- 坏账损失
    ,inv_loss -- 存货跌价损失
    ,gi_loss -- 商誉减值损失
    ,gc_loss -- 发放贷款和垫款减值损失
    ,afa_loss -- 可供出售金融资产减值损失
    ,hi_loss -- 持有至到期投资减值损失
    ,oth_loss -- 其他金融资产减值损失
    ,lti_invinc -- 处置长期股权投资产生的投资收益
    ,fat_invinc -- 处置交易性金融资产取得的投资收益
    ,afa_invinc -- 处置可供出售金融资产取得的投资收益
    ,paei_invinc -- 委托投资损益
    ,fel_invinc -- 对外委托贷款取得的收益
    ,cfeo_invinc -- 受托经营取得的托管费收入
    ,othn_invinc -- 其他非经常性投资收益
    ,lti_cost -- 成本法核算的长期股权投资收益
    ,lur_orival -- 土地使用权-原值
    ,lur_acca -- 土地使用权-累计摊销
    ,lur_imp -- 土地使用权-减值准备
    ,lur_bookval -- 土地使用权-账面价值
    ,lti_equ -- 权益法核算的长期股权投资
    ,monf_res -- 受限制的货币资金
    ,sal_cos -- 工资薪酬(销售费用)
    ,sal_gex -- 工资薪酬(管理费用)
    ,da_cos -- 折旧摊销(销售费用)
    ,da_gex -- 折旧摊销(管理费用)
    ,ren_cos -- 租赁费(销售费用)
    ,ren_gex -- 租赁费(管理费用)
    ,stc_cos -- 仓储运输费(销售费用)
    ,ape_cos -- 广告宣传推广费(销售费用)
    ,ltloan_1y -- 1年内到期的长期借款
    ,bondpay_1y -- 1年内到期的应付债券
    ,stfinbond -- 短期融资债(其他流动负债)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_finnotesdetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_finnotesdetail exchange partition p_${batch_date} with table ${iol_schema}.wind_finnotesdetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_finnotesdetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_finnotesdetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_finnotesdetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);