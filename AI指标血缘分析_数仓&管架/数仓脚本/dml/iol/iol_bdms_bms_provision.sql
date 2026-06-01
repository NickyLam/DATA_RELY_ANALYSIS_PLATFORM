/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_provision
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
create table ${iol_schema}.bdms_bms_provision_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_provision
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_provision_op purge;
drop table ${iol_schema}.bdms_bms_provision_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_provision_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_provision where 0=1;

create table ${iol_schema}.bdms_bms_provision_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_provision where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_provision_cl(
            prov_id -- 计提主表ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构编号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,product_no -- 业务产品号
            ,interest -- 利息
            ,it_in_subject_no -- 利息收入科目
            ,it_back_subject_no -- 计提后科目
            ,it_sale_subject_no -- 卖断后科目
            ,start_dt_ora -- 计提开始日
            ,end_dt_ora -- 结束计提日
            ,real_enddt -- 实际结束计提日
            ,jiti_dt -- 计提日
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,prov_interest -- 已计提利息
            ,rema_interest -- 剩余利息
            ,ever_pro_amount -- 每日记提金额
            ,sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
            ,err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sele_prono -- 卖出产品号
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,update_time -- 更新时间
            ,acct_branch_no -- 账务机构号
            ,draft_attr -- 
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,draft_amount -- 票面金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_provision_op(
            prov_id -- 计提主表ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构编号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,product_no -- 业务产品号
            ,interest -- 利息
            ,it_in_subject_no -- 利息收入科目
            ,it_back_subject_no -- 计提后科目
            ,it_sale_subject_no -- 卖断后科目
            ,start_dt_ora -- 计提开始日
            ,end_dt_ora -- 结束计提日
            ,real_enddt -- 实际结束计提日
            ,jiti_dt -- 计提日
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,prov_interest -- 已计提利息
            ,rema_interest -- 剩余利息
            ,ever_pro_amount -- 每日记提金额
            ,sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
            ,err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sele_prono -- 卖出产品号
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,update_time -- 更新时间
            ,acct_branch_no -- 账务机构号
            ,draft_attr -- 
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,draft_amount -- 票面金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prov_id, o.prov_id) as prov_id -- 计提主表ID
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 交易机构编号
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.detail_id, o.detail_id) as detail_id -- 业务明细ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.product_no, o.product_no) as product_no -- 业务产品号
    ,nvl(n.interest, o.interest) as interest -- 利息
    ,nvl(n.it_in_subject_no, o.it_in_subject_no) as it_in_subject_no -- 利息收入科目
    ,nvl(n.it_back_subject_no, o.it_back_subject_no) as it_back_subject_no -- 计提后科目
    ,nvl(n.it_sale_subject_no, o.it_sale_subject_no) as it_sale_subject_no -- 卖断后科目
    ,nvl(n.start_dt_ora, o.start_dt_ora) as start_dt_ora -- 计提开始日
    ,nvl(n.end_dt_ora, o.end_dt_ora) as end_dt_ora -- 结束计提日
    ,nvl(n.real_enddt, o.real_enddt) as real_enddt -- 实际结束计提日
    ,nvl(n.jiti_dt, o.jiti_dt) as jiti_dt -- 计提日
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 计息到期日
    ,nvl(n.payment_days, o.payment_days) as payment_days -- 计息天数
    ,nvl(n.prov_interest, o.prov_interest) as prov_interest -- 已计提利息
    ,nvl(n.rema_interest, o.rema_interest) as rema_interest -- 剩余利息
    ,nvl(n.ever_pro_amount, o.ever_pro_amount) as ever_pro_amount -- 每日记提金额
    ,nvl(n.sale_run_interest, o.sale_run_interest) as sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
    ,nvl(n.sale_detail_id, o.sale_detail_id) as sale_detail_id -- 卖断时关联业务明细ID
    ,nvl(n.jiti_type, o.jiti_type) as jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,nvl(n.status, o.status) as status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
    ,nvl(n.err_flag, o.err_flag) as err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,nvl(n.sele_prono, o.sele_prono) as sele_prono -- 卖出产品号
    ,nvl(n.buy_protocol_no, o.buy_protocol_no) as buy_protocol_no -- 买入协议号
    ,nvl(n.sale_contract_id, o.sale_contract_id) as sale_contract_id -- 卖出协议ID
    ,nvl(n.sale_protocol_no, o.sale_protocol_no) as sale_protocol_no -- 卖出协议号
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.sale_draft_id, o.sale_draft_id) as sale_draft_id -- 结束的票据ID
    ,nvl(n.sale_cd_range, o.sale_cd_range) as sale_cd_range -- 结束的子票区间
    ,nvl(n.bms_draft_id, o.bms_draft_id) as bms_draft_id -- 原票据系统的登记中心ID
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态
    ,nvl(n.sale_amount, o.sale_amount) as sale_amount -- 结束金额
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,case when
            n.prov_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prov_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prov_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_provision_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_provision where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prov_id = n.prov_id
where (
        o.prov_id is null
    )
    or (
        n.prov_id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.contract_id <> n.contract_id
        or o.detail_id <> n.detail_id
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.draft_type <> n.draft_type
        or o.product_no <> n.product_no
        or o.interest <> n.interest
        or o.it_in_subject_no <> n.it_in_subject_no
        or o.it_back_subject_no <> n.it_back_subject_no
        or o.it_sale_subject_no <> n.it_sale_subject_no
        or o.start_dt_ora <> n.start_dt_ora
        or o.end_dt_ora <> n.end_dt_ora
        or o.real_enddt <> n.real_enddt
        or o.jiti_dt <> n.jiti_dt
        or o.payment_date <> n.payment_date
        or o.payment_days <> n.payment_days
        or o.prov_interest <> n.prov_interest
        or o.rema_interest <> n.rema_interest
        or o.ever_pro_amount <> n.ever_pro_amount
        or o.sale_run_interest <> n.sale_run_interest
        or o.sale_detail_id <> n.sale_detail_id
        or o.jiti_type <> n.jiti_type
        or o.status <> n.status
        or o.err_flag <> n.err_flag
        or o.create_time <> n.create_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.sele_prono <> n.sele_prono
        or o.buy_protocol_no <> n.buy_protocol_no
        or o.sale_contract_id <> n.sale_contract_id
        or o.sale_protocol_no <> n.sale_protocol_no
        or o.update_time <> n.update_time
        or o.acct_branch_no <> n.acct_branch_no
        or o.draft_attr <> n.draft_attr
        or o.cd_range <> n.cd_range
        or o.cd_split <> n.cd_split
        or o.sale_draft_id <> n.sale_draft_id
        or o.sale_cd_range <> n.sale_cd_range
        or o.bms_draft_id <> n.bms_draft_id
        or o.settle_status <> n.settle_status
        or o.sale_amount <> n.sale_amount
        or o.draft_amount <> n.draft_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_provision_cl(
            prov_id -- 计提主表ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构编号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,product_no -- 业务产品号
            ,interest -- 利息
            ,it_in_subject_no -- 利息收入科目
            ,it_back_subject_no -- 计提后科目
            ,it_sale_subject_no -- 卖断后科目
            ,start_dt_ora -- 计提开始日
            ,end_dt_ora -- 结束计提日
            ,real_enddt -- 实际结束计提日
            ,jiti_dt -- 计提日
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,prov_interest -- 已计提利息
            ,rema_interest -- 剩余利息
            ,ever_pro_amount -- 每日记提金额
            ,sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
            ,err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sele_prono -- 卖出产品号
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,update_time -- 更新时间
            ,acct_branch_no -- 账务机构号
            ,draft_attr -- 
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,draft_amount -- 票面金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_provision_op(
            prov_id -- 计提主表ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构编号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,product_no -- 业务产品号
            ,interest -- 利息
            ,it_in_subject_no -- 利息收入科目
            ,it_back_subject_no -- 计提后科目
            ,it_sale_subject_no -- 卖断后科目
            ,start_dt_ora -- 计提开始日
            ,end_dt_ora -- 结束计提日
            ,real_enddt -- 实际结束计提日
            ,jiti_dt -- 计提日
            ,payment_date -- 计息到期日
            ,payment_days -- 计息天数
            ,prov_interest -- 已计提利息
            ,rema_interest -- 剩余利息
            ,ever_pro_amount -- 每日记提金额
            ,sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
            ,err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
            ,create_time -- 创建时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sele_prono -- 卖出产品号
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,update_time -- 更新时间
            ,acct_branch_no -- 账务机构号
            ,draft_attr -- 
            ,cd_range -- 子票区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,draft_amount -- 票面金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prov_id -- 计提主表ID
    ,o.top_branch_no -- 所属总行机构号
    ,o.busi_branch_no -- 交易机构编号
    ,o.contract_id -- 协议ID
    ,o.detail_id -- 业务明细ID
    ,o.draft_id -- 票据ID
    ,o.draft_number -- 票据号
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.product_no -- 业务产品号
    ,o.interest -- 利息
    ,o.it_in_subject_no -- 利息收入科目
    ,o.it_back_subject_no -- 计提后科目
    ,o.it_sale_subject_no -- 卖断后科目
    ,o.start_dt_ora -- 计提开始日
    ,o.end_dt_ora -- 结束计提日
    ,o.real_enddt -- 实际结束计提日
    ,o.jiti_dt -- 计提日
    ,o.payment_date -- 计息到期日
    ,o.payment_days -- 计息天数
    ,o.prov_interest -- 已计提利息
    ,o.rema_interest -- 剩余利息
    ,o.ever_pro_amount -- 每日记提金额
    ,o.sale_run_interest -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
    ,o.sale_detail_id -- 卖断时关联业务明细ID
    ,o.jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,o.status -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
    ,o.err_flag -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
    ,o.create_time -- 创建时间
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.sele_prono -- 卖出产品号
    ,o.buy_protocol_no -- 买入协议号
    ,o.sale_contract_id -- 卖出协议ID
    ,o.sale_protocol_no -- 卖出协议号
    ,o.update_time -- 更新时间
    ,o.acct_branch_no -- 账务机构号
    ,o.draft_attr -- 
    ,o.cd_range -- 子票区间
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.sale_draft_id -- 结束的票据ID
    ,o.sale_cd_range -- 结束的子票区间
    ,o.bms_draft_id -- 原票据系统的登记中心ID
    ,o.settle_status -- 结算状态
    ,o.sale_amount -- 结束金额
    ,o.draft_amount -- 票面金额
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
from ${iol_schema}.bdms_bms_provision_bk o
    left join ${iol_schema}.bdms_bms_provision_op n
        on
            o.prov_id = n.prov_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_provision_cl d
        on
            o.prov_id = d.prov_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_provision;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_provision') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_provision drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_provision add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_provision exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_provision_cl;
alter table ${iol_schema}.bdms_bms_provision exchange partition p_20991231 with table ${iol_schema}.bdms_bms_provision_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_provision to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_provision_op purge;
drop table ${iol_schema}.bdms_bms_provision_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_provision_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_provision',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
