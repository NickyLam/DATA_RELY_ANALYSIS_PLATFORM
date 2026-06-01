/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_offline_recovery_details
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
create table ${iol_schema}.bdms_cpes_offline_recovery_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_offline_recovery_details;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details_op purge;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_offline_recovery_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_offline_recovery_details where 0=1;

create table ${iol_schema}.bdms_cpes_offline_recovery_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_offline_recovery_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_offline_recovery_details_cl(
            id -- 
            ,contract_id -- 批次表ID
            ,recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
            ,draft_type -- 票据类别： AC01 银承 AC02 商承
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,payer_bank_no -- 付款行行号
            ,prmt_date -- 提示付款日期
            ,prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_offline_recovery_details_op(
            id -- 
            ,contract_id -- 批次表ID
            ,recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
            ,draft_type -- 票据类别： AC01 银承 AC02 商承
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,payer_bank_no -- 付款行行号
            ,prmt_date -- 提示付款日期
            ,prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.recovery_type, o.recovery_type) as recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类别： AC01 银承 AC02 商承
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款行行号
    ,nvl(n.prmt_date, o.prmt_date) as prmt_date -- 提示付款日期
    ,nvl(n.prmt_ref_code, o.prmt_ref_code) as prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
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
from (select * from ${iol_schema}.bdms_cpes_offline_recovery_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_offline_recovery_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.recovery_type <> n.recovery_type
        or o.draft_type <> n.draft_type
        or o.draft_id <> n.draft_id
        or o.draft_amount <> n.draft_amount
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.payer_bank_no <> n.payer_bank_no
        or o.prmt_date <> n.prmt_date
        or o.prmt_ref_code <> n.prmt_ref_code
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.deal_status <> n.deal_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_offline_recovery_details_cl(
            id -- 
            ,contract_id -- 批次表ID
            ,recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
            ,draft_type -- 票据类别： AC01 银承 AC02 商承
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,payer_bank_no -- 付款行行号
            ,prmt_date -- 提示付款日期
            ,prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_offline_recovery_details_op(
            id -- 
            ,contract_id -- 批次表ID
            ,recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
            ,draft_type -- 票据类别： AC01 银承 AC02 商承
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,payer_bank_no -- 付款行行号
            ,prmt_date -- 提示付款日期
            ,prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_id -- 批次表ID
    ,o.recovery_type -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
    ,o.draft_type -- 票据类别： AC01 银承 AC02 商承
    ,o.draft_id -- 票据ID
    ,o.draft_amount -- 票面金额
    ,o.remit_date -- 出票日
    ,o.maturity_date -- 到期日
    ,o.payer_bank_no -- 付款行行号
    ,o.prmt_date -- 提示付款日期
    ,o.prmt_ref_code -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,o.err_code -- 错误码
    ,o.err_msg -- 错误信息
    ,o.last_upd_opr -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_offline_recovery_details_bk o
    left join ${iol_schema}.bdms_cpes_offline_recovery_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_offline_recovery_details_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_offline_recovery_details;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_offline_recovery_details exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_offline_recovery_details_cl;
alter table ${iol_schema}.bdms_cpes_offline_recovery_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_offline_recovery_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_offline_recovery_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details_op purge;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_offline_recovery_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
