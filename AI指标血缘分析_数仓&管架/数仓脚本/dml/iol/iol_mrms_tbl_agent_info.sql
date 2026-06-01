/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_agent_info
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
create table ${iol_schema}.mrms_tbl_agent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_agent_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_agent_info_op purge;
drop table ${iol_schema}.mrms_tbl_agent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_agent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_agent_info where 0=1;

create table ${iol_schema}.mrms_tbl_agent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_agent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_agent_info_cl(
            agent_id -- 代理商编号
            ,agent_name -- 代理商名称
            ,agent_short_name -- 简称
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
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,mcht_feerate_type -- 旗下商户打款成本收费方式
            ,mcht_feerate -- 旗下商户打款成本收费值
            ,profit_type -- 分润收费方式
            ,profit_rate -- 分润收费值
            ,sett_type -- 结算方式
            ,sett_cycle -- 结算周期
            ,agent_status -- 代理商状态
            ,is_examine -- 旗下商户是否需要业务审核
            ,sett_mode -- 清算模式 1：银行二清，2：台账模式
            ,agent_key -- 秘钥
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,wailian_code -- 
            ,gateway -- 
            ,pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
            ,reserved -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_agent_info_op(
            agent_id -- 代理商编号
            ,agent_name -- 代理商名称
            ,agent_short_name -- 简称
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
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,mcht_feerate_type -- 旗下商户打款成本收费方式
            ,mcht_feerate -- 旗下商户打款成本收费值
            ,profit_type -- 分润收费方式
            ,profit_rate -- 分润收费值
            ,sett_type -- 结算方式
            ,sett_cycle -- 结算周期
            ,agent_status -- 代理商状态
            ,is_examine -- 旗下商户是否需要业务审核
            ,sett_mode -- 清算模式 1：银行二清，2：台账模式
            ,agent_key -- 秘钥
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,wailian_code -- 
            ,gateway -- 
            ,pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
            ,reserved -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agent_id, o.agent_id) as agent_id -- 代理商编号
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代理商名称
    ,nvl(n.agent_short_name, o.agent_short_name) as agent_short_name -- 简称
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
    ,nvl(n.comm_tel, o.comm_tel) as comm_tel -- 联系人电话
    ,nvl(n.post_code, o.post_code) as post_code -- 邮编
    ,nvl(n.comm_addr, o.comm_addr) as comm_addr -- 联系地址
    ,nvl(n.sett_account, o.sett_account) as sett_account -- 结算账户
    ,nvl(n.sett_account_name, o.sett_account_name) as sett_account_name -- 结算账户名
    ,nvl(n.sett_account_type, o.sett_account_type) as sett_account_type -- 结算账户类型
    ,nvl(n.acct_chnl, o.acct_chnl) as acct_chnl -- 入账渠道
    ,nvl(n.open_bank, o.open_bank) as open_bank -- 开户行行号
    ,nvl(n.open_bankname, o.open_bankname) as open_bankname -- 开户行行名
    ,nvl(n.mcht_feerate_type, o.mcht_feerate_type) as mcht_feerate_type -- 旗下商户打款成本收费方式
    ,nvl(n.mcht_feerate, o.mcht_feerate) as mcht_feerate -- 旗下商户打款成本收费值
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 分润收费方式
    ,nvl(n.profit_rate, o.profit_rate) as profit_rate -- 分润收费值
    ,nvl(n.sett_type, o.sett_type) as sett_type -- 结算方式
    ,nvl(n.sett_cycle, o.sett_cycle) as sett_cycle -- 结算周期
    ,nvl(n.agent_status, o.agent_status) as agent_status -- 代理商状态
    ,nvl(n.is_examine, o.is_examine) as is_examine -- 旗下商户是否需要业务审核
    ,nvl(n.sett_mode, o.sett_mode) as sett_mode -- 清算模式 1：银行二清，2：台账模式
    ,nvl(n.agent_key, o.agent_key) as agent_key -- 秘钥
    ,nvl(n.create_date, o.create_date) as create_date -- 新增日期
    ,nvl(n.modfiy_date, o.modfiy_date) as modfiy_date -- 最后修改日期
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 操作员
    ,nvl(n.wailian_code, o.wailian_code) as wailian_code -- 
    ,nvl(n.gateway, o.gateway) as gateway -- 
    ,nvl(n.pay_channel, o.pay_channel) as pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
    ,nvl(n.reserved, o.reserved) as reserved -- 
    ,case when
            n.agent_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agent_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agent_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_agent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_agent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agent_id = n.agent_id
where (
        o.agent_id is null
    )
    or (
        n.agent_id is null
    )
    or (
        o.agent_name <> n.agent_name
        or o.agent_short_name <> n.agent_short_name
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
        or o.comm_tel <> n.comm_tel
        or o.post_code <> n.post_code
        or o.comm_addr <> n.comm_addr
        or o.sett_account <> n.sett_account
        or o.sett_account_name <> n.sett_account_name
        or o.sett_account_type <> n.sett_account_type
        or o.acct_chnl <> n.acct_chnl
        or o.open_bank <> n.open_bank
        or o.open_bankname <> n.open_bankname
        or o.mcht_feerate_type <> n.mcht_feerate_type
        or o.mcht_feerate <> n.mcht_feerate
        or o.profit_type <> n.profit_type
        or o.profit_rate <> n.profit_rate
        or o.sett_type <> n.sett_type
        or o.sett_cycle <> n.sett_cycle
        or o.agent_status <> n.agent_status
        or o.is_examine <> n.is_examine
        or o.sett_mode <> n.sett_mode
        or o.agent_key <> n.agent_key
        or o.create_date <> n.create_date
        or o.modfiy_date <> n.modfiy_date
        or o.opr_id <> n.opr_id
        or o.wailian_code <> n.wailian_code
        or o.gateway <> n.gateway
        or o.pay_channel <> n.pay_channel
        or o.reserved <> n.reserved
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_agent_info_cl(
            agent_id -- 代理商编号
            ,agent_name -- 代理商名称
            ,agent_short_name -- 简称
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
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,mcht_feerate_type -- 旗下商户打款成本收费方式
            ,mcht_feerate -- 旗下商户打款成本收费值
            ,profit_type -- 分润收费方式
            ,profit_rate -- 分润收费值
            ,sett_type -- 结算方式
            ,sett_cycle -- 结算周期
            ,agent_status -- 代理商状态
            ,is_examine -- 旗下商户是否需要业务审核
            ,sett_mode -- 清算模式 1：银行二清，2：台账模式
            ,agent_key -- 秘钥
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,wailian_code -- 
            ,gateway -- 
            ,pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
            ,reserved -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_agent_info_op(
            agent_id -- 代理商编号
            ,agent_name -- 代理商名称
            ,agent_short_name -- 简称
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
            ,comm_tel -- 联系人电话
            ,post_code -- 邮编
            ,comm_addr -- 联系地址
            ,sett_account -- 结算账户
            ,sett_account_name -- 结算账户名
            ,sett_account_type -- 结算账户类型
            ,acct_chnl -- 入账渠道
            ,open_bank -- 开户行行号
            ,open_bankname -- 开户行行名
            ,mcht_feerate_type -- 旗下商户打款成本收费方式
            ,mcht_feerate -- 旗下商户打款成本收费值
            ,profit_type -- 分润收费方式
            ,profit_rate -- 分润收费值
            ,sett_type -- 结算方式
            ,sett_cycle -- 结算周期
            ,agent_status -- 代理商状态
            ,is_examine -- 旗下商户是否需要业务审核
            ,sett_mode -- 清算模式 1：银行二清，2：台账模式
            ,agent_key -- 秘钥
            ,create_date -- 新增日期
            ,modfiy_date -- 最后修改日期
            ,opr_id -- 操作员
            ,wailian_code -- 
            ,gateway -- 
            ,pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
            ,reserved -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agent_id -- 代理商编号
    ,o.agent_name -- 代理商名称
    ,o.agent_short_name -- 简称
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
    ,o.comm_tel -- 联系人电话
    ,o.post_code -- 邮编
    ,o.comm_addr -- 联系地址
    ,o.sett_account -- 结算账户
    ,o.sett_account_name -- 结算账户名
    ,o.sett_account_type -- 结算账户类型
    ,o.acct_chnl -- 入账渠道
    ,o.open_bank -- 开户行行号
    ,o.open_bankname -- 开户行行名
    ,o.mcht_feerate_type -- 旗下商户打款成本收费方式
    ,o.mcht_feerate -- 旗下商户打款成本收费值
    ,o.profit_type -- 分润收费方式
    ,o.profit_rate -- 分润收费值
    ,o.sett_type -- 结算方式
    ,o.sett_cycle -- 结算周期
    ,o.agent_status -- 代理商状态
    ,o.is_examine -- 旗下商户是否需要业务审核
    ,o.sett_mode -- 清算模式 1：银行二清，2：台账模式
    ,o.agent_key -- 秘钥
    ,o.create_date -- 新增日期
    ,o.modfiy_date -- 最后修改日期
    ,o.opr_id -- 操作员
    ,o.wailian_code -- 
    ,o.gateway -- 
    ,o.pay_channel -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
    ,o.reserved -- 
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
from ${iol_schema}.mrms_tbl_agent_info_bk o
    left join ${iol_schema}.mrms_tbl_agent_info_op n
        on
            o.agent_id = n.agent_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_agent_info_cl d
        on
            o.agent_id = d.agent_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_agent_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_agent_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_agent_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_agent_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_agent_info exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_agent_info_cl;
alter table ${iol_schema}.mrms_tbl_agent_info exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_agent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_agent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_agent_info_op purge;
drop table ${iol_schema}.mrms_tbl_agent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_agent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_agent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
