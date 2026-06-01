/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_define_attach
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_dc_stage_define_attach_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_stage_define_attach
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_define_attach_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_define_attach where 0=1;

create table ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_define_attach where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl(
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,un_white_view_flag -- 
            ,om_apply_no -- 
            ,roll_issue_flag -- 
            ,roll_start_date -- 
            ,roll_end_date -- 
            ,redeem_term_type -- 
            ,redeem_term -- 
            ,white_change_flag -- 
            ,white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_define_attach_op(
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,un_white_view_flag -- 
            ,om_apply_no -- 
            ,roll_issue_flag -- 
            ,roll_start_date -- 
            ,roll_end_date -- 
            ,redeem_term_type -- 
            ,redeem_term -- 
            ,white_change_flag -- 
            ,white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trf_out_fee_type, o.trf_out_fee_type) as trf_out_fee_type -- 转出费用类型
    ,nvl(n.sell_branch, o.sell_branch) as sell_branch -- 出售分行或者出售机构
    ,nvl(n.change_min_amt, o.change_min_amt) as change_min_amt -- 期次最小变动金额
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.inland_offshore, o.inland_offshore) as inland_offshore -- 境内境外标志
    ,nvl(n.settle_acct_type, o.settle_acct_type) as settle_acct_type -- 结算账户类型
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.trf_flag, o.trf_flag) as trf_flag -- 转让标志
    ,nvl(n.int_start_date, o.int_start_date) as int_start_date -- 起息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.available_limit, o.available_limit) as available_limit -- 可用额度
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.keep_min_bal, o.keep_min_bal) as keep_min_bal -- 最小留存金额
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.sg_max_amt, o.sg_max_amt) as sg_max_amt -- 单笔认购最大金额
    ,nvl(n.sg_min_amt, o.sg_min_amt) as sg_min_amt -- 单次最小支取金额
    ,nvl(n.spread_percent, o.spread_percent) as spread_percent -- 浮动百分比
    ,nvl(n.tohonor_rate, o.tohonor_rate) as tohonor_rate -- 赎回利率
    ,nvl(n.on_sale_channel, o.on_sale_channel) as on_sale_channel -- 产品可售渠道
    ,nvl(n.prod_desc_address, o.prod_desc_address) as prod_desc_address -- 产品说明书链接
    ,nvl(n.redemption_int_type, o.redemption_int_type) as redemption_int_type -- 大额存单赎回利率类型
    ,nvl(n.trf_in_fee_type, o.trf_in_fee_type) as trf_in_fee_type -- 转入费用类型
    ,nvl(n.trf_in_fee_amt, o.trf_in_fee_amt) as trf_in_fee_amt -- 转入费用
    ,nvl(n.comb_prod_flag, o.comb_prod_flag) as comb_prod_flag -- 是否组合产品
    ,nvl(n.allow_fund_source_inner_flag, o.allow_fund_source_inner_flag) as allow_fund_source_inner_flag -- 是否允许资金来源为内部户
    ,nvl(n.redemption_int_flag, o.redemption_int_flag) as redemption_int_flag -- 赎回利率标识
    ,nvl(n.int_start_flag, o.int_start_flag) as int_start_flag -- 起息标识
    ,nvl(n.direction_charge_int_flag, o.direction_charge_int_flag) as direction_charge_int_flag -- 指定收息标志
    ,nvl(n.promissory_redeem_date, o.promissory_redeem_date) as promissory_redeem_date -- 原约定赎回日期
    ,nvl(n.trf_out_fee_amt, o.trf_out_fee_amt) as trf_out_fee_amt -- 转出费用
    ,nvl(n.un_white_view_flag, o.un_white_view_flag) as un_white_view_flag -- 
    ,nvl(n.om_apply_no, o.om_apply_no) as om_apply_no -- 
    ,nvl(n.roll_issue_flag, o.roll_issue_flag) as roll_issue_flag -- 
    ,nvl(n.roll_start_date, o.roll_start_date) as roll_start_date -- 
    ,nvl(n.roll_end_date, o.roll_end_date) as roll_end_date -- 
    ,nvl(n.redeem_term_type, o.redeem_term_type) as redeem_term_type -- 
    ,nvl(n.redeem_term, o.redeem_term) as redeem_term -- 
    ,nvl(n.white_change_flag, o.white_change_flag) as white_change_flag -- 
    ,nvl(n.white_support_branch, o.white_support_branch) as white_support_branch -- 
    ,case when
            n.stage_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stage_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stage_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_stage_define_attach_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_stage_define_attach where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stage_code = n.stage_code
where (
        o.stage_code is null
    )
    or (
        n.stage_code is null
    )
    or (
        o.trf_out_fee_type <> n.trf_out_fee_type
        or o.sell_branch <> n.sell_branch
        or o.change_min_amt <> n.change_min_amt
        or o.client_type <> n.client_type
        or o.int_type <> n.int_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.email <> n.email
        or o.inland_offshore <> n.inland_offshore
        or o.settle_acct_type <> n.settle_acct_type
        or o.trf_flag <> n.trf_flag
        or o.int_start_date <> n.int_start_date
        or o.maturity_date <> n.maturity_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.available_limit <> n.available_limit
        or o.float_rate <> n.float_rate
        or o.keep_min_bal <> n.keep_min_bal
        or o.real_rate <> n.real_rate
        or o.sg_max_amt <> n.sg_max_amt
        or o.sg_min_amt <> n.sg_min_amt
        or o.spread_percent <> n.spread_percent
        or o.tohonor_rate <> n.tohonor_rate
        or o.on_sale_channel <> n.on_sale_channel
        or o.prod_desc_address <> n.prod_desc_address
        or o.redemption_int_type <> n.redemption_int_type
        or o.trf_in_fee_type <> n.trf_in_fee_type
        or o.trf_in_fee_amt <> n.trf_in_fee_amt
        or o.comb_prod_flag <> n.comb_prod_flag
        or o.allow_fund_source_inner_flag <> n.allow_fund_source_inner_flag
        or o.redemption_int_flag <> n.redemption_int_flag
        or o.int_start_flag <> n.int_start_flag
        or o.direction_charge_int_flag <> n.direction_charge_int_flag
        or o.promissory_redeem_date <> n.promissory_redeem_date
        or o.trf_out_fee_amt <> n.trf_out_fee_amt
        or o.un_white_view_flag <> n.un_white_view_flag
        or o.om_apply_no <> n.om_apply_no
        or o.roll_issue_flag <> n.roll_issue_flag
        or o.roll_start_date <> n.roll_start_date
        or o.roll_end_date <> n.roll_end_date
        or o.redeem_term_type <> n.redeem_term_type
        or o.redeem_term <> n.redeem_term
        or o.white_change_flag <> n.white_change_flag
        or o.white_support_branch <> n.white_support_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl(
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,un_white_view_flag -- 
            ,om_apply_no -- 
            ,roll_issue_flag -- 
            ,roll_start_date -- 
            ,roll_end_date -- 
            ,redeem_term_type -- 
            ,redeem_term -- 
            ,white_change_flag -- 
            ,white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_define_attach_op(
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,un_white_view_flag -- 
            ,om_apply_no -- 
            ,roll_issue_flag -- 
            ,roll_start_date -- 
            ,roll_end_date -- 
            ,redeem_term_type -- 
            ,redeem_term -- 
            ,white_change_flag -- 
            ,white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trf_out_fee_type -- 转出费用类型
    ,o.sell_branch -- 出售分行或者出售机构
    ,o.change_min_amt -- 期次最小变动金额
    ,o.client_type -- 客户类型
    ,o.int_type -- 利率类型
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.email -- 电子邮件
    ,o.inland_offshore -- 境内境外标志
    ,o.settle_acct_type -- 结算账户类型
    ,o.stage_code -- 期次代码
    ,o.trf_flag -- 转让标志
    ,o.int_start_date -- 起息日
    ,o.maturity_date -- 到期日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.available_limit -- 可用额度
    ,o.float_rate -- 浮动利率
    ,o.keep_min_bal -- 最小留存金额
    ,o.real_rate -- 执行利率
    ,o.sg_max_amt -- 单笔认购最大金额
    ,o.sg_min_amt -- 单次最小支取金额
    ,o.spread_percent -- 浮动百分比
    ,o.tohonor_rate -- 赎回利率
    ,o.on_sale_channel -- 产品可售渠道
    ,o.prod_desc_address -- 产品说明书链接
    ,o.redemption_int_type -- 大额存单赎回利率类型
    ,o.trf_in_fee_type -- 转入费用类型
    ,o.trf_in_fee_amt -- 转入费用
    ,o.comb_prod_flag -- 是否组合产品
    ,o.allow_fund_source_inner_flag -- 是否允许资金来源为内部户
    ,o.redemption_int_flag -- 赎回利率标识
    ,o.int_start_flag -- 起息标识
    ,o.direction_charge_int_flag -- 指定收息标志
    ,o.promissory_redeem_date -- 原约定赎回日期
    ,o.trf_out_fee_amt -- 转出费用
    ,o.un_white_view_flag -- 
    ,o.om_apply_no -- 
    ,o.roll_issue_flag -- 
    ,o.roll_start_date -- 
    ,o.roll_end_date -- 
    ,o.redeem_term_type -- 
    ,o.redeem_term -- 
    ,o.white_change_flag -- 
    ,o.white_support_branch -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_dc_stage_define_attach_bk o
    left join ${iol_schema}.ncbs_rb_dc_stage_define_attach_op n
        on
            o.stage_code = n.stage_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl d
        on
            o.stage_code = d.stage_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_stage_define_attach;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_stage_define_attach') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_stage_define_attach drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_stage_define_attach add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_stage_define_attach exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl;
alter table ${iol_schema}.ncbs_rb_dc_stage_define_attach exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_stage_define_attach_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_stage_define_attach to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_stage_define_attach',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
