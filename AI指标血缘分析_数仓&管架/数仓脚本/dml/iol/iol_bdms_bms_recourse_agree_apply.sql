/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_recourse_agree_apply
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
create table ${iol_schema}.bdms_bms_recourse_agree_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_recourse_agree_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply_op purge;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_recourse_agree_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_recourse_agree_apply where 0=1;

create table ${iol_schema}.bdms_bms_recourse_agree_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_recourse_agree_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_recourse_agree_apply_cl(
            id -- ID
            ,draft_id -- 业务明细ID
            ,draft_number -- 票号
            ,isse_curcd -- 票据币种： CNY 人民币
            ,isse_amt -- 票据金额
            ,apply_date -- 同意清偿日期
            ,rcrs_curcd -- 同意清偿币种： CNY 人民币
            ,rcrs_amt -- 同意清偿金额
            ,rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,rcrs_name -- 同意清偿人名称
            ,rcrs_cmonid -- 同意清偿人组织机构代码
            ,rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
            ,rcrs_ubank -- 同意清偿人开户行行号
            ,rcrs_agcy_ubank -- 同意清偿人承接行行号
            ,req_remark -- 同意清偿申请备注
            ,rcv_remark -- 同意清偿签收备注
            ,rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
            ,receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
            ,cancel_date -- 撤销日期
            ,recourse_id -- 发出追索登记薄id
            ,last_operator_no -- 最后修改柜员号
            ,last_upd_time -- 最后修改时间
            ,purpose -- 用途： Y 银行端 W 网银端
            ,account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_recourse_agree_apply_op(
            id -- ID
            ,draft_id -- 业务明细ID
            ,draft_number -- 票号
            ,isse_curcd -- 票据币种： CNY 人民币
            ,isse_amt -- 票据金额
            ,apply_date -- 同意清偿日期
            ,rcrs_curcd -- 同意清偿币种： CNY 人民币
            ,rcrs_amt -- 同意清偿金额
            ,rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,rcrs_name -- 同意清偿人名称
            ,rcrs_cmonid -- 同意清偿人组织机构代码
            ,rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
            ,rcrs_ubank -- 同意清偿人开户行行号
            ,rcrs_agcy_ubank -- 同意清偿人承接行行号
            ,req_remark -- 同意清偿申请备注
            ,rcv_remark -- 同意清偿签收备注
            ,rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
            ,receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
            ,cancel_date -- 撤销日期
            ,recourse_id -- 发出追索登记薄id
            ,last_operator_no -- 最后修改柜员号
            ,last_upd_time -- 最后修改时间
            ,purpose -- 用途： Y 银行端 W 网银端
            ,account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 业务明细ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.isse_curcd, o.isse_curcd) as isse_curcd -- 票据币种： CNY 人民币
    ,nvl(n.isse_amt, o.isse_amt) as isse_amt -- 票据金额
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 同意清偿日期
    ,nvl(n.rcrs_curcd, o.rcrs_curcd) as rcrs_curcd -- 同意清偿币种： CNY 人民币
    ,nvl(n.rcrs_amt, o.rcrs_amt) as rcrs_amt -- 同意清偿金额
    ,nvl(n.rcrs_role, o.rcrs_role) as rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.rcrs_name, o.rcrs_name) as rcrs_name -- 同意清偿人名称
    ,nvl(n.rcrs_cmonid, o.rcrs_cmonid) as rcrs_cmonid -- 同意清偿人组织机构代码
    ,nvl(n.rcrs_actno, o.rcrs_actno) as rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
    ,nvl(n.rcrs_ubank, o.rcrs_ubank) as rcrs_ubank -- 同意清偿人开户行行号
    ,nvl(n.rcrs_agcy_ubank, o.rcrs_agcy_ubank) as rcrs_agcy_ubank -- 同意清偿人承接行行号
    ,nvl(n.req_remark, o.req_remark) as req_remark -- 同意清偿申请备注
    ,nvl(n.rcv_remark, o.rcv_remark) as rcv_remark -- 同意清偿签收备注
    ,nvl(n.rcv_prxy_sgntr, o.rcv_prxy_sgntr) as rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
    ,nvl(n.endst_date, o.endst_date) as endst_date -- 签收日期
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
    ,nvl(n.receive_status, o.receive_status) as receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,nvl(n.details_status, o.details_status) as details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 撤销日期
    ,nvl(n.recourse_id, o.recourse_id) as recourse_id -- 发出追索登记薄id
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后修改柜员号
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.purpose, o.purpose) as purpose -- 用途： Y 银行端 W 网银端
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.account_date, o.account_date) as account_date -- 
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
from (select * from ${iol_schema}.bdms_bms_recourse_agree_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_recourse_agree_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.isse_curcd <> n.isse_curcd
        or o.isse_amt <> n.isse_amt
        or o.apply_date <> n.apply_date
        or o.rcrs_curcd <> n.rcrs_curcd
        or o.rcrs_amt <> n.rcrs_amt
        or o.rcrs_role <> n.rcrs_role
        or o.rcrs_name <> n.rcrs_name
        or o.rcrs_cmonid <> n.rcrs_cmonid
        or o.rcrs_actno <> n.rcrs_actno
        or o.rcrs_ubank <> n.rcrs_ubank
        or o.rcrs_agcy_ubank <> n.rcrs_agcy_ubank
        or o.req_remark <> n.req_remark
        or o.rcv_remark <> n.rcv_remark
        or o.rcv_prxy_sgntr <> n.rcv_prxy_sgntr
        or o.endst_date <> n.endst_date
        or o.sig_mk <> n.sig_mk
        or o.receive_status <> n.receive_status
        or o.details_status <> n.details_status
        or o.cancel_date <> n.cancel_date
        or o.recourse_id <> n.recourse_id
        or o.last_operator_no <> n.last_operator_no
        or o.last_upd_time <> n.last_upd_time
        or o.purpose <> n.purpose
        or o.account_flag <> n.account_flag
        or o.account_date <> n.account_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_recourse_agree_apply_cl(
            id -- ID
            ,draft_id -- 业务明细ID
            ,draft_number -- 票号
            ,isse_curcd -- 票据币种： CNY 人民币
            ,isse_amt -- 票据金额
            ,apply_date -- 同意清偿日期
            ,rcrs_curcd -- 同意清偿币种： CNY 人民币
            ,rcrs_amt -- 同意清偿金额
            ,rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,rcrs_name -- 同意清偿人名称
            ,rcrs_cmonid -- 同意清偿人组织机构代码
            ,rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
            ,rcrs_ubank -- 同意清偿人开户行行号
            ,rcrs_agcy_ubank -- 同意清偿人承接行行号
            ,req_remark -- 同意清偿申请备注
            ,rcv_remark -- 同意清偿签收备注
            ,rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
            ,receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
            ,cancel_date -- 撤销日期
            ,recourse_id -- 发出追索登记薄id
            ,last_operator_no -- 最后修改柜员号
            ,last_upd_time -- 最后修改时间
            ,purpose -- 用途： Y 银行端 W 网银端
            ,account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_recourse_agree_apply_op(
            id -- ID
            ,draft_id -- 业务明细ID
            ,draft_number -- 票号
            ,isse_curcd -- 票据币种： CNY 人民币
            ,isse_amt -- 票据金额
            ,apply_date -- 同意清偿日期
            ,rcrs_curcd -- 同意清偿币种： CNY 人民币
            ,rcrs_amt -- 同意清偿金额
            ,rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,rcrs_name -- 同意清偿人名称
            ,rcrs_cmonid -- 同意清偿人组织机构代码
            ,rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
            ,rcrs_ubank -- 同意清偿人开户行行号
            ,rcrs_agcy_ubank -- 同意清偿人承接行行号
            ,req_remark -- 同意清偿申请备注
            ,rcv_remark -- 同意清偿签收备注
            ,rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
            ,receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
            ,cancel_date -- 撤销日期
            ,recourse_id -- 发出追索登记薄id
            ,last_operator_no -- 最后修改柜员号
            ,last_upd_time -- 最后修改时间
            ,purpose -- 用途： Y 银行端 W 网银端
            ,account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_id -- 业务明细ID
    ,o.draft_number -- 票号
    ,o.isse_curcd -- 票据币种： CNY 人民币
    ,o.isse_amt -- 票据金额
    ,o.apply_date -- 同意清偿日期
    ,o.rcrs_curcd -- 同意清偿币种： CNY 人民币
    ,o.rcrs_amt -- 同意清偿金额
    ,o.rcrs_role -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.rcrs_name -- 同意清偿人名称
    ,o.rcrs_cmonid -- 同意清偿人组织机构代码
    ,o.rcrs_actno -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
    ,o.rcrs_ubank -- 同意清偿人开户行行号
    ,o.rcrs_agcy_ubank -- 同意清偿人承接行行号
    ,o.req_remark -- 同意清偿申请备注
    ,o.rcv_remark -- 同意清偿签收备注
    ,o.rcv_prxy_sgntr -- 保证代理回复标识： PS01 客户自己签章
    ,o.endst_date -- 签收日期
    ,o.sig_mk -- 签收意见： SU00 同意签收 SU01 拒绝签收
    ,o.receive_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,o.details_status -- 明细状态： 00 未处理 01 处理中 02 处理完成
    ,o.cancel_date -- 撤销日期
    ,o.recourse_id -- 发出追索登记薄id
    ,o.last_operator_no -- 最后修改柜员号
    ,o.last_upd_time -- 最后修改时间
    ,o.purpose -- 用途： Y 银行端 W 网银端
    ,o.account_flag -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.account_date -- 
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
from ${iol_schema}.bdms_bms_recourse_agree_apply_bk o
    left join ${iol_schema}.bdms_bms_recourse_agree_apply_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_recourse_agree_apply_cl d
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
--truncate table ${iol_schema}.bdms_bms_recourse_agree_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_recourse_agree_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_recourse_agree_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_recourse_agree_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_recourse_agree_apply exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_recourse_agree_apply_cl;
alter table ${iol_schema}.bdms_bms_recourse_agree_apply exchange partition p_20991231 with table ${iol_schema}.bdms_bms_recourse_agree_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_recourse_agree_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply_op purge;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_recourse_agree_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
