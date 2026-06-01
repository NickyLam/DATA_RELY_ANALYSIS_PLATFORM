/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_contract
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
create table ${iol_schema}.ppps_e_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_e_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_contract_op purge;
drop table ${iol_schema}.ppps_e_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_e_contract where 0=1;

create table ${iol_schema}.ppps_e_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_e_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_contract_cl(
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_contract_op(
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.sgn_no, o.sgn_no) as sgn_no -- 签约协议号
    ,nvl(n.issr_id, o.issr_id) as issr_id -- 发起方所属机构编号
    ,nvl(n.sgn_date, o.sgn_date) as sgn_date -- 签约日期:yyyyMMdd
    ,nvl(n.sgn_time, o.sgn_time) as sgn_time -- 签约时间:HHmmss
    ,nvl(n.sgn_status, o.sgn_status) as sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,nvl(n.sgn_acct_issr_id, o.sgn_acct_issr_id) as sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,nvl(n.sgn_acct_tp, o.sgn_acct_tp) as sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
    ,nvl(n.sgn_acct_id_de, o.sgn_acct_id_de) as sgn_acct_id_de -- 签约账号
    ,nvl(n.sgn_acct_nm_de, o.sgn_acct_nm_de) as sgn_acct_nm_de -- 签约账户户名
    ,nvl(n.sgn_acct_lvl, o.sgn_acct_lvl) as sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,nvl(n.id_tp, o.id_tp) as id_tp -- 证件类型
    ,nvl(n.id_no_de, o.id_no_de) as id_no_de -- 证件号码
    ,nvl(n.mob_no_de, o.mob_no_de) as mob_no_de -- 手机号
    ,nvl(n.instg_id, o.instg_id) as instg_id -- 支付账户所属机构标识
    ,nvl(n.instg_acct_de, o.instg_acct_de) as instg_acct_de -- 签约人支付账号
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 协议失效日期
    ,nvl(n.insert_time, o.insert_time) as insert_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注信息
    ,nvl(n.enabled_state, o.enabled_state) as enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
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
from (select * from ${iol_schema}.ppps_e_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_e_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sgn_no = n.sgn_no
where (
        o.sgn_no is null
    )
    or (
        n.sgn_no is null
    )
    or (
        o.id <> n.id
        or o.issr_id <> n.issr_id
        or o.sgn_date <> n.sgn_date
        or o.sgn_time <> n.sgn_time
        or o.sgn_status <> n.sgn_status
        or o.sgn_acct_issr_id <> n.sgn_acct_issr_id
        or o.sgn_acct_tp <> n.sgn_acct_tp
        or o.sgn_acct_id_de <> n.sgn_acct_id_de
        or o.sgn_acct_nm_de <> n.sgn_acct_nm_de
        or o.sgn_acct_lvl <> n.sgn_acct_lvl
        or o.id_tp <> n.id_tp
        or o.id_no_de <> n.id_no_de
        or o.mob_no_de <> n.mob_no_de
        or o.instg_id <> n.instg_id
        or o.instg_acct_de <> n.instg_acct_de
        or o.expire_date <> n.expire_date
        or o.insert_time <> n.insert_time
        or o.update_time <> n.update_time
        or o.remark <> n.remark
        or o.enabled_state <> n.enabled_state
        or o.pty_id <> n.pty_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_contract_cl(
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_contract_op(
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.sgn_no -- 签约协议号
    ,o.issr_id -- 发起方所属机构编号
    ,o.sgn_date -- 签约日期:yyyyMMdd
    ,o.sgn_time -- 签约时间:HHmmss
    ,o.sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,o.sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,o.sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
    ,o.sgn_acct_id_de -- 签约账号
    ,o.sgn_acct_nm_de -- 签约账户户名
    ,o.sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,o.id_tp -- 证件类型
    ,o.id_no_de -- 证件号码
    ,o.mob_no_de -- 手机号
    ,o.instg_id -- 支付账户所属机构标识
    ,o.instg_acct_de -- 签约人支付账号
    ,o.expire_date -- 协议失效日期
    ,o.insert_time -- 创建时间
    ,o.update_time -- 最后更新时间
    ,o.remark -- 备注信息
    ,o.enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
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
from ${iol_schema}.ppps_e_contract_bk o
    left join ${iol_schema}.ppps_e_contract_op n
        on
            o.sgn_no = n.sgn_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_e_contract_cl d
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
--truncate table ${iol_schema}.ppps_e_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_e_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_e_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_e_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_e_contract exchange partition p_${batch_date} with table ${iol_schema}.ppps_e_contract_cl;
alter table ${iol_schema}.ppps_e_contract exchange partition p_20991231 with table ${iol_schema}.ppps_e_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_e_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_contract_op purge;
drop table ${iol_schema}.ppps_e_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_e_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_e_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
