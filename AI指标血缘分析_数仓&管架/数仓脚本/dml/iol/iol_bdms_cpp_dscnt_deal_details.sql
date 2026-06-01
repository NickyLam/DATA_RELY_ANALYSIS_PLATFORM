/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpp_dscnt_deal_details
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
create table ${iol_schema}.bdms_cpp_dscnt_deal_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpp_dscnt_deal_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details_op purge;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_dscnt_deal_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_dscnt_deal_details where 0=1;

create table ${iol_schema}.bdms_cpp_dscnt_deal_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_dscnt_deal_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_dscnt_deal_details_cl(
            id -- ID
            ,deal_id -- 成交表ID
            ,dealed_no -- 成交单编号
            ,request_no -- 交割单编号
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,remit_date -- 出票日
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,rate -- 贴现利率
            ,settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,settle_date -- 结算日期
            ,set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
            ,dscnt_entry_acct -- 贴现入账账号
            ,sell_agen_br_id -- 贴出人经纪机构代码
            ,sell_agen_br_name -- 经纪机构名称
            ,sell_social_no -- 贴出人社会信用代码
            ,sell_name -- 贴现申请人名称
            ,sell_bank_no -- 贴出人开户行号
            ,sell_bank_name -- 贴出人开户行名称
            ,sell_acct_no -- 贴出人账号
            ,buy_agen_br_id -- 贴入人经纪机构代码
            ,buy_agen_br_name -- 贴现机构名称
            ,buy_bank_no -- 贴入人开户行号
            ,buy_bank_name -- 贴入人开户行名称
            ,buy_acct_no -- 贴入人账号
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,sell_brh_no -- 贴出人开户机构代码
            ,sell_acct_name -- 贴出人账户名称
            ,buy_tacct_no -- 贴入人托管账户
            ,buy_tacct_name -- 贴入人托管账户名称
            ,buy_facct_no -- 贴入人托管账户
            ,buy_facct_name -- 贴入人托管账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_dscnt_deal_details_op(
            id -- ID
            ,deal_id -- 成交表ID
            ,dealed_no -- 成交单编号
            ,request_no -- 交割单编号
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,remit_date -- 出票日
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,rate -- 贴现利率
            ,settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,settle_date -- 结算日期
            ,set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
            ,dscnt_entry_acct -- 贴现入账账号
            ,sell_agen_br_id -- 贴出人经纪机构代码
            ,sell_agen_br_name -- 经纪机构名称
            ,sell_social_no -- 贴出人社会信用代码
            ,sell_name -- 贴现申请人名称
            ,sell_bank_no -- 贴出人开户行号
            ,sell_bank_name -- 贴出人开户行名称
            ,sell_acct_no -- 贴出人账号
            ,buy_agen_br_id -- 贴入人经纪机构代码
            ,buy_agen_br_name -- 贴现机构名称
            ,buy_bank_no -- 贴入人开户行号
            ,buy_bank_name -- 贴入人开户行名称
            ,buy_acct_no -- 贴入人账号
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,sell_brh_no -- 贴出人开户机构代码
            ,sell_acct_name -- 贴出人账户名称
            ,buy_tacct_no -- 贴入人托管账户
            ,buy_tacct_name -- 贴入人托管账户名称
            ,buy_facct_no -- 贴入人托管账户
            ,buy_facct_name -- 贴入人托管账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交表ID
    ,nvl(n.dealed_no, o.dealed_no) as dealed_no -- 成交单编号
    ,nvl(n.request_no, o.request_no) as request_no -- 交割单编号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_due_date, o.real_due_date) as real_due_date -- 实际到期日
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 剩余期限
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.rate, o.rate) as rate -- 贴现利率
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.set_status, o.set_status) as set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
    ,nvl(n.dscnt_entry_acct, o.dscnt_entry_acct) as dscnt_entry_acct -- 贴现入账账号
    ,nvl(n.sell_agen_br_id, o.sell_agen_br_id) as sell_agen_br_id -- 贴出人经纪机构代码
    ,nvl(n.sell_agen_br_name, o.sell_agen_br_name) as sell_agen_br_name -- 经纪机构名称
    ,nvl(n.sell_social_no, o.sell_social_no) as sell_social_no -- 贴出人社会信用代码
    ,nvl(n.sell_name, o.sell_name) as sell_name -- 贴现申请人名称
    ,nvl(n.sell_bank_no, o.sell_bank_no) as sell_bank_no -- 贴出人开户行号
    ,nvl(n.sell_bank_name, o.sell_bank_name) as sell_bank_name -- 贴出人开户行名称
    ,nvl(n.sell_acct_no, o.sell_acct_no) as sell_acct_no -- 贴出人账号
    ,nvl(n.buy_agen_br_id, o.buy_agen_br_id) as buy_agen_br_id -- 贴入人经纪机构代码
    ,nvl(n.buy_agen_br_name, o.buy_agen_br_name) as buy_agen_br_name -- 贴现机构名称
    ,nvl(n.buy_bank_no, o.buy_bank_no) as buy_bank_no -- 贴入人开户行号
    ,nvl(n.buy_bank_name, o.buy_bank_name) as buy_bank_name -- 贴入人开户行名称
    ,nvl(n.buy_acct_no, o.buy_acct_no) as buy_acct_no -- 贴入人账号
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.sub_range, o.sub_range) as sub_range -- 子票据区间
    ,nvl(n.product_type, o.product_type) as product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,nvl(n.standard_amount, o.standard_amount) as standard_amount -- 标准金额
    ,nvl(n.create_time, o.create_time) as create_time -- 鍒涘缓鏃堕棿
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.sell_brh_no, o.sell_brh_no) as sell_brh_no -- 贴出人开户机构代码
    ,nvl(n.sell_acct_name, o.sell_acct_name) as sell_acct_name -- 贴出人账户名称
    ,nvl(n.buy_tacct_no, o.buy_tacct_no) as buy_tacct_no -- 贴入人托管账户
    ,nvl(n.buy_tacct_name, o.buy_tacct_name) as buy_tacct_name -- 贴入人托管账户名称
    ,nvl(n.buy_facct_no, o.buy_facct_no) as buy_facct_no -- 贴入人托管账户
    ,nvl(n.buy_facct_name, o.buy_facct_name) as buy_facct_name -- 贴入人托管账户名称
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpp_dscnt_deal_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpp_dscnt_deal_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.deal_id <> n.deal_id
        or o.dealed_no <> n.dealed_no
        or o.request_no <> n.request_no
        or o.draft_number <> n.draft_number
        or o.draft_amount <> n.draft_amount
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.real_due_date <> n.real_due_date
        or o.tenor_days <> n.tenor_days
        or o.pay_interest <> n.pay_interest
        or o.settle_amt <> n.settle_amt
        or o.rate <> n.rate
        or o.settle_mode <> n.settle_mode
        or o.settle_date <> n.settle_date
        or o.set_status <> n.set_status
        or o.dscnt_entry_acct <> n.dscnt_entry_acct
        or o.sell_agen_br_id <> n.sell_agen_br_id
        or o.sell_agen_br_name <> n.sell_agen_br_name
        or o.sell_social_no <> n.sell_social_no
        or o.sell_name <> n.sell_name
        or o.sell_bank_no <> n.sell_bank_no
        or o.sell_bank_name <> n.sell_bank_name
        or o.sell_acct_no <> n.sell_acct_no
        or o.buy_agen_br_id <> n.buy_agen_br_id
        or o.buy_agen_br_name <> n.buy_agen_br_name
        or o.buy_bank_no <> n.buy_bank_no
        or o.buy_bank_name <> n.buy_bank_name
        or o.buy_acct_no <> n.buy_acct_no
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.sub_range <> n.sub_range
        or o.product_type <> n.product_type
        or o.standard_amount <> n.standard_amount
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
        or o.sell_brh_no <> n.sell_brh_no
        or o.sell_acct_name <> n.sell_acct_name
        or o.buy_tacct_no <> n.buy_tacct_no
        or o.buy_tacct_name <> n.buy_tacct_name
        or o.buy_facct_no <> n.buy_facct_no
        or o.buy_facct_name <> n.buy_facct_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_dscnt_deal_details_cl(
            id -- ID
            ,deal_id -- 成交表ID
            ,dealed_no -- 成交单编号
            ,request_no -- 交割单编号
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,remit_date -- 出票日
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,rate -- 贴现利率
            ,settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,settle_date -- 结算日期
            ,set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
            ,dscnt_entry_acct -- 贴现入账账号
            ,sell_agen_br_id -- 贴出人经纪机构代码
            ,sell_agen_br_name -- 经纪机构名称
            ,sell_social_no -- 贴出人社会信用代码
            ,sell_name -- 贴现申请人名称
            ,sell_bank_no -- 贴出人开户行号
            ,sell_bank_name -- 贴出人开户行名称
            ,sell_acct_no -- 贴出人账号
            ,buy_agen_br_id -- 贴入人经纪机构代码
            ,buy_agen_br_name -- 贴现机构名称
            ,buy_bank_no -- 贴入人开户行号
            ,buy_bank_name -- 贴入人开户行名称
            ,buy_acct_no -- 贴入人账号
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,sell_brh_no -- 贴出人开户机构代码
            ,sell_acct_name -- 贴出人账户名称
            ,buy_tacct_no -- 贴入人托管账户
            ,buy_tacct_name -- 贴入人托管账户名称
            ,buy_facct_no -- 贴入人托管账户
            ,buy_facct_name -- 贴入人托管账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_dscnt_deal_details_op(
            id -- ID
            ,deal_id -- 成交表ID
            ,dealed_no -- 成交单编号
            ,request_no -- 交割单编号
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,remit_date -- 出票日
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,rate -- 贴现利率
            ,settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,settle_date -- 结算日期
            ,set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
            ,dscnt_entry_acct -- 贴现入账账号
            ,sell_agen_br_id -- 贴出人经纪机构代码
            ,sell_agen_br_name -- 经纪机构名称
            ,sell_social_no -- 贴出人社会信用代码
            ,sell_name -- 贴现申请人名称
            ,sell_bank_no -- 贴出人开户行号
            ,sell_bank_name -- 贴出人开户行名称
            ,sell_acct_no -- 贴出人账号
            ,buy_agen_br_id -- 贴入人经纪机构代码
            ,buy_agen_br_name -- 贴现机构名称
            ,buy_bank_no -- 贴入人开户行号
            ,buy_bank_name -- 贴入人开户行名称
            ,buy_acct_no -- 贴入人账号
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,sell_brh_no -- 贴出人开户机构代码
            ,sell_acct_name -- 贴出人账户名称
            ,buy_tacct_no -- 贴入人托管账户
            ,buy_tacct_name -- 贴入人托管账户名称
            ,buy_facct_no -- 贴入人托管账户
            ,buy_facct_name -- 贴入人托管账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.deal_id -- 成交表ID
    ,o.dealed_no -- 成交单编号
    ,o.request_no -- 交割单编号
    ,o.draft_number -- 票据号码
    ,o.draft_amount -- 票面金额
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.remit_date -- 出票日
    ,o.maturity_date -- 票据到期日
    ,o.real_due_date -- 实际到期日
    ,o.tenor_days -- 剩余期限
    ,o.pay_interest -- 应付利息
    ,o.settle_amt -- 结算金额
    ,o.rate -- 贴现利率
    ,o.settle_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,o.settle_date -- 结算日期
    ,o.set_status -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
    ,o.dscnt_entry_acct -- 贴现入账账号
    ,o.sell_agen_br_id -- 贴出人经纪机构代码
    ,o.sell_agen_br_name -- 经纪机构名称
    ,o.sell_social_no -- 贴出人社会信用代码
    ,o.sell_name -- 贴现申请人名称
    ,o.sell_bank_no -- 贴出人开户行号
    ,o.sell_bank_name -- 贴出人开户行名称
    ,o.sell_acct_no -- 贴出人账号
    ,o.buy_agen_br_id -- 贴入人经纪机构代码
    ,o.buy_agen_br_name -- 贴现机构名称
    ,o.buy_bank_no -- 贴入人开户行号
    ,o.buy_bank_name -- 贴入人开户行名称
    ,o.buy_acct_no -- 贴入人账号
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.sub_range -- 子票据区间
    ,o.product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,o.standard_amount -- 标准金额
    ,o.create_time -- 鍒涘缓鏃堕棿
    ,o.create_by -- 创建人
    ,o.sell_brh_no -- 贴出人开户机构代码
    ,o.sell_acct_name -- 贴出人账户名称
    ,o.buy_tacct_no -- 贴入人托管账户
    ,o.buy_tacct_name -- 贴入人托管账户名称
    ,o.buy_facct_no -- 贴入人托管账户
    ,o.buy_facct_name -- 贴入人托管账户名称
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
from ${iol_schema}.bdms_cpp_dscnt_deal_details_bk o
    left join ${iol_schema}.bdms_cpp_dscnt_deal_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpp_dscnt_deal_details_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cpp_dscnt_deal_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpp_dscnt_deal_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpp_dscnt_deal_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpp_dscnt_deal_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpp_dscnt_deal_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpp_dscnt_deal_details_cl;
alter table ${iol_schema}.bdms_cpp_dscnt_deal_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpp_dscnt_deal_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpp_dscnt_deal_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details_op purge;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpp_dscnt_deal_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
