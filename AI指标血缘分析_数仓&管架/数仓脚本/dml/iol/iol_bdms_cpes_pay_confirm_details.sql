/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_pay_confirm_details
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
create table ${iol_schema}.bdms_cpes_pay_confirm_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_pay_confirm_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details_op purge;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_pay_confirm_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_pay_confirm_details where 0=1;

create table ${iol_schema}.bdms_cpes_pay_confirm_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_pay_confirm_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_pay_confirm_details_cl(
            id -- 
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,apply_date -- 业务申请日期
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sig_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_pay_confirm_details_op(
            id -- 
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,apply_date -- 业务申请日期
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sig_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 解析表ID
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 业务申请日期
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.refuse_reason, o.refuse_reason) as refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_mesg, o.err_mesg) as err_mesg -- 错误原因
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
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
from (select * from ${iol_schema}.bdms_cpes_pay_confirm_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_pay_confirm_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.draft_id <> n.draft_id
        or o.apply_id <> n.apply_id
        or o.apply_date <> n.apply_date
        or o.draft_amount <> n.draft_amount
        or o.draft_type <> n.draft_type
        or o.refuse_reason <> n.refuse_reason
        or o.deal_status <> n.deal_status
        or o.account_status <> n.account_status
        or o.sig_mk <> n.sig_mk
        or o.err_code <> n.err_code
        or o.err_mesg <> n.err_mesg
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_pay_confirm_details_cl(
            id -- 
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,apply_date -- 业务申请日期
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sig_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_pay_confirm_details_op(
            id -- 
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,apply_date -- 业务申请日期
            ,draft_amount -- 票面金额
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sig_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_id -- 批次表ID
    ,o.draft_id -- 票据表ID
    ,o.apply_id -- 解析表ID
    ,o.apply_date -- 业务申请日期
    ,o.draft_amount -- 票面金额
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.refuse_reason -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,o.deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.sig_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,o.err_code -- 错误码
    ,o.err_mesg -- 错误原因
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
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
from ${iol_schema}.bdms_cpes_pay_confirm_details_bk o
    left join ${iol_schema}.bdms_cpes_pay_confirm_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_pay_confirm_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_pay_confirm_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_pay_confirm_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_pay_confirm_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_pay_confirm_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_pay_confirm_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_pay_confirm_details_cl;
alter table ${iol_schema}.bdms_cpes_pay_confirm_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_pay_confirm_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_pay_confirm_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details_op purge;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_pay_confirm_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
