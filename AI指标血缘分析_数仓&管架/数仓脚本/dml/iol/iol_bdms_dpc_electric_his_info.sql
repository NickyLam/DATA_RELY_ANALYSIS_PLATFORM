/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_dpc_electric_his_info
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
create table ${iol_schema}.bdms_dpc_electric_his_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_dpc_electric_his_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_electric_his_info_op purge;
drop table ${iol_schema}.bdms_dpc_electric_his_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_electric_his_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_electric_his_info where 0=1;

create table ${iol_schema}.bdms_dpc_electric_his_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_electric_his_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_electric_his_info_cl(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,draft_id -- 票据ID
            ,draft_number -- 票据号码
            ,busi_type -- 业务类型
            ,busi_name -- 业务名称
            ,req_name -- 请求方名称
            ,req_cmon_id -- 请求方组织机构代码
            ,rcv_name -- 接收方名称
            ,rcv_cmon_id -- 接收方组织机构代码
            ,sign_date -- 签收日期
            ,endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,rpd_open_date -- 赎回开放日
            ,rpd_end_date -- 赎回截止日
            ,ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_name -- 承兑人名称
            ,acceptor_acct -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_cmon_id -- 承兑人组织机构代码
            ,acceptor_txn_ctrct_nb -- 承兑人交易合同编号
            ,acceptor_cdt_ratgs -- 承兑人信用等级
            ,acceptor_cdt_ratg_agcy -- 承兑人评级机构
            ,acceptor_cdt_ratg_due_date -- 承兑人评级到期日
            ,last_upd_time -- 最后操作时间
            ,guarantee_address -- 保证人地址
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_electric_his_info_op(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,draft_id -- 票据ID
            ,draft_number -- 票据号码
            ,busi_type -- 业务类型
            ,busi_name -- 业务名称
            ,req_name -- 请求方名称
            ,req_cmon_id -- 请求方组织机构代码
            ,rcv_name -- 接收方名称
            ,rcv_cmon_id -- 接收方组织机构代码
            ,sign_date -- 签收日期
            ,endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,rpd_open_date -- 赎回开放日
            ,rpd_end_date -- 赎回截止日
            ,ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_name -- 承兑人名称
            ,acceptor_acct -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_cmon_id -- 承兑人组织机构代码
            ,acceptor_txn_ctrct_nb -- 承兑人交易合同编号
            ,acceptor_cdt_ratgs -- 承兑人信用等级
            ,acceptor_cdt_ratg_agcy -- 承兑人评级机构
            ,acceptor_cdt_ratg_due_date -- 承兑人评级到期日
            ,last_upd_time -- 最后操作时间
            ,guarantee_address -- 保证人地址
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型
    ,nvl(n.busi_name, o.busi_name) as busi_name -- 业务名称
    ,nvl(n.req_name, o.req_name) as req_name -- 请求方名称
    ,nvl(n.req_cmon_id, o.req_cmon_id) as req_cmon_id -- 请求方组织机构代码
    ,nvl(n.rcv_name, o.rcv_name) as rcv_name -- 接收方名称
    ,nvl(n.rcv_cmon_id, o.rcv_cmon_id) as rcv_cmon_id -- 接收方组织机构代码
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签收日期
    ,nvl(n.endrsmt_mk, o.endrsmt_mk) as endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,nvl(n.rpd_open_date, o.rpd_open_date) as rpd_open_date -- 赎回开放日
    ,nvl(n.rpd_end_date, o.rpd_end_date) as rpd_end_date -- 赎回截止日
    ,nvl(n.ucondl_consgnmt_mrk, o.ucondl_consgnmt_mrk) as ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,nvl(n.ucondl_prms_mrk, o.ucondl_prms_mrk) as ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,nvl(n.acceptor_role, o.acceptor_role) as acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_acct, o.acceptor_acct) as acceptor_acct -- 承兑人账号
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行号
    ,nvl(n.acceptor_cmon_id, o.acceptor_cmon_id) as acceptor_cmon_id -- 承兑人组织机构代码
    ,nvl(n.acceptor_txn_ctrct_nb, o.acceptor_txn_ctrct_nb) as acceptor_txn_ctrct_nb -- 承兑人交易合同编号
    ,nvl(n.acceptor_cdt_ratgs, o.acceptor_cdt_ratgs) as acceptor_cdt_ratgs -- 承兑人信用等级
    ,nvl(n.acceptor_cdt_ratg_agcy, o.acceptor_cdt_ratg_agcy) as acceptor_cdt_ratg_agcy -- 承兑人评级机构
    ,nvl(n.acceptor_cdt_ratg_due_date, o.acceptor_cdt_ratg_due_date) as acceptor_cdt_ratg_due_date -- 承兑人评级到期日
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后操作时间
    ,nvl(n.guarantee_address, o.guarantee_address) as guarantee_address -- 保证人地址
    ,nvl(n.misc, o.misc) as misc -- 备注域
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
from (select * from ${iol_schema}.bdms_dpc_electric_his_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_dpc_electric_his_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.busi_type <> n.busi_type
        or o.busi_name <> n.busi_name
        or o.req_name <> n.req_name
        or o.req_cmon_id <> n.req_cmon_id
        or o.rcv_name <> n.rcv_name
        or o.rcv_cmon_id <> n.rcv_cmon_id
        or o.sign_date <> n.sign_date
        or o.endrsmt_mk <> n.endrsmt_mk
        or o.rpd_open_date <> n.rpd_open_date
        or o.rpd_end_date <> n.rpd_end_date
        or o.ucondl_consgnmt_mrk <> n.ucondl_consgnmt_mrk
        or o.ucondl_prms_mrk <> n.ucondl_prms_mrk
        or o.acceptor_role <> n.acceptor_role
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_acct <> n.acceptor_acct
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_cmon_id <> n.acceptor_cmon_id
        or o.acceptor_txn_ctrct_nb <> n.acceptor_txn_ctrct_nb
        or o.acceptor_cdt_ratgs <> n.acceptor_cdt_ratgs
        or o.acceptor_cdt_ratg_agcy <> n.acceptor_cdt_ratg_agcy
        or o.acceptor_cdt_ratg_due_date <> n.acceptor_cdt_ratg_due_date
        or o.last_upd_time <> n.last_upd_time
        or o.guarantee_address <> n.guarantee_address
        or o.misc <> n.misc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_electric_his_info_cl(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,draft_id -- 票据ID
            ,draft_number -- 票据号码
            ,busi_type -- 业务类型
            ,busi_name -- 业务名称
            ,req_name -- 请求方名称
            ,req_cmon_id -- 请求方组织机构代码
            ,rcv_name -- 接收方名称
            ,rcv_cmon_id -- 接收方组织机构代码
            ,sign_date -- 签收日期
            ,endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,rpd_open_date -- 赎回开放日
            ,rpd_end_date -- 赎回截止日
            ,ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_name -- 承兑人名称
            ,acceptor_acct -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_cmon_id -- 承兑人组织机构代码
            ,acceptor_txn_ctrct_nb -- 承兑人交易合同编号
            ,acceptor_cdt_ratgs -- 承兑人信用等级
            ,acceptor_cdt_ratg_agcy -- 承兑人评级机构
            ,acceptor_cdt_ratg_due_date -- 承兑人评级到期日
            ,last_upd_time -- 最后操作时间
            ,guarantee_address -- 保证人地址
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_electric_his_info_op(
            id -- ID
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,draft_id -- 票据ID
            ,draft_number -- 票据号码
            ,busi_type -- 业务类型
            ,busi_name -- 业务名称
            ,req_name -- 请求方名称
            ,req_cmon_id -- 请求方组织机构代码
            ,rcv_name -- 接收方名称
            ,rcv_cmon_id -- 接收方组织机构代码
            ,sign_date -- 签收日期
            ,endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,rpd_open_date -- 赎回开放日
            ,rpd_end_date -- 赎回截止日
            ,ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_name -- 承兑人名称
            ,acceptor_acct -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_cmon_id -- 承兑人组织机构代码
            ,acceptor_txn_ctrct_nb -- 承兑人交易合同编号
            ,acceptor_cdt_ratgs -- 承兑人信用等级
            ,acceptor_cdt_ratg_agcy -- 承兑人评级机构
            ,acceptor_cdt_ratg_due_date -- 承兑人评级到期日
            ,last_upd_time -- 最后操作时间
            ,guarantee_address -- 保证人地址
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.draft_id -- 票据ID
    ,o.draft_number -- 票据号码
    ,o.busi_type -- 业务类型
    ,o.busi_name -- 业务名称
    ,o.req_name -- 请求方名称
    ,o.req_cmon_id -- 请求方组织机构代码
    ,o.rcv_name -- 接收方名称
    ,o.rcv_cmon_id -- 接收方组织机构代码
    ,o.sign_date -- 签收日期
    ,o.endrsmt_mk -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,o.rpd_open_date -- 赎回开放日
    ,o.rpd_end_date -- 赎回截止日
    ,o.ucondl_consgnmt_mrk -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,o.ucondl_prms_mrk -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,o.acceptor_role -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_acct -- 承兑人账号
    ,o.acceptor_bank_no -- 承兑人开户行号
    ,o.acceptor_cmon_id -- 承兑人组织机构代码
    ,o.acceptor_txn_ctrct_nb -- 承兑人交易合同编号
    ,o.acceptor_cdt_ratgs -- 承兑人信用等级
    ,o.acceptor_cdt_ratg_agcy -- 承兑人评级机构
    ,o.acceptor_cdt_ratg_due_date -- 承兑人评级到期日
    ,o.last_upd_time -- 最后操作时间
    ,o.guarantee_address -- 保证人地址
    ,o.misc -- 备注域
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_dpc_electric_his_info_bk o
    left join ${iol_schema}.bdms_dpc_electric_his_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_dpc_electric_his_info_cl d
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
-- truncate table ${iol_schema}.bdms_dpc_electric_his_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_dpc_electric_his_info exchange partition p_19000101 with table ${iol_schema}.bdms_dpc_electric_his_info_cl;
alter table ${iol_schema}.bdms_dpc_electric_his_info exchange partition p_20991231 with table ${iol_schema}.bdms_dpc_electric_his_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_dpc_electric_his_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_electric_his_info_op purge;
drop table ${iol_schema}.bdms_dpc_electric_his_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_dpc_electric_his_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_dpc_electric_his_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
