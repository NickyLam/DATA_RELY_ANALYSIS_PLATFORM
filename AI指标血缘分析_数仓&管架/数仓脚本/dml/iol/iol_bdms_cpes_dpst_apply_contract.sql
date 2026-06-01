/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_dpst_apply_contract
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
create table ${iol_schema}.bdms_cpes_dpst_apply_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_dpst_apply_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_apply_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_apply_contract where 0=1;

create table ${iol_schema}.bdms_cpes_dpst_apply_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_apply_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_apply_contract_cl(
            id -- ID
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,apply_date -- 存托申请日期
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,sum_draft_amount -- 存托票据汇总金额
            ,sum_settle_amount -- 存托结算汇总金额
            ,fin_rate_up -- 存托利率上限
            ,fin_rate_down -- 存托利率下限
            ,rate -- 融资利率
            ,apply_id -- 存托申请单编号
            ,dpst_no -- 存托单编号
            ,dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,rs_product -- 存托应答方存托类产品
            ,rs_product_name -- 存托产品名称
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,product_no -- 产品号
            ,own_pro_no -- 本方非法人产品号
            ,own_pro_name -- 本方非法人产品名称
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,cust_brh_no -- 存托应答机构
            ,cust_name -- 存托应答机构名称
            ,create_person -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_apply_contract_op(
            id -- ID
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,apply_date -- 存托申请日期
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,sum_draft_amount -- 存托票据汇总金额
            ,sum_settle_amount -- 存托结算汇总金额
            ,fin_rate_up -- 存托利率上限
            ,fin_rate_down -- 存托利率下限
            ,rate -- 融资利率
            ,apply_id -- 存托申请单编号
            ,dpst_no -- 存托单编号
            ,dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,rs_product -- 存托应答方存托类产品
            ,rs_product_name -- 存托产品名称
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,product_no -- 产品号
            ,own_pro_no -- 本方非法人产品号
            ,own_pro_name -- 本方非法人产品名称
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,cust_brh_no -- 存托应答机构
            ,cust_name -- 存托应答机构名称
            ,create_person -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 存托申请日期
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 业务机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.sum_draft_amount, o.sum_draft_amount) as sum_draft_amount -- 存托票据汇总金额
    ,nvl(n.sum_settle_amount, o.sum_settle_amount) as sum_settle_amount -- 存托结算汇总金额
    ,nvl(n.fin_rate_up, o.fin_rate_up) as fin_rate_up -- 存托利率上限
    ,nvl(n.fin_rate_down, o.fin_rate_down) as fin_rate_down -- 存托利率下限
    ,nvl(n.rate, o.rate) as rate -- 融资利率
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 存托申请单编号
    ,nvl(n.dpst_no, o.dpst_no) as dpst_no -- 存托单编号
    ,nvl(n.dpst_result, o.dpst_result) as dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
    ,nvl(n.dpst_status, o.dpst_status) as dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,nvl(n.proc_code, o.proc_code) as proc_code -- 返回码
    ,nvl(n.proc_msg, o.proc_msg) as proc_msg -- 返回结果
    ,nvl(n.rs_product, o.rs_product) as rs_product -- 存托应答方存托类产品
    ,nvl(n.rs_product_name, o.rs_product_name) as rs_product_name -- 存托产品名称
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.department_no, o.department_no) as department_no -- 部门编号
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.own_pro_no, o.own_pro_no) as own_pro_no -- 本方非法人产品号
    ,nvl(n.own_pro_name, o.own_pro_name) as own_pro_name -- 本方非法人产品名称
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,nvl(n.settle_fail_code, o.settle_fail_code) as settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,nvl(n.cust_brh_no, o.cust_brh_no) as cust_brh_no -- 存托应答机构
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 存托应答机构名称
    ,nvl(n.create_person, o.create_person) as create_person -- 创建人
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
from (select * from ${iol_schema}.bdms_cpes_dpst_apply_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_dpst_apply_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.contract_no <> n.contract_no
        or o.busi_date <> n.busi_date
        or o.apply_date <> n.apply_date
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.sum_draft_amount <> n.sum_draft_amount
        or o.sum_settle_amount <> n.sum_settle_amount
        or o.fin_rate_up <> n.fin_rate_up
        or o.fin_rate_down <> n.fin_rate_down
        or o.rate <> n.rate
        or o.apply_id <> n.apply_id
        or o.dpst_no <> n.dpst_no
        or o.dpst_result <> n.dpst_result
        or o.dpst_status <> n.dpst_status
        or o.settle_date <> n.settle_date
        or o.settle_mode <> n.settle_mode
        or o.proc_code <> n.proc_code
        or o.proc_msg <> n.proc_msg
        or o.rs_product <> n.rs_product
        or o.rs_product_name <> n.rs_product_name
        or o.manager_no <> n.manager_no
        or o.department_no <> n.department_no
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.message_status <> n.message_status
        or o.product_no <> n.product_no
        or o.own_pro_no <> n.own_pro_no
        or o.own_pro_name <> n.own_pro_name
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.settle_status <> n.settle_status
        or o.settle_fail_code <> n.settle_fail_code
        or o.cust_brh_no <> n.cust_brh_no
        or o.cust_name <> n.cust_name
        or o.create_person <> n.create_person
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_apply_contract_cl(
            id -- ID
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,apply_date -- 存托申请日期
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,sum_draft_amount -- 存托票据汇总金额
            ,sum_settle_amount -- 存托结算汇总金额
            ,fin_rate_up -- 存托利率上限
            ,fin_rate_down -- 存托利率下限
            ,rate -- 融资利率
            ,apply_id -- 存托申请单编号
            ,dpst_no -- 存托单编号
            ,dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,rs_product -- 存托应答方存托类产品
            ,rs_product_name -- 存托产品名称
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,product_no -- 产品号
            ,own_pro_no -- 本方非法人产品号
            ,own_pro_name -- 本方非法人产品名称
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,cust_brh_no -- 存托应答机构
            ,cust_name -- 存托应答机构名称
            ,create_person -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_apply_contract_op(
            id -- ID
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,apply_date -- 存托申请日期
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,sum_draft_amount -- 存托票据汇总金额
            ,sum_settle_amount -- 存托结算汇总金额
            ,fin_rate_up -- 存托利率上限
            ,fin_rate_down -- 存托利率下限
            ,rate -- 融资利率
            ,apply_id -- 存托申请单编号
            ,dpst_no -- 存托单编号
            ,dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
            ,dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,rs_product -- 存托应答方存托类产品
            ,rs_product_name -- 存托产品名称
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,product_no -- 产品号
            ,own_pro_no -- 本方非法人产品号
            ,own_pro_name -- 本方非法人产品名称
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
            ,cust_brh_no -- 存托应答机构
            ,cust_name -- 存托应答机构名称
            ,create_person -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.contract_no -- 批次号
    ,o.busi_date -- 业务日期
    ,o.apply_date -- 存托申请日期
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 业务机构号
    ,o.acct_branch_no -- 账务机构号
    ,o.sum_draft_amount -- 存托票据汇总金额
    ,o.sum_settle_amount -- 存托结算汇总金额
    ,o.fin_rate_up -- 存托利率上限
    ,o.fin_rate_down -- 存托利率下限
    ,o.rate -- 融资利率
    ,o.apply_id -- 存托申请单编号
    ,o.dpst_no -- 存托单编号
    ,o.dpst_result -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
    ,o.dpst_status -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,o.settle_date -- 结算日期
    ,o.settle_mode -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,o.proc_code -- 返回码
    ,o.proc_msg -- 返回结果
    ,o.rs_product -- 存托应答方存托类产品
    ,o.rs_product_name -- 存托产品名称
    ,o.manager_no -- 客户经理
    ,o.department_no -- 部门编号
    ,o.contract_status -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.message_status -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,o.product_no -- 产品号
    ,o.own_pro_no -- 本方非法人产品号
    ,o.own_pro_name -- 本方非法人产品名称
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,o.settle_fail_code -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,o.cust_brh_no -- 存托应答机构
    ,o.cust_name -- 存托应答机构名称
    ,o.create_person -- 创建人
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
from ${iol_schema}.bdms_cpes_dpst_apply_contract_bk o
    left join ${iol_schema}.bdms_cpes_dpst_apply_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_dpst_apply_contract_cl d
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
--truncate table ${iol_schema}.bdms_cpes_dpst_apply_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_dpst_apply_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_dpst_apply_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_dpst_apply_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_dpst_apply_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_dpst_apply_contract_cl;
alter table ${iol_schema}.bdms_cpes_dpst_apply_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_dpst_apply_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_dpst_apply_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_dpst_apply_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
