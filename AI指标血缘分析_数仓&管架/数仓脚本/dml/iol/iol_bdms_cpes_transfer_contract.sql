/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_transfer_contract
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
create table ${iol_schema}.bdms_cpes_transfer_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_transfer_contract;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_transfer_contract_op purge;
drop table ${iol_schema}.bdms_cpes_transfer_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_transfer_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_transfer_contract where 0=1;

create table ${iol_schema}.bdms_cpes_transfer_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_transfer_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_transfer_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,busi_type -- 业务类型： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,product_no -- 产品号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,acct_branch_no -- 账务机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,transfer_name -- 非交易过户对手名称
            ,transfer_bank_no -- 非交易过户对手行号
            ,transfer_brh_no -- 非交易过户对手机构代码
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_transfer_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,busi_type -- 业务类型： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,product_no -- 产品号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,acct_branch_no -- 账务机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,transfer_name -- 非交易过户对手名称
            ,transfer_bank_no -- 非交易过户对手行号
            ,transfer_brh_no -- 非交易过户对手机构代码
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： 01 申请 02 签收
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.recept_brh_id, o.recept_brh_id) as recept_brh_id -- 承接行机构代码
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 业务申请日期
    ,nvl(n.transfer_name, o.transfer_name) as transfer_name -- 非交易过户对手名称
    ,nvl(n.transfer_bank_no, o.transfer_bank_no) as transfer_bank_no -- 非交易过户对手行号
    ,nvl(n.transfer_brh_no, o.transfer_brh_no) as transfer_brh_no -- 非交易过户对手机构代码
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门号
    ,nvl(n.manage_no, o.manage_no) as manage_no -- 客户经理号
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
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
from (select * from ${iol_schema}.bdms_cpes_transfer_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_transfer_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.busi_type <> n.busi_type
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.product_no <> n.product_no
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.recept_brh_id <> n.recept_brh_id
        or o.apply_date <> n.apply_date
        or o.transfer_name <> n.transfer_name
        or o.transfer_bank_no <> n.transfer_bank_no
        or o.transfer_brh_no <> n.transfer_brh_no
        or o.department_no <> n.department_no
        or o.manage_no <> n.manage_no
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.message_status <> n.message_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.created_by <> n.created_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_transfer_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,busi_type -- 业务类型： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,product_no -- 产品号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,acct_branch_no -- 账务机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,transfer_name -- 非交易过户对手名称
            ,transfer_bank_no -- 非交易过户对手行号
            ,transfer_brh_no -- 非交易过户对手机构代码
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_transfer_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,busi_type -- 业务类型： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,product_no -- 产品号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,acct_branch_no -- 账务机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,transfer_name -- 非交易过户对手名称
            ,transfer_bank_no -- 非交易过户对手行号
            ,transfer_brh_no -- 非交易过户对手机构代码
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_no -- 批次号
    ,o.busi_type -- 业务类型： 01 申请 02 签收
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.product_no -- 产品号
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.acct_branch_no -- 账务机构号
    ,o.recept_brh_id -- 承接行机构代码
    ,o.apply_date -- 业务申请日期
    ,o.transfer_name -- 非交易过户对手名称
    ,o.transfer_bank_no -- 非交易过户对手行号
    ,o.transfer_brh_no -- 非交易过户对手机构代码
    ,o.department_no -- 所属部门号
    ,o.manage_no -- 客户经理号
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.created_by -- 创建人
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_transfer_contract_bk o
    left join ${iol_schema}.bdms_cpes_transfer_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_transfer_contract_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_transfer_contract;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_transfer_contract exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_transfer_contract_cl;
alter table ${iol_schema}.bdms_cpes_transfer_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_transfer_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_transfer_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_transfer_contract_op purge;
drop table ${iol_schema}.bdms_cpes_transfer_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_transfer_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_transfer_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
