/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbtotdailyprofitloss
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
drop table ${iol_schema}.nfss_tbtotdailyprofitloss_ex purge;
alter table ${iol_schema}.nfss_tbtotdailyprofitloss add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''nfss_tbtotdailyprofitloss'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.nfss_tbtotdailyprofitloss truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.nfss_tbtotdailyprofitloss add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.nfss_tbtotdailyprofitloss(
    in_client_no -- 内部客户号
    ,bank_acc -- 银行账号
    ,bank_no -- 银行编号
    ,client_no -- 客户号
    ,ta_code -- TA代码
    ,prd_code -- 产品代码
    ,nav -- 产品净值
    ,record_date -- 记录日期
    ,beg_date -- 期初日期
    ,beg_nav -- 期初净值
    ,end_date -- 期末日期
    ,end_nav -- 期末净值
    ,tot_vol -- 总份额
    ,allot_amt -- 认购金额
    ,allot_cfm_amt -- 认购确认金额
    ,sub_amt -- 申购金额
    ,auto_sub_amt -- 定投金额
    ,conv_in_amt -- 转换入金额
    ,trust_in_amt -- 转托管入金额
    ,assign_in_amt -- 非交易过户入金额
    ,force_add_amt -- 份额强增折算金额
    ,red_amt -- 赎回金额
    ,force_red_amt -- 强制赎回金额
    ,conv_out_amt -- 转换出金额
    ,trust_out_amt -- 转托管出金额
    ,assign_out_amt -- 非交易过户出金额
    ,div_vol_amt -- 分红份额金额
    ,div_vol -- 分红份额
    ,div_amt -- 分红金额
    ,fund_end_amt -- 基金清盘及终止金额
    ,force_sub_amt -- 份额强减折算金额
    ,income_rate -- 日涨幅率
    ,total_cost -- 总成本
    ,total_income -- 总收益
    ,avg_price -- 平均成本单价
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,avg_hold_price -- 平均持有成本
    ,hold_profit_loss -- 持有收益金额
    ,old_hold_profit_loss -- 原持有浮动收益
    ,hold_tot_cost -- 持有总成本
    ,bag_total_income -- 原总收益
    ,day_rate -- 昨日涨幅
    ,income_new -- 日涨幅
    ,nav_date -- 净值日期
    ,profit_loss -- 浮动收益
    ,bag_cost -- 原投资成本
    ,bag_div_amt -- 原累计流出现金分红
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    in_client_no -- 内部客户号
    ,bank_acc -- 银行账号
    ,bank_no -- 银行编号
    ,client_no -- 客户号
    ,ta_code -- TA代码
    ,prd_code -- 产品代码
    ,nav -- 产品净值
    ,record_date -- 记录日期
    ,beg_date -- 期初日期
    ,beg_nav -- 期初净值
    ,end_date -- 期末日期
    ,end_nav -- 期末净值
    ,tot_vol -- 总份额
    ,allot_amt -- 认购金额
    ,allot_cfm_amt -- 认购确认金额
    ,sub_amt -- 申购金额
    ,auto_sub_amt -- 定投金额
    ,conv_in_amt -- 转换入金额
    ,trust_in_amt -- 转托管入金额
    ,assign_in_amt -- 非交易过户入金额
    ,force_add_amt -- 份额强增折算金额
    ,red_amt -- 赎回金额
    ,force_red_amt -- 强制赎回金额
    ,conv_out_amt -- 转换出金额
    ,trust_out_amt -- 转托管出金额
    ,assign_out_amt -- 非交易过户出金额
    ,div_vol_amt -- 分红份额金额
    ,div_vol -- 分红份额
    ,div_amt -- 分红金额
    ,fund_end_amt -- 基金清盘及终止金额
    ,force_sub_amt -- 份额强减折算金额
    ,income_rate -- 日涨幅率
    ,total_cost -- 总成本
    ,total_income -- 总收益
    ,avg_price -- 平均成本单价
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,avg_hold_price -- 平均持有成本
    ,hold_profit_loss -- 持有收益金额
    ,old_hold_profit_loss -- 原持有浮动收益
    ,hold_tot_cost -- 持有总成本
    ,bag_total_income -- 原总收益
    ,day_rate -- 昨日涨幅
    ,income_new -- 日涨幅
    ,nav_date -- 净值日期
    ,profit_loss -- 浮动收益
    ,bag_cost -- 原投资成本
    ,bag_div_amt -- 原累计流出现金分红
    ,to_date(record_date,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_tbtotdailyprofitloss
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbtotdailyprofitloss to ${iml_schema};

-- 3.2 drop ex table

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbtotdailyprofitloss',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);