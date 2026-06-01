/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_u_contract
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
create table ${iol_schema}.ppps_u_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_u_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_u_contract_op purge;
drop table ${iol_schema}.ppps_u_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_u_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_u_contract where 0=1;

create table ${iol_schema}.ppps_u_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_u_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_u_contract_cl(
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_u_contract_op(
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sgn_no, o.sgn_no) as sgn_no -- 签约协议号
    ,nvl(n.issr_id, o.issr_id) as issr_id -- 发起方所属机构编号
    ,nvl(n.sgn_date, o.sgn_date) as sgn_date -- 签约日期:YYYYMMDD
    ,nvl(n.sgn_time, o.sgn_time) as sgn_time -- 签约时间:HHMMSS
    ,nvl(n.sgn_status, o.sgn_status) as sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,nvl(n.rcver_acct_issr_id, o.rcver_acct_issr_id) as rcver_acct_issr_id -- 签约人银行账户所属机构标识
    ,nvl(n.sgn_acct_tp, o.sgn_acct_tp) as sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
    ,nvl(n.rcver_acct_id, o.rcver_acct_id) as rcver_acct_id -- 签约账号
    ,nvl(n.rcver_nm, o.rcver_nm) as rcver_nm -- 签约账户户名
    ,nvl(n.acct_lvl, o.acct_lvl) as acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,nvl(n.id_tp, o.id_tp) as id_tp -- 证件类型
    ,nvl(n.id_no, o.id_no) as id_no -- 证件号码
    ,nvl(n.mob_no, o.mob_no) as mob_no -- 手机号
    ,nvl(n.sder_acct_issr_id, o.sder_acct_issr_id) as sder_acct_issr_id -- 支付账户所属机构标识
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 协议失效日期
    ,nvl(n.insert_time, o.insert_time) as insert_time -- 入库时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.enabled_state, o.enabled_state) as enabled_state -- ACTIVE
    ,nvl(n.sder_issr_id, o.sder_issr_id) as sder_issr_id -- 签约发起机构标识
    ,nvl(n.biz_tp, o.biz_tp) as biz_tp -- 原签约的业务bizTp
    ,nvl(n.sgn_typ, o.sgn_typ) as sgn_typ -- 类型
    ,nvl(n.sder_acct_id, o.sder_acct_id) as sder_acct_id -- 发起方账户号
    ,nvl(n.sder_acct_issr_nm, o.sder_acct_issr_nm) as sder_acct_issr_nm -- 发起机构名称
    ,nvl(n.open_org_id, o.open_org_id) as open_org_id -- 开户机构编号
    ,nvl(n.global_seq_no, o.global_seq_no) as global_seq_no -- 全局流水号
    ,nvl(n.tran_teller_no, o.tran_teller_no) as tran_teller_no -- 发起柜员
    ,nvl(n.tran_seq_no, o.tran_seq_no) as tran_seq_no -- 业务流水
    ,nvl(n.trx_id, o.trx_id) as trx_id -- 交易流水
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户号
    ,case when
            n.sgn_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sgn_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sgn_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_u_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_u_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sgn_no = n.sgn_no
where (
        o.sgn_no is null
    )
    or (
        n.sgn_no is null
    )
    or (
        o.issr_id <> n.issr_id
        or o.sgn_date <> n.sgn_date
        or o.sgn_time <> n.sgn_time
        or o.sgn_status <> n.sgn_status
        or o.rcver_acct_issr_id <> n.rcver_acct_issr_id
        or o.sgn_acct_tp <> n.sgn_acct_tp
        or o.rcver_acct_id <> n.rcver_acct_id
        or o.rcver_nm <> n.rcver_nm
        or o.acct_lvl <> n.acct_lvl
        or o.id_tp <> n.id_tp
        or o.id_no <> n.id_no
        or o.mob_no <> n.mob_no
        or o.sder_acct_issr_id <> n.sder_acct_issr_id
        or o.expire_date <> n.expire_date
        or o.insert_time <> n.insert_time
        or o.update_time <> n.update_time
        or o.enabled_state <> n.enabled_state
        or o.sder_issr_id <> n.sder_issr_id
        or o.biz_tp <> n.biz_tp
        or o.sgn_typ <> n.sgn_typ
        or o.sder_acct_id <> n.sder_acct_id
        or o.sder_acct_issr_nm <> n.sder_acct_issr_nm
        or o.open_org_id <> n.open_org_id
        or o.global_seq_no <> n.global_seq_no
        or o.tran_teller_no <> n.tran_teller_no
        or o.tran_seq_no <> n.tran_seq_no
        or o.trx_id <> n.trx_id
        or o.pty_id <> n.pty_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_u_contract_cl(
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_u_contract_op(
            sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:YYYYMMDD
            ,sgn_time -- 签约时间:HHMMSS
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,rcver_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
            ,rcver_acct_id -- 签约账号
            ,rcver_nm -- 签约账户户名
            ,acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no -- 证件号码
            ,mob_no -- 手机号
            ,sder_acct_issr_id -- 支付账户所属机构标识
            ,expire_date -- 协议失效日期
            ,insert_time -- 入库时间
            ,update_time -- 更新时间
            ,enabled_state -- ACTIVE
            ,sder_issr_id -- 签约发起机构标识
            ,biz_tp -- 原签约的业务bizTp
            ,sgn_typ -- 类型
            ,sder_acct_id -- 发起方账户号
            ,sder_acct_issr_nm -- 发起机构名称
            ,open_org_id -- 开户机构编号
            ,global_seq_no -- 全局流水号
            ,tran_teller_no -- 发起柜员
            ,tran_seq_no -- 业务流水
            ,trx_id -- 交易流水
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sgn_no -- 签约协议号
    ,o.issr_id -- 发起方所属机构编号
    ,o.sgn_date -- 签约日期:YYYYMMDD
    ,o.sgn_time -- 签约时间:HHMMSS
    ,o.sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,o.rcver_acct_issr_id -- 签约人银行账户所属机构标识
    ,o.sgn_acct_tp -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
    ,o.rcver_acct_id -- 签约账号
    ,o.rcver_nm -- 签约账户户名
    ,o.acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,o.id_tp -- 证件类型
    ,o.id_no -- 证件号码
    ,o.mob_no -- 手机号
    ,o.sder_acct_issr_id -- 支付账户所属机构标识
    ,o.expire_date -- 协议失效日期
    ,o.insert_time -- 入库时间
    ,o.update_time -- 更新时间
    ,o.enabled_state -- ACTIVE
    ,o.sder_issr_id -- 签约发起机构标识
    ,o.biz_tp -- 原签约的业务bizTp
    ,o.sgn_typ -- 类型
    ,o.sder_acct_id -- 发起方账户号
    ,o.sder_acct_issr_nm -- 发起机构名称
    ,o.open_org_id -- 开户机构编号
    ,o.global_seq_no -- 全局流水号
    ,o.tran_teller_no -- 发起柜员
    ,o.tran_seq_no -- 业务流水
    ,o.trx_id -- 交易流水
    ,o.pty_id -- 客户号
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
from ${iol_schema}.ppps_u_contract_bk o
    left join ${iol_schema}.ppps_u_contract_op n
        on
            o.sgn_no = n.sgn_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_u_contract_cl d
        on
            o.sgn_no = d.sgn_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_u_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_u_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_u_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_u_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_u_contract exchange partition p_${batch_date} with table ${iol_schema}.ppps_u_contract_cl;
alter table ${iol_schema}.ppps_u_contract exchange partition p_20991231 with table ${iol_schema}.ppps_u_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_u_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_u_contract_op purge;
drop table ${iol_schema}.ppps_u_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_u_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_u_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
