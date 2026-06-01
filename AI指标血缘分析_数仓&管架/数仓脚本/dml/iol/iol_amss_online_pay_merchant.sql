/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_online_pay_merchant
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
create table ${iol_schema}.amss_online_pay_merchant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_online_pay_merchant
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_online_pay_merchant_op purge;
drop table ${iol_schema}.amss_online_pay_merchant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_online_pay_merchant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_online_pay_merchant where 0=1;

create table ${iol_schema}.amss_online_pay_merchant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_online_pay_merchant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_online_pay_merchant_cl(
            sign_num -- 协议编号,主键
            ,mgmt_platf_chn -- 管理平台渠道号
            ,sign_status -- 签约状态，1-签约，默认1
            ,lnkm_name -- 联系人
            ,lnkm_ceph_num -- 联系人电话
            ,acct_num -- 归集账号
            ,acct_name -- 归集账号名
            ,fund_lmt -- 代付额度
            ,sign_rcv_acct -- 签约付款账户
            ,sign_rcv_acct_name -- 签约账户名称
            ,sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
            ,sign_time -- 签约时间
            ,update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
            ,org_id -- 所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_online_pay_merchant_op(
            sign_num -- 协议编号,主键
            ,mgmt_platf_chn -- 管理平台渠道号
            ,sign_status -- 签约状态，1-签约，默认1
            ,lnkm_name -- 联系人
            ,lnkm_ceph_num -- 联系人电话
            ,acct_num -- 归集账号
            ,acct_name -- 归集账号名
            ,fund_lmt -- 代付额度
            ,sign_rcv_acct -- 签约付款账户
            ,sign_rcv_acct_name -- 签约账户名称
            ,sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
            ,sign_time -- 签约时间
            ,update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
            ,org_id -- 所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_num, o.sign_num) as sign_num -- 协议编号,主键
    ,nvl(n.mgmt_platf_chn, o.mgmt_platf_chn) as mgmt_platf_chn -- 管理平台渠道号
    ,nvl(n.sign_status, o.sign_status) as sign_status -- 签约状态，1-签约，默认1
    ,nvl(n.lnkm_name, o.lnkm_name) as lnkm_name -- 联系人
    ,nvl(n.lnkm_ceph_num, o.lnkm_ceph_num) as lnkm_ceph_num -- 联系人电话
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 归集账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 归集账号名
    ,nvl(n.fund_lmt, o.fund_lmt) as fund_lmt -- 代付额度
    ,nvl(n.sign_rcv_acct, o.sign_rcv_acct) as sign_rcv_acct -- 签约付款账户
    ,nvl(n.sign_rcv_acct_name, o.sign_rcv_acct_name) as sign_rcv_acct_name -- 签约账户名称
    ,nvl(n.sign_rcv_acct_typ, o.sign_rcv_acct_typ) as sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人id
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新者id
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新者
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识，默认1正常，2删除
    ,nvl(n.merch_examine_status, o.merch_examine_status) as merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
    ,nvl(n.sign_time, o.sign_time) as sign_time -- 签约时间
    ,nvl(n.update_field, o.update_field) as update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
    ,nvl(n.org_id, o.org_id) as org_id -- 所属分行
    ,case when
            n.sign_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_online_pay_merchant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_online_pay_merchant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_num = n.sign_num
where (
        o.sign_num is null
    )
    or (
        n.sign_num is null
    )
    or (
        o.mgmt_platf_chn <> n.mgmt_platf_chn
        or o.sign_status <> n.sign_status
        or o.lnkm_name <> n.lnkm_name
        or o.lnkm_ceph_num <> n.lnkm_ceph_num
        or o.acct_num <> n.acct_num
        or o.acct_name <> n.acct_name
        or o.fund_lmt <> n.fund_lmt
        or o.sign_rcv_acct <> n.sign_rcv_acct
        or o.sign_rcv_acct_name <> n.sign_rcv_acct_name
        or o.sign_rcv_acct_typ <> n.sign_rcv_acct_typ
        or o.create_time <> n.create_time
        or o.create_emp <> n.create_emp
        or o.create_user <> n.create_user
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.update_emp <> n.update_emp
        or o.physics_flag <> n.physics_flag
        or o.merch_examine_status <> n.merch_examine_status
        or o.sign_time <> n.sign_time
        or o.update_field <> n.update_field
        or o.org_id <> n.org_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_online_pay_merchant_cl(
            sign_num -- 协议编号,主键
            ,mgmt_platf_chn -- 管理平台渠道号
            ,sign_status -- 签约状态，1-签约，默认1
            ,lnkm_name -- 联系人
            ,lnkm_ceph_num -- 联系人电话
            ,acct_num -- 归集账号
            ,acct_name -- 归集账号名
            ,fund_lmt -- 代付额度
            ,sign_rcv_acct -- 签约付款账户
            ,sign_rcv_acct_name -- 签约账户名称
            ,sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
            ,sign_time -- 签约时间
            ,update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
            ,org_id -- 所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_online_pay_merchant_op(
            sign_num -- 协议编号,主键
            ,mgmt_platf_chn -- 管理平台渠道号
            ,sign_status -- 签约状态，1-签约，默认1
            ,lnkm_name -- 联系人
            ,lnkm_ceph_num -- 联系人电话
            ,acct_num -- 归集账号
            ,acct_name -- 归集账号名
            ,fund_lmt -- 代付额度
            ,sign_rcv_acct -- 签约付款账户
            ,sign_rcv_acct_name -- 签约账户名称
            ,sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,create_user -- 创建人id
            ,update_time -- 更新时间
            ,update_user -- 更新者id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
            ,sign_time -- 签约时间
            ,update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
            ,org_id -- 所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_num -- 协议编号,主键
    ,o.mgmt_platf_chn -- 管理平台渠道号
    ,o.sign_status -- 签约状态，1-签约，默认1
    ,o.lnkm_name -- 联系人
    ,o.lnkm_ceph_num -- 联系人电话
    ,o.acct_num -- 归集账号
    ,o.acct_name -- 归集账号名
    ,o.fund_lmt -- 代付额度
    ,o.sign_rcv_acct -- 签约付款账户
    ,o.sign_rcv_acct_name -- 签约账户名称
    ,o.sign_rcv_acct_typ -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,o.create_time -- 创建时间
    ,o.create_emp -- 创建者
    ,o.create_user -- 创建人id
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新者id
    ,o.update_emp -- 更新者
    ,o.physics_flag -- 物理标识，默认1正常，2删除
    ,o.merch_examine_status -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
    ,o.sign_time -- 签约时间
    ,o.update_field -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
    ,o.org_id -- 所属分行
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
from ${iol_schema}.amss_online_pay_merchant_bk o
    left join ${iol_schema}.amss_online_pay_merchant_op n
        on
            o.sign_num = n.sign_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_online_pay_merchant_cl d
        on
            o.sign_num = d.sign_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_online_pay_merchant;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_online_pay_merchant') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_online_pay_merchant drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_online_pay_merchant add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_online_pay_merchant exchange partition p_${batch_date} with table ${iol_schema}.amss_online_pay_merchant_cl;
alter table ${iol_schema}.amss_online_pay_merchant exchange partition p_20991231 with table ${iol_schema}.amss_online_pay_merchant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_online_pay_merchant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_online_pay_merchant_op purge;
drop table ${iol_schema}.amss_online_pay_merchant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_online_pay_merchant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_online_pay_merchant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
