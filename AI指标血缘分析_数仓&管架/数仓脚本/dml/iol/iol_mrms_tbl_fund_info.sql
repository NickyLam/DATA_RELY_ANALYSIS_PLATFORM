/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_fund_info
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
create table ${iol_schema}.mrms_tbl_fund_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_fund_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_fund_info_op purge;
drop table ${iol_schema}.mrms_tbl_fund_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_fund_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_fund_info where 0=1;

create table ${iol_schema}.mrms_tbl_fund_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_fund_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_fund_info_cl(
            fund_id -- 基金编号
            ,fund_name -- 基金名称
            ,fund_short_name -- 简称
            ,channel_id -- 渠道编号
            ,agent_id -- 代理商编号
            ,pro_type -- 产品类型 0：智慧校园，1：全渠道代付
            ,acq_inst_id -- 所属分行
            ,licence_no -- 营业执照号
            ,licence_end_date -- 营业执照号有效期
            ,cash_deposit -- 保证金
            ,manager -- 法人姓名
            ,artif_certif_tp -- 证件类型
            ,identity_no -- 证件号
            ,manager_tel -- 法人手机号
            ,email -- 邮箱
            ,contact -- 联系人
            ,conm_certif_tp -- 联系人证件类型
            ,conm_identity_no -- 联系人证件号
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,open_acct_addr -- 开户地址
            ,fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
            ,rcv_account -- 收款账号
            ,rcv_account_name -- 收款账户名称
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,api_id -- api系统标识
            ,cushion_acct -- 垫资账户
            ,cushion_acct_name -- 垫资账户名
            ,fund_amt -- 基金额度
            ,sing_limit -- 单笔限额
            ,used_amt -- 已使用额度
            ,trand_amt -- 代付还款额度
            ,cushion_amt -- 垫资金额
            ,last_used_amt -- 上次使用额度
            ,rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
            ,cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
            ,sms_phone -- 短信通知手机号
            ,sms_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_fund_info_op(
            fund_id -- 基金编号
            ,fund_name -- 基金名称
            ,fund_short_name -- 简称
            ,channel_id -- 渠道编号
            ,agent_id -- 代理商编号
            ,pro_type -- 产品类型 0：智慧校园，1：全渠道代付
            ,acq_inst_id -- 所属分行
            ,licence_no -- 营业执照号
            ,licence_end_date -- 营业执照号有效期
            ,cash_deposit -- 保证金
            ,manager -- 法人姓名
            ,artif_certif_tp -- 证件类型
            ,identity_no -- 证件号
            ,manager_tel -- 法人手机号
            ,email -- 邮箱
            ,contact -- 联系人
            ,conm_certif_tp -- 联系人证件类型
            ,conm_identity_no -- 联系人证件号
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,open_acct_addr -- 开户地址
            ,fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
            ,rcv_account -- 收款账号
            ,rcv_account_name -- 收款账户名称
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,api_id -- api系统标识
            ,cushion_acct -- 垫资账户
            ,cushion_acct_name -- 垫资账户名
            ,fund_amt -- 基金额度
            ,sing_limit -- 单笔限额
            ,used_amt -- 已使用额度
            ,trand_amt -- 代付还款额度
            ,cushion_amt -- 垫资金额
            ,last_used_amt -- 上次使用额度
            ,rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
            ,cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
            ,sms_phone -- 短信通知手机号
            ,sms_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fund_id, o.fund_id) as fund_id -- 基金编号
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 基金名称
    ,nvl(n.fund_short_name, o.fund_short_name) as fund_short_name -- 简称
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 渠道编号
    ,nvl(n.agent_id, o.agent_id) as agent_id -- 代理商编号
    ,nvl(n.pro_type, o.pro_type) as pro_type -- 产品类型 0：智慧校园，1：全渠道代付
    ,nvl(n.acq_inst_id, o.acq_inst_id) as acq_inst_id -- 所属分行
    ,nvl(n.licence_no, o.licence_no) as licence_no -- 营业执照号
    ,nvl(n.licence_end_date, o.licence_end_date) as licence_end_date -- 营业执照号有效期
    ,nvl(n.cash_deposit, o.cash_deposit) as cash_deposit -- 保证金
    ,nvl(n.manager, o.manager) as manager -- 法人姓名
    ,nvl(n.artif_certif_tp, o.artif_certif_tp) as artif_certif_tp -- 证件类型
    ,nvl(n.identity_no, o.identity_no) as identity_no -- 证件号
    ,nvl(n.manager_tel, o.manager_tel) as manager_tel -- 法人手机号
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.contact, o.contact) as contact -- 联系人
    ,nvl(n.conm_certif_tp, o.conm_certif_tp) as conm_certif_tp -- 联系人证件类型
    ,nvl(n.conm_identity_no, o.conm_identity_no) as conm_identity_no -- 联系人证件号
    ,nvl(n.comm_tel, o.comm_tel) as comm_tel -- 联系人电话
    ,nvl(n.post_code, o.post_code) as post_code -- 邮编
    ,nvl(n.comm_addr, o.comm_addr) as comm_addr -- 联系地址
    ,nvl(n.sett_account, o.sett_account) as sett_account -- 结算账户
    ,nvl(n.sett_account_name, o.sett_account_name) as sett_account_name -- 结算账户名
    ,nvl(n.sett_account_type, o.sett_account_type) as sett_account_type -- 结算账户类型
    ,nvl(n.acct_chnl, o.acct_chnl) as acct_chnl -- 入账渠道
    ,nvl(n.open_bank, o.open_bank) as open_bank -- 开户行行号
    ,nvl(n.open_bankname, o.open_bankname) as open_bankname -- 开户行行名
    ,nvl(n.open_acct_addr, o.open_acct_addr) as open_acct_addr -- 开户地址
    ,nvl(n.fund_status, o.fund_status) as fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
    ,nvl(n.rcv_account, o.rcv_account) as rcv_account -- 收款账号
    ,nvl(n.rcv_account_name, o.rcv_account_name) as rcv_account_name -- 收款账户名称
    ,nvl(n.create_date, o.create_date) as create_date -- 新增日期
    ,nvl(n.modfiy_date, o.modfiy_date) as modfiy_date -- 最后修改日期
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 操作员
    ,nvl(n.api_id, o.api_id) as api_id -- api系统标识
    ,nvl(n.cushion_acct, o.cushion_acct) as cushion_acct -- 垫资账户
    ,nvl(n.cushion_acct_name, o.cushion_acct_name) as cushion_acct_name -- 垫资账户名
    ,nvl(n.fund_amt, o.fund_amt) as fund_amt -- 基金额度
    ,nvl(n.sing_limit, o.sing_limit) as sing_limit -- 单笔限额
    ,nvl(n.used_amt, o.used_amt) as used_amt -- 已使用额度
    ,nvl(n.trand_amt, o.trand_amt) as trand_amt -- 代付还款额度
    ,nvl(n.cushion_amt, o.cushion_amt) as cushion_amt -- 垫资金额
    ,nvl(n.last_used_amt, o.last_used_amt) as last_used_amt -- 上次使用额度
    ,nvl(n.rcv_acct_type, o.rcv_acct_type) as rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
    ,nvl(n.cushion_acct_type, o.cushion_acct_type) as cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
    ,nvl(n.sms_phone, o.sms_phone) as sms_phone -- 短信通知手机号
    ,nvl(n.sms_name, o.sms_name) as sms_name -- 短信通知姓名
    ,case when
            n.fund_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fund_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fund_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_fund_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_fund_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fund_id = n.fund_id
where (
        o.fund_id is null
    )
    or (
        n.fund_id is null
    )
    or (
        o.fund_name <> n.fund_name
        or o.fund_short_name <> n.fund_short_name
        or o.channel_id <> n.channel_id
        or o.agent_id <> n.agent_id
        or o.pro_type <> n.pro_type
        or o.acq_inst_id <> n.acq_inst_id
        or o.licence_no <> n.licence_no
        or o.licence_end_date <> n.licence_end_date
        or o.cash_deposit <> n.cash_deposit
        or o.manager <> n.manager
        or o.artif_certif_tp <> n.artif_certif_tp
        or o.identity_no <> n.identity_no
        or o.manager_tel <> n.manager_tel
        or o.email <> n.email
        or o.contact <> n.contact
        or o.conm_certif_tp <> n.conm_certif_tp
        or o.conm_identity_no <> n.conm_identity_no
        or o.comm_tel <> n.comm_tel
        or o.post_code <> n.post_code
        or o.comm_addr <> n.comm_addr
        or o.sett_account <> n.sett_account
        or o.sett_account_name <> n.sett_account_name
        or o.sett_account_type <> n.sett_account_type
        or o.acct_chnl <> n.acct_chnl
        or o.open_bank <> n.open_bank
        or o.open_bankname <> n.open_bankname
        or o.open_acct_addr <> n.open_acct_addr
        or o.fund_status <> n.fund_status
        or o.rcv_account <> n.rcv_account
        or o.rcv_account_name <> n.rcv_account_name
        or o.create_date <> n.create_date
        or o.modfiy_date <> n.modfiy_date
        or o.opr_id <> n.opr_id
        or o.api_id <> n.api_id
        or o.cushion_acct <> n.cushion_acct
        or o.cushion_acct_name <> n.cushion_acct_name
        or o.fund_amt <> n.fund_amt
        or o.sing_limit <> n.sing_limit
        or o.used_amt <> n.used_amt
        or o.trand_amt <> n.trand_amt
        or o.cushion_amt <> n.cushion_amt
        or o.last_used_amt <> n.last_used_amt
        or o.rcv_acct_type <> n.rcv_acct_type
        or o.cushion_acct_type <> n.cushion_acct_type
        or o.sms_phone <> n.sms_phone
        or o.sms_name <> n.sms_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_fund_info_cl(
            fund_id -- 基金编号
            ,fund_name -- 基金名称
            ,fund_short_name -- 简称
            ,channel_id -- 渠道编号
            ,agent_id -- 代理商编号
            ,pro_type -- 产品类型 0：智慧校园，1：全渠道代付
            ,acq_inst_id -- 所属分行
            ,licence_no -- 营业执照号
            ,licence_end_date -- 营业执照号有效期
            ,cash_deposit -- 保证金
            ,manager -- 法人姓名
            ,artif_certif_tp -- 证件类型
            ,identity_no -- 证件号
            ,manager_tel -- 法人手机号
            ,email -- 邮箱
            ,contact -- 联系人
            ,conm_certif_tp -- 联系人证件类型
            ,conm_identity_no -- 联系人证件号
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,open_acct_addr -- 开户地址
            ,fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
            ,rcv_account -- 收款账号
            ,rcv_account_name -- 收款账户名称
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,api_id -- api系统标识
            ,cushion_acct -- 垫资账户
            ,cushion_acct_name -- 垫资账户名
            ,fund_amt -- 基金额度
            ,sing_limit -- 单笔限额
            ,used_amt -- 已使用额度
            ,trand_amt -- 代付还款额度
            ,cushion_amt -- 垫资金额
            ,last_used_amt -- 上次使用额度
            ,rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
            ,cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
            ,sms_phone -- 短信通知手机号
            ,sms_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_fund_info_op(
            fund_id -- 基金编号
            ,fund_name -- 基金名称
            ,fund_short_name -- 简称
            ,channel_id -- 渠道编号
            ,agent_id -- 代理商编号
            ,pro_type -- 产品类型 0：智慧校园，1：全渠道代付
            ,acq_inst_id -- 所属分行
            ,licence_no -- 营业执照号
            ,licence_end_date -- 营业执照号有效期
            ,cash_deposit -- 保证金
            ,manager -- 法人姓名
            ,artif_certif_tp -- 证件类型
            ,identity_no -- 证件号
            ,manager_tel -- 法人手机号
            ,email -- 邮箱
            ,contact -- 联系人
            ,conm_certif_tp -- 联系人证件类型
            ,conm_identity_no -- 联系人证件号
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,open_acct_addr -- 开户地址
            ,fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
            ,rcv_account -- 收款账号
            ,rcv_account_name -- 收款账户名称
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,api_id -- api系统标识
            ,cushion_acct -- 垫资账户
            ,cushion_acct_name -- 垫资账户名
            ,fund_amt -- 基金额度
            ,sing_limit -- 单笔限额
            ,used_amt -- 已使用额度
            ,trand_amt -- 代付还款额度
            ,cushion_amt -- 垫资金额
            ,last_used_amt -- 上次使用额度
            ,rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
            ,cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
            ,sms_phone -- 短信通知手机号
            ,sms_name -- 短信通知姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fund_id -- 基金编号
    ,o.fund_name -- 基金名称
    ,o.fund_short_name -- 简称
    ,o.channel_id -- 渠道编号
    ,o.agent_id -- 代理商编号
    ,o.pro_type -- 产品类型 0：智慧校园，1：全渠道代付
    ,o.acq_inst_id -- 所属分行
    ,o.licence_no -- 营业执照号
    ,o.licence_end_date -- 营业执照号有效期
    ,o.cash_deposit -- 保证金
    ,o.manager -- 法人姓名
    ,o.artif_certif_tp -- 证件类型
    ,o.identity_no -- 证件号
    ,o.manager_tel -- 法人手机号
    ,o.email -- 邮箱
    ,o.contact -- 联系人
    ,o.conm_certif_tp -- 联系人证件类型
    ,o.conm_identity_no -- 联系人证件号
    ,o.comm_tel -- 联系人电话
    ,o.post_code -- 邮编
    ,o.comm_addr -- 联系地址
    ,o.sett_account -- 结算账户
    ,o.sett_account_name -- 结算账户名
    ,o.sett_account_type -- 结算账户类型
    ,o.acct_chnl -- 入账渠道
    ,o.open_bank -- 开户行行号
    ,o.open_bankname -- 开户行行名
    ,o.open_acct_addr -- 开户地址
    ,o.fund_status -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
    ,o.rcv_account -- 收款账号
    ,o.rcv_account_name -- 收款账户名称
    ,o.create_date -- 新增日期
    ,o.modfiy_date -- 最后修改日期
    ,o.opr_id -- 操作员
    ,o.api_id -- api系统标识
    ,o.cushion_acct -- 垫资账户
    ,o.cushion_acct_name -- 垫资账户名
    ,o.fund_amt -- 基金额度
    ,o.sing_limit -- 单笔限额
    ,o.used_amt -- 已使用额度
    ,o.trand_amt -- 代付还款额度
    ,o.cushion_amt -- 垫资金额
    ,o.last_used_amt -- 上次使用额度
    ,o.rcv_acct_type -- 收款账户类型 0:内部账号 1一类账号 2二类账号
    ,o.cushion_acct_type -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
    ,o.sms_phone -- 短信通知手机号
    ,o.sms_name -- 短信通知姓名
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
from ${iol_schema}.mrms_tbl_fund_info_bk o
    left join ${iol_schema}.mrms_tbl_fund_info_op n
        on
            o.fund_id = n.fund_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_fund_info_cl d
        on
            o.fund_id = d.fund_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_fund_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_fund_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_fund_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_fund_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_fund_info exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_fund_info_cl;
alter table ${iol_schema}.mrms_tbl_fund_info exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_fund_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_fund_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_fund_info_op purge;
drop table ${iol_schema}.mrms_tbl_fund_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_fund_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_fund_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
