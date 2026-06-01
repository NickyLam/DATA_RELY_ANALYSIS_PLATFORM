/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acc_cash_ext
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
create table ${iol_schema}.ibms_ttrd_acc_cash_ext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_acc_cash_ext
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_cash_ext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_cash_ext where 0=1;

create table ${iol_schema}.ibms_ttrd_acc_cash_ext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_cash_ext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_cash_ext_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,markets -- 交易市场
            ,exhacc -- 交易所账户
            ,password -- 账户密码
            ,status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
            ,currency -- 币种
            ,dn_ratio -- 等待补充
            ,threshold -- 等待补充
            ,large_pay_accno -- 大额支付行号
            ,rate -- 利率
            ,bank_code -- 开户银行行号
            ,bank_name -- 开户银行名称
            ,open_date -- 开户时间
            ,is_dvp -- 1 是 0 否
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,inner_accid -- 内部资金账号ID
            ,enabled -- 启用--等待补充
            ,hands_bank_code -- 农信银行号
            ,coupontype -- 计息方式
            ,accounttype -- 1-普通 2-保证金 3-特种
            ,inner_code -- 内部账号
            ,oldinst_id -- 记账机构
            ,inner_accname -- 内部账名称
            ,payment_freq -- 付息频率
            ,rate_def_id -- 利率定义id
            ,update_user -- 更新者
            ,update_time -- 更新时间
            ,create_time -- 创建日期
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,pay_month -- 支付月份
            ,pay_day -- 支付日期
            ,i_id -- 机构号
            ,coupon -- 利率
            ,close_date -- 销户时间
            ,p_type -- 产品分类
            ,p_class -- 产品类型
            ,subj_code -- 科目号
            ,swift_code -- SWIFT_CODE
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,use_cash_acc -- SWIFT报文是否含账号
            ,bank_legal_person_name -- 开户行法人名称
            ,branch_bank_number -- 存款行网点行号
            ,account_nature -- 账户性质
            ,account_attribute -- 账户属性
            ,cross_border_acc -- 跨境同业往来账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_cash_ext_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,markets -- 交易市场
            ,exhacc -- 交易所账户
            ,password -- 账户密码
            ,status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
            ,currency -- 币种
            ,dn_ratio -- 等待补充
            ,threshold -- 等待补充
            ,large_pay_accno -- 大额支付行号
            ,rate -- 利率
            ,bank_code -- 开户银行行号
            ,bank_name -- 开户银行名称
            ,open_date -- 开户时间
            ,is_dvp -- 1 是 0 否
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,inner_accid -- 内部资金账号ID
            ,enabled -- 启用--等待补充
            ,hands_bank_code -- 农信银行号
            ,coupontype -- 计息方式
            ,accounttype -- 1-普通 2-保证金 3-特种
            ,inner_code -- 内部账号
            ,oldinst_id -- 记账机构
            ,inner_accname -- 内部账名称
            ,payment_freq -- 付息频率
            ,rate_def_id -- 利率定义id
            ,update_user -- 更新者
            ,update_time -- 更新时间
            ,create_time -- 创建日期
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,pay_month -- 支付月份
            ,pay_day -- 支付日期
            ,i_id -- 机构号
            ,coupon -- 利率
            ,close_date -- 销户时间
            ,p_type -- 产品分类
            ,p_class -- 产品类型
            ,subj_code -- 科目号
            ,swift_code -- SWIFT_CODE
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,use_cash_acc -- SWIFT报文是否含账号
            ,bank_legal_person_name -- 开户行法人名称
            ,branch_bank_number -- 存款行网点行号
            ,account_nature -- 账户性质
            ,account_attribute -- 账户属性
            ,cross_border_acc -- 跨境同业往来账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accid, o.accid) as accid -- 账户代码
    ,nvl(n.accname, o.accname) as accname -- 账户名称
    ,nvl(n.markets, o.markets) as markets -- 交易市场
    ,nvl(n.exhacc, o.exhacc) as exhacc -- 交易所账户
    ,nvl(n.password, o.password) as password -- 账户密码
    ,nvl(n.status, o.status) as status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.dn_ratio, o.dn_ratio) as dn_ratio -- 等待补充
    ,nvl(n.threshold, o.threshold) as threshold -- 等待补充
    ,nvl(n.large_pay_accno, o.large_pay_accno) as large_pay_accno -- 大额支付行号
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 开户银行行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户银行名称
    ,nvl(n.open_date, o.open_date) as open_date -- 开户时间
    ,nvl(n.is_dvp, o.is_dvp) as is_dvp -- 1 是 0 否
    ,nvl(n.customer_id, o.customer_id) as customer_id -- 客户（交易对手）编码
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户（交易对手）名称
    ,nvl(n.inner_accid, o.inner_accid) as inner_accid -- 内部资金账号ID
    ,nvl(n.enabled, o.enabled) as enabled -- 启用--等待补充
    ,nvl(n.hands_bank_code, o.hands_bank_code) as hands_bank_code -- 农信银行号
    ,nvl(n.coupontype, o.coupontype) as coupontype -- 计息方式
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 1-普通 2-保证金 3-特种
    ,nvl(n.inner_code, o.inner_code) as inner_code -- 内部账号
    ,nvl(n.oldinst_id, o.oldinst_id) as oldinst_id -- 记账机构
    ,nvl(n.inner_accname, o.inner_accname) as inner_accname -- 内部账名称
    ,nvl(n.payment_freq, o.payment_freq) as payment_freq -- 付息频率
    ,nvl(n.rate_def_id, o.rate_def_id) as rate_def_id -- 利率定义id
    ,nvl(n.update_user, o.update_user) as update_user -- 更新者
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_time, o.create_time) as create_time -- 创建日期
    ,nvl(n.invest_type, o.invest_type) as invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,nvl(n.pay_month, o.pay_month) as pay_month -- 支付月份
    ,nvl(n.pay_day, o.pay_day) as pay_day -- 支付日期
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.coupon, o.coupon) as coupon -- 利率
    ,nvl(n.close_date, o.close_date) as close_date -- 销户时间
    ,nvl(n.p_type, o.p_type) as p_type -- 产品分类
    ,nvl(n.p_class, o.p_class) as p_class -- 产品类型
    ,nvl(n.subj_code, o.subj_code) as subj_code -- 科目号
    ,nvl(n.swift_code, o.swift_code) as swift_code -- SWIFT_CODE
    ,nvl(n.mid_bank_acct_code, o.mid_bank_acct_code) as mid_bank_acct_code -- 中间行账号
    ,nvl(n.mid_bank_name, o.mid_bank_name) as mid_bank_name -- 中间行名称
    ,nvl(n.mid_swift_code, o.mid_swift_code) as mid_swift_code -- 中间行SWIFT代码
    ,nvl(n.use_cash_acc, o.use_cash_acc) as use_cash_acc -- SWIFT报文是否含账号
    ,nvl(n.bank_legal_person_name, o.bank_legal_person_name) as bank_legal_person_name -- 开户行法人名称
    ,nvl(n.branch_bank_number, o.branch_bank_number) as branch_bank_number -- 存款行网点行号
    ,nvl(n.account_nature, o.account_nature) as account_nature -- 账户性质
    ,nvl(n.account_attribute, o.account_attribute) as account_attribute -- 账户属性
    ,nvl(n.cross_border_acc, o.cross_border_acc) as cross_border_acc -- 跨境同业往来账户
    ,case when
            n.accid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_acc_cash_ext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_acc_cash_ext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accid = n.accid
where (
        o.accid is null
    )
    or (
        n.accid is null
    )
    or (
        o.accname <> n.accname
        or o.markets <> n.markets
        or o.exhacc <> n.exhacc
        or o.password <> n.password
        or o.status <> n.status
        or o.currency <> n.currency
        or o.dn_ratio <> n.dn_ratio
        or o.threshold <> n.threshold
        or o.large_pay_accno <> n.large_pay_accno
        or o.rate <> n.rate
        or o.bank_code <> n.bank_code
        or o.bank_name <> n.bank_name
        or o.open_date <> n.open_date
        or o.is_dvp <> n.is_dvp
        or o.customer_id <> n.customer_id
        or o.customer_name <> n.customer_name
        or o.inner_accid <> n.inner_accid
        or o.enabled <> n.enabled
        or o.hands_bank_code <> n.hands_bank_code
        or o.coupontype <> n.coupontype
        or o.accounttype <> n.accounttype
        or o.inner_code <> n.inner_code
        or o.oldinst_id <> n.oldinst_id
        or o.inner_accname <> n.inner_accname
        or o.payment_freq <> n.payment_freq
        or o.rate_def_id <> n.rate_def_id
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.create_time <> n.create_time
        or o.invest_type <> n.invest_type
        or o.pay_month <> n.pay_month
        or o.pay_day <> n.pay_day
        or o.i_id <> n.i_id
        or o.coupon <> n.coupon
        or o.close_date <> n.close_date
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.subj_code <> n.subj_code
        or o.swift_code <> n.swift_code
        or o.mid_bank_acct_code <> n.mid_bank_acct_code
        or o.mid_bank_name <> n.mid_bank_name
        or o.mid_swift_code <> n.mid_swift_code
        or o.use_cash_acc <> n.use_cash_acc
        or o.bank_legal_person_name <> n.bank_legal_person_name
        or o.branch_bank_number <> n.branch_bank_number
        or o.account_nature <> n.account_nature
        or o.account_attribute <> n.account_attribute
        or o.cross_border_acc <> n.cross_border_acc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_cash_ext_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,markets -- 交易市场
            ,exhacc -- 交易所账户
            ,password -- 账户密码
            ,status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
            ,currency -- 币种
            ,dn_ratio -- 等待补充
            ,threshold -- 等待补充
            ,large_pay_accno -- 大额支付行号
            ,rate -- 利率
            ,bank_code -- 开户银行行号
            ,bank_name -- 开户银行名称
            ,open_date -- 开户时间
            ,is_dvp -- 1 是 0 否
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,inner_accid -- 内部资金账号ID
            ,enabled -- 启用--等待补充
            ,hands_bank_code -- 农信银行号
            ,coupontype -- 计息方式
            ,accounttype -- 1-普通 2-保证金 3-特种
            ,inner_code -- 内部账号
            ,oldinst_id -- 记账机构
            ,inner_accname -- 内部账名称
            ,payment_freq -- 付息频率
            ,rate_def_id -- 利率定义id
            ,update_user -- 更新者
            ,update_time -- 更新时间
            ,create_time -- 创建日期
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,pay_month -- 支付月份
            ,pay_day -- 支付日期
            ,i_id -- 机构号
            ,coupon -- 利率
            ,close_date -- 销户时间
            ,p_type -- 产品分类
            ,p_class -- 产品类型
            ,subj_code -- 科目号
            ,swift_code -- SWIFT_CODE
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,use_cash_acc -- SWIFT报文是否含账号
            ,bank_legal_person_name -- 开户行法人名称
            ,branch_bank_number -- 存款行网点行号
            ,account_nature -- 账户性质
            ,account_attribute -- 账户属性
            ,cross_border_acc -- 跨境同业往来账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_cash_ext_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,markets -- 交易市场
            ,exhacc -- 交易所账户
            ,password -- 账户密码
            ,status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
            ,currency -- 币种
            ,dn_ratio -- 等待补充
            ,threshold -- 等待补充
            ,large_pay_accno -- 大额支付行号
            ,rate -- 利率
            ,bank_code -- 开户银行行号
            ,bank_name -- 开户银行名称
            ,open_date -- 开户时间
            ,is_dvp -- 1 是 0 否
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,inner_accid -- 内部资金账号ID
            ,enabled -- 启用--等待补充
            ,hands_bank_code -- 农信银行号
            ,coupontype -- 计息方式
            ,accounttype -- 1-普通 2-保证金 3-特种
            ,inner_code -- 内部账号
            ,oldinst_id -- 记账机构
            ,inner_accname -- 内部账名称
            ,payment_freq -- 付息频率
            ,rate_def_id -- 利率定义id
            ,update_user -- 更新者
            ,update_time -- 更新时间
            ,create_time -- 创建日期
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,pay_month -- 支付月份
            ,pay_day -- 支付日期
            ,i_id -- 机构号
            ,coupon -- 利率
            ,close_date -- 销户时间
            ,p_type -- 产品分类
            ,p_class -- 产品类型
            ,subj_code -- 科目号
            ,swift_code -- SWIFT_CODE
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,use_cash_acc -- SWIFT报文是否含账号
            ,bank_legal_person_name -- 开户行法人名称
            ,branch_bank_number -- 存款行网点行号
            ,account_nature -- 账户性质
            ,account_attribute -- 账户属性
            ,cross_border_acc -- 跨境同业往来账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accid -- 账户代码
    ,o.accname -- 账户名称
    ,o.markets -- 交易市场
    ,o.exhacc -- 交易所账户
    ,o.password -- 账户密码
    ,o.status -- 0：创建中, 11：已启用,  22：停用中  3：已停用
    ,o.currency -- 币种
    ,o.dn_ratio -- 等待补充
    ,o.threshold -- 等待补充
    ,o.large_pay_accno -- 大额支付行号
    ,o.rate -- 利率
    ,o.bank_code -- 开户银行行号
    ,o.bank_name -- 开户银行名称
    ,o.open_date -- 开户时间
    ,o.is_dvp -- 1 是 0 否
    ,o.customer_id -- 客户（交易对手）编码
    ,o.customer_name -- 客户（交易对手）名称
    ,o.inner_accid -- 内部资金账号ID
    ,o.enabled -- 启用--等待补充
    ,o.hands_bank_code -- 农信银行号
    ,o.coupontype -- 计息方式
    ,o.accounttype -- 1-普通 2-保证金 3-特种
    ,o.inner_code -- 内部账号
    ,o.oldinst_id -- 记账机构
    ,o.inner_accname -- 内部账名称
    ,o.payment_freq -- 付息频率
    ,o.rate_def_id -- 利率定义id
    ,o.update_user -- 更新者
    ,o.update_time -- 更新时间
    ,o.create_time -- 创建日期
    ,o.invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,o.pay_month -- 支付月份
    ,o.pay_day -- 支付日期
    ,o.i_id -- 机构号
    ,o.coupon -- 利率
    ,o.close_date -- 销户时间
    ,o.p_type -- 产品分类
    ,o.p_class -- 产品类型
    ,o.subj_code -- 科目号
    ,o.swift_code -- SWIFT_CODE
    ,o.mid_bank_acct_code -- 中间行账号
    ,o.mid_bank_name -- 中间行名称
    ,o.mid_swift_code -- 中间行SWIFT代码
    ,o.use_cash_acc -- SWIFT报文是否含账号
    ,o.bank_legal_person_name -- 开户行法人名称
    ,o.branch_bank_number -- 存款行网点行号
    ,o.account_nature -- 账户性质
    ,o.account_attribute -- 账户属性
    ,o.cross_border_acc -- 跨境同业往来账户
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
from ${iol_schema}.ibms_ttrd_acc_cash_ext_bk o
    left join ${iol_schema}.ibms_ttrd_acc_cash_ext_op n
        on
            o.accid = n.accid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acc_cash_ext_cl d
        on
            o.accid = d.accid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_acc_cash_ext;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_acc_cash_ext') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_acc_cash_ext drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_acc_cash_ext add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_acc_cash_ext exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_acc_cash_ext_cl;
alter table ${iol_schema}.ibms_ttrd_acc_cash_ext exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_acc_cash_ext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_acc_cash_ext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
