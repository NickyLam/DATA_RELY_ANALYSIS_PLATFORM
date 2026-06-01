/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_dpst_details
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
create table ${iol_schema}.bdms_cpes_dpst_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_dpst_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_details_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_details where 0=1;

create table ${iol_schema}.bdms_cpes_dpst_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,apply_id -- 存托申请单编号
            ,rs_product -- 存托应答方存托类产品
            ,req_date -- 存托申请日期
            ,fin_rate_up -- 融资利率上限
            ,fin_rate_down -- 融资利率下限
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,req_social_code -- 存托申请人社会统一信用代码
            ,req_platform_code -- 存托申请人所在平台代码
            ,req_bank_no -- 存托申请人开户行行号
            ,req_acct_no -- 存托申请人开户行账号
            ,req_org_code -- 存托机构代码
            ,std_product_code -- 标准化票据产品代码
            ,std_product_bank_no -- 标准化票据产品开户行行号
            ,std_product_bank_name -- 标准化票据产品开户行名称
            ,dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
            ,fin_rate -- 融资利率
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,draft_amt -- 票据金额
            ,settle_amt -- 结算金额
            ,settle_date -- 结算日期
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,aoa_acct_name_acctname -- 资金账户名称
            ,req_name -- 申请人名称
            ,asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
            ,req_brh_no -- 存托申请人机构号
            ,aoa_acct -- 资金账户
            ,aoa_brh_no -- 资金账户开户行机构参与者代码
            ,req_acct_name -- 存托申请人账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,apply_id -- 存托申请单编号
            ,rs_product -- 存托应答方存托类产品
            ,req_date -- 存托申请日期
            ,fin_rate_up -- 融资利率上限
            ,fin_rate_down -- 融资利率下限
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,req_social_code -- 存托申请人社会统一信用代码
            ,req_platform_code -- 存托申请人所在平台代码
            ,req_bank_no -- 存托申请人开户行行号
            ,req_acct_no -- 存托申请人开户行账号
            ,req_org_code -- 存托机构代码
            ,std_product_code -- 标准化票据产品代码
            ,std_product_bank_no -- 标准化票据产品开户行行号
            ,std_product_bank_name -- 标准化票据产品开户行名称
            ,dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
            ,fin_rate -- 融资利率
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,draft_amt -- 票据金额
            ,settle_amt -- 结算金额
            ,settle_date -- 结算日期
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,aoa_acct_name_acctname -- 资金账户名称
            ,req_name -- 申请人名称
            ,asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
            ,req_brh_no -- 存托申请人机构号
            ,aoa_acct -- 资金账户
            ,aoa_brh_no -- 资金账户开户行机构参与者代码
            ,req_acct_name -- 存托申请人账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 存托申请单编号
    ,nvl(n.rs_product, o.rs_product) as rs_product -- 存托应答方存托类产品
    ,nvl(n.req_date, o.req_date) as req_date -- 存托申请日期
    ,nvl(n.fin_rate_up, o.fin_rate_up) as fin_rate_up -- 融资利率上限
    ,nvl(n.fin_rate_down, o.fin_rate_down) as fin_rate_down -- 融资利率下限
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,nvl(n.req_social_code, o.req_social_code) as req_social_code -- 存托申请人社会统一信用代码
    ,nvl(n.req_platform_code, o.req_platform_code) as req_platform_code -- 存托申请人所在平台代码
    ,nvl(n.req_bank_no, o.req_bank_no) as req_bank_no -- 存托申请人开户行行号
    ,nvl(n.req_acct_no, o.req_acct_no) as req_acct_no -- 存托申请人开户行账号
    ,nvl(n.req_org_code, o.req_org_code) as req_org_code -- 存托机构代码
    ,nvl(n.std_product_code, o.std_product_code) as std_product_code -- 标准化票据产品代码
    ,nvl(n.std_product_bank_no, o.std_product_bank_no) as std_product_bank_no -- 标准化票据产品开户行行号
    ,nvl(n.std_product_bank_name, o.std_product_bank_name) as std_product_bank_name -- 标准化票据产品开户行名称
    ,nvl(n.dpst_deal_id, o.dpst_deal_id) as dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
    ,nvl(n.fin_rate, o.fin_rate) as fin_rate -- 融资利率
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.adjust_pay_interest, o.adjust_pay_interest) as adjust_pay_interest -- 调整后应付利息
    ,nvl(n.draft_amt, o.draft_amt) as draft_amt -- 票据金额
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,nvl(n.settle_fail_code, o.settle_fail_code) as settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,nvl(n.dpst_status, o.dpst_status) as dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.aoa_acct_name_acctname, o.aoa_acct_name_acctname) as aoa_acct_name_acctname -- 资金账户名称
    ,nvl(n.req_name, o.req_name) as req_name -- 申请人名称
    ,nvl(n.asset_type, o.asset_type) as asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
    ,nvl(n.req_brh_no, o.req_brh_no) as req_brh_no -- 存托申请人机构号
    ,nvl(n.aoa_acct, o.aoa_acct) as aoa_acct -- 资金账户
    ,nvl(n.aoa_brh_no, o.aoa_brh_no) as aoa_brh_no -- 资金账户开户行机构参与者代码
    ,nvl(n.req_acct_name, o.req_acct_name) as req_acct_name -- 存托申请人账户名称
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
from (select * from ${iol_schema}.bdms_cpes_dpst_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_dpst_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.apply_id <> n.apply_id
        or o.rs_product <> n.rs_product
        or o.req_date <> n.req_date
        or o.fin_rate_up <> n.fin_rate_up
        or o.fin_rate_down <> n.fin_rate_down
        or o.settle_mode <> n.settle_mode
        or o.req_social_code <> n.req_social_code
        or o.req_platform_code <> n.req_platform_code
        or o.req_bank_no <> n.req_bank_no
        or o.req_acct_no <> n.req_acct_no
        or o.req_org_code <> n.req_org_code
        or o.std_product_code <> n.std_product_code
        or o.std_product_bank_no <> n.std_product_bank_no
        or o.std_product_bank_name <> n.std_product_bank_name
        or o.dpst_deal_id <> n.dpst_deal_id
        or o.fin_rate <> n.fin_rate
        or o.pay_interest <> n.pay_interest
        or o.adjust_pay_interest <> n.adjust_pay_interest
        or o.draft_amt <> n.draft_amt
        or o.settle_amt <> n.settle_amt
        or o.settle_date <> n.settle_date
        or o.settle_status <> n.settle_status
        or o.settle_fail_code <> n.settle_fail_code
        or o.dpst_status <> n.dpst_status
        or o.account_status <> n.account_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.aoa_acct_name_acctname <> n.aoa_acct_name_acctname
        or o.req_name <> n.req_name
        or o.asset_type <> n.asset_type
        or o.req_brh_no <> n.req_brh_no
        or o.aoa_acct <> n.aoa_acct
        or o.aoa_brh_no <> n.aoa_brh_no
        or o.req_acct_name <> n.req_acct_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,apply_id -- 存托申请单编号
            ,rs_product -- 存托应答方存托类产品
            ,req_date -- 存托申请日期
            ,fin_rate_up -- 融资利率上限
            ,fin_rate_down -- 融资利率下限
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,req_social_code -- 存托申请人社会统一信用代码
            ,req_platform_code -- 存托申请人所在平台代码
            ,req_bank_no -- 存托申请人开户行行号
            ,req_acct_no -- 存托申请人开户行账号
            ,req_org_code -- 存托机构代码
            ,std_product_code -- 标准化票据产品代码
            ,std_product_bank_no -- 标准化票据产品开户行行号
            ,std_product_bank_name -- 标准化票据产品开户行名称
            ,dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
            ,fin_rate -- 融资利率
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,draft_amt -- 票据金额
            ,settle_amt -- 结算金额
            ,settle_date -- 结算日期
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,aoa_acct_name_acctname -- 资金账户名称
            ,req_name -- 申请人名称
            ,asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
            ,req_brh_no -- 存托申请人机构号
            ,aoa_acct -- 资金账户
            ,aoa_brh_no -- 资金账户开户行机构参与者代码
            ,req_acct_name -- 存托申请人账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,apply_id -- 存托申请单编号
            ,rs_product -- 存托应答方存托类产品
            ,req_date -- 存托申请日期
            ,fin_rate_up -- 融资利率上限
            ,fin_rate_down -- 融资利率下限
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,req_social_code -- 存托申请人社会统一信用代码
            ,req_platform_code -- 存托申请人所在平台代码
            ,req_bank_no -- 存托申请人开户行行号
            ,req_acct_no -- 存托申请人开户行账号
            ,req_org_code -- 存托机构代码
            ,std_product_code -- 标准化票据产品代码
            ,std_product_bank_no -- 标准化票据产品开户行行号
            ,std_product_bank_name -- 标准化票据产品开户行名称
            ,dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
            ,fin_rate -- 融资利率
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,draft_amt -- 票据金额
            ,settle_amt -- 结算金额
            ,settle_date -- 结算日期
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,aoa_acct_name_acctname -- 资金账户名称
            ,req_name -- 申请人名称
            ,asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
            ,req_brh_no -- 存托申请人机构号
            ,aoa_acct -- 资金账户
            ,aoa_brh_no -- 资金账户开户行机构参与者代码
            ,req_acct_name -- 存托申请人账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 批次表ID
    ,o.apply_id -- 存托申请单编号
    ,o.rs_product -- 存托应答方存托类产品
    ,o.req_date -- 存托申请日期
    ,o.fin_rate_up -- 融资利率上限
    ,o.fin_rate_down -- 融资利率下限
    ,o.settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,o.req_social_code -- 存托申请人社会统一信用代码
    ,o.req_platform_code -- 存托申请人所在平台代码
    ,o.req_bank_no -- 存托申请人开户行行号
    ,o.req_acct_no -- 存托申请人开户行账号
    ,o.req_org_code -- 存托机构代码
    ,o.std_product_code -- 标准化票据产品代码
    ,o.std_product_bank_no -- 标准化票据产品开户行行号
    ,o.std_product_bank_name -- 标准化票据产品开户行名称
    ,o.dpst_deal_id -- 存托单编号：结算结果通知的存托单编号
    ,o.fin_rate -- 融资利率
    ,o.pay_interest -- 应付利息
    ,o.adjust_pay_interest -- 调整后应付利息
    ,o.draft_amt -- 票据金额
    ,o.settle_amt -- 结算金额
    ,o.settle_date -- 结算日期
    ,o.settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,o.settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,o.dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.aoa_acct_name_acctname -- 资金账户名称
    ,o.req_name -- 申请人名称
    ,o.asset_type -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
    ,o.req_brh_no -- 存托申请人机构号
    ,o.aoa_acct -- 资金账户
    ,o.aoa_brh_no -- 资金账户开户行机构参与者代码
    ,o.req_acct_name -- 存托申请人账户名称
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
from ${iol_schema}.bdms_cpes_dpst_details_bk o
    left join ${iol_schema}.bdms_cpes_dpst_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_dpst_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_dpst_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_dpst_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_dpst_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_dpst_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_dpst_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_dpst_details_cl;
alter table ${iol_schema}.bdms_cpes_dpst_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_dpst_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_dpst_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_details_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_dpst_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_dpst_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
