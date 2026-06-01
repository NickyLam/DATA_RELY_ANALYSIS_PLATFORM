/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_txn_sign
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
create table ${iol_schema}.ppps_e_txn_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_e_txn_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_txn_sign_op purge;
drop table ${iol_schema}.ppps_e_txn_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_txn_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_e_txn_sign where 0=1;

create table ${iol_schema}.ppps_e_txn_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_e_txn_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_txn_sign_cl(
            id -- 自增主键
            ,trx_id -- 交易流水号
            ,issr_id -- 发起方所属机构编号
            ,trx_dt_tm -- 交易ISO日期时间
            ,trx_ctgy -- 交易类别
            ,txn_date -- 平台交易日期
            ,txn_time -- 平台交易时间
            ,status -- 流水状态
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账户编号
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约人账户类型
            ,sgn_acct_id_de -- 签约人银行账户号码
            ,sgn_acct_nm_de -- 签约人银行账户名称
            ,id_tp -- 签约人证件类型
            ,id_no_de -- 签约人证件号码
            ,mob_no_de -- 签约人预留手机号
            ,sgn_acct_lvl -- 签约人银行账户等级
            ,sms_seq_no -- 验证序列号
            ,sms_index -- 验证码索引
            ,cust_no -- 客户号
            ,biz_sts_cd -- 业务返回码
            ,biz_sts_desc -- 业务返回说明
            ,sys_rtn_cd -- 系统返回码
            ,sys_rtn_desc -- 系统返回说明
            ,sys_rtn_tm -- 系统返回时间
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,global_no -- 全局流水号
            ,mcht_no -- 渠道编号
            ,lgn_id -- 受理机构登录账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_txn_sign_op(
            id -- 自增主键
            ,trx_id -- 交易流水号
            ,issr_id -- 发起方所属机构编号
            ,trx_dt_tm -- 交易ISO日期时间
            ,trx_ctgy -- 交易类别
            ,txn_date -- 平台交易日期
            ,txn_time -- 平台交易时间
            ,status -- 流水状态
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账户编号
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约人账户类型
            ,sgn_acct_id_de -- 签约人银行账户号码
            ,sgn_acct_nm_de -- 签约人银行账户名称
            ,id_tp -- 签约人证件类型
            ,id_no_de -- 签约人证件号码
            ,mob_no_de -- 签约人预留手机号
            ,sgn_acct_lvl -- 签约人银行账户等级
            ,sms_seq_no -- 验证序列号
            ,sms_index -- 验证码索引
            ,cust_no -- 客户号
            ,biz_sts_cd -- 业务返回码
            ,biz_sts_desc -- 业务返回说明
            ,sys_rtn_cd -- 系统返回码
            ,sys_rtn_desc -- 系统返回说明
            ,sys_rtn_tm -- 系统返回时间
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,global_no -- 全局流水号
            ,mcht_no -- 渠道编号
            ,lgn_id -- 受理机构登录账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.trx_id, o.trx_id) as trx_id -- 交易流水号
    ,nvl(n.issr_id, o.issr_id) as issr_id -- 发起方所属机构编号
    ,nvl(n.trx_dt_tm, o.trx_dt_tm) as trx_dt_tm -- 交易ISO日期时间
    ,nvl(n.trx_ctgy, o.trx_ctgy) as trx_ctgy -- 交易类别
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 平台交易日期
    ,nvl(n.txn_time, o.txn_time) as txn_time -- 平台交易时间
    ,nvl(n.status, o.status) as status -- 流水状态
    ,nvl(n.instg_id, o.instg_id) as instg_id -- 支付账户所属机构标识
    ,nvl(n.instg_acct_de, o.instg_acct_de) as instg_acct_de -- 签约人支付账户编号
    ,nvl(n.sgn_acct_issr_id, o.sgn_acct_issr_id) as sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,nvl(n.sgn_acct_tp, o.sgn_acct_tp) as sgn_acct_tp -- 签约人账户类型
    ,nvl(n.sgn_acct_id_de, o.sgn_acct_id_de) as sgn_acct_id_de -- 签约人银行账户号码
    ,nvl(n.sgn_acct_nm_de, o.sgn_acct_nm_de) as sgn_acct_nm_de -- 签约人银行账户名称
    ,nvl(n.id_tp, o.id_tp) as id_tp -- 签约人证件类型
    ,nvl(n.id_no_de, o.id_no_de) as id_no_de -- 签约人证件号码
    ,nvl(n.mob_no_de, o.mob_no_de) as mob_no_de -- 签约人预留手机号
    ,nvl(n.sgn_acct_lvl, o.sgn_acct_lvl) as sgn_acct_lvl -- 签约人银行账户等级
    ,nvl(n.sms_seq_no, o.sms_seq_no) as sms_seq_no -- 验证序列号
    ,nvl(n.sms_index, o.sms_index) as sms_index -- 验证码索引
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.biz_sts_cd, o.biz_sts_cd) as biz_sts_cd -- 业务返回码
    ,nvl(n.biz_sts_desc, o.biz_sts_desc) as biz_sts_desc -- 业务返回说明
    ,nvl(n.sys_rtn_cd, o.sys_rtn_cd) as sys_rtn_cd -- 系统返回码
    ,nvl(n.sys_rtn_desc, o.sys_rtn_desc) as sys_rtn_desc -- 系统返回说明
    ,nvl(n.sys_rtn_tm, o.sys_rtn_tm) as sys_rtn_tm -- 系统返回时间
    ,nvl(n.insert_time, o.insert_time) as insert_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注信息
    ,nvl(n.global_no, o.global_no) as global_no -- 全局流水号
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 渠道编号
    ,nvl(n.lgn_id, o.lgn_id) as lgn_id -- 受理机构登录账号
    ,case when
            n.trx_id is null
            and n.trx_ctgy is null
            and n.instg_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trx_id is null
            and n.trx_ctgy is null
            and n.instg_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trx_id is null
            and n.trx_ctgy is null
            and n.instg_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_e_txn_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_e_txn_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trx_id = n.trx_id
            and o.trx_ctgy = n.trx_ctgy
            and o.instg_id = n.instg_id
where (
        o.trx_id is null
        and o.trx_ctgy is null
        and o.instg_id is null
    )
    or (
        n.trx_id is null
        and n.trx_ctgy is null
        and n.instg_id is null
    )
    or (
        o.id <> n.id
        or o.issr_id <> n.issr_id
        or o.trx_dt_tm <> n.trx_dt_tm
        or o.txn_date <> n.txn_date
        or o.txn_time <> n.txn_time
        or o.status <> n.status
        or o.instg_acct_de <> n.instg_acct_de
        or o.sgn_acct_issr_id <> n.sgn_acct_issr_id
        or o.sgn_acct_tp <> n.sgn_acct_tp
        or o.sgn_acct_id_de <> n.sgn_acct_id_de
        or o.sgn_acct_nm_de <> n.sgn_acct_nm_de
        or o.id_tp <> n.id_tp
        or o.id_no_de <> n.id_no_de
        or o.mob_no_de <> n.mob_no_de
        or o.sgn_acct_lvl <> n.sgn_acct_lvl
        or o.sms_seq_no <> n.sms_seq_no
        or o.sms_index <> n.sms_index
        or o.cust_no <> n.cust_no
        or o.biz_sts_cd <> n.biz_sts_cd
        or o.biz_sts_desc <> n.biz_sts_desc
        or o.sys_rtn_cd <> n.sys_rtn_cd
        or o.sys_rtn_desc <> n.sys_rtn_desc
        or o.sys_rtn_tm <> n.sys_rtn_tm
        or o.insert_time <> n.insert_time
        or o.update_time <> n.update_time
        or o.remark <> n.remark
        or o.global_no <> n.global_no
        or o.mcht_no <> n.mcht_no
        or o.lgn_id <> n.lgn_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_txn_sign_cl(
            id -- 自增主键
            ,trx_id -- 交易流水号
            ,issr_id -- 发起方所属机构编号
            ,trx_dt_tm -- 交易ISO日期时间
            ,trx_ctgy -- 交易类别
            ,txn_date -- 平台交易日期
            ,txn_time -- 平台交易时间
            ,status -- 流水状态
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账户编号
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约人账户类型
            ,sgn_acct_id_de -- 签约人银行账户号码
            ,sgn_acct_nm_de -- 签约人银行账户名称
            ,id_tp -- 签约人证件类型
            ,id_no_de -- 签约人证件号码
            ,mob_no_de -- 签约人预留手机号
            ,sgn_acct_lvl -- 签约人银行账户等级
            ,sms_seq_no -- 验证序列号
            ,sms_index -- 验证码索引
            ,cust_no -- 客户号
            ,biz_sts_cd -- 业务返回码
            ,biz_sts_desc -- 业务返回说明
            ,sys_rtn_cd -- 系统返回码
            ,sys_rtn_desc -- 系统返回说明
            ,sys_rtn_tm -- 系统返回时间
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,global_no -- 全局流水号
            ,mcht_no -- 渠道编号
            ,lgn_id -- 受理机构登录账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_txn_sign_op(
            id -- 自增主键
            ,trx_id -- 交易流水号
            ,issr_id -- 发起方所属机构编号
            ,trx_dt_tm -- 交易ISO日期时间
            ,trx_ctgy -- 交易类别
            ,txn_date -- 平台交易日期
            ,txn_time -- 平台交易时间
            ,status -- 流水状态
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账户编号
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约人账户类型
            ,sgn_acct_id_de -- 签约人银行账户号码
            ,sgn_acct_nm_de -- 签约人银行账户名称
            ,id_tp -- 签约人证件类型
            ,id_no_de -- 签约人证件号码
            ,mob_no_de -- 签约人预留手机号
            ,sgn_acct_lvl -- 签约人银行账户等级
            ,sms_seq_no -- 验证序列号
            ,sms_index -- 验证码索引
            ,cust_no -- 客户号
            ,biz_sts_cd -- 业务返回码
            ,biz_sts_desc -- 业务返回说明
            ,sys_rtn_cd -- 系统返回码
            ,sys_rtn_desc -- 系统返回说明
            ,sys_rtn_tm -- 系统返回时间
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,global_no -- 全局流水号
            ,mcht_no -- 渠道编号
            ,lgn_id -- 受理机构登录账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.trx_id -- 交易流水号
    ,o.issr_id -- 发起方所属机构编号
    ,o.trx_dt_tm -- 交易ISO日期时间
    ,o.trx_ctgy -- 交易类别
    ,o.txn_date -- 平台交易日期
    ,o.txn_time -- 平台交易时间
    ,o.status -- 流水状态
    ,o.instg_id -- 支付账户所属机构标识
    ,o.instg_acct_de -- 签约人支付账户编号
    ,o.sgn_acct_issr_id -- 签约人银行账户所属机构标识
    ,o.sgn_acct_tp -- 签约人账户类型
    ,o.sgn_acct_id_de -- 签约人银行账户号码
    ,o.sgn_acct_nm_de -- 签约人银行账户名称
    ,o.id_tp -- 签约人证件类型
    ,o.id_no_de -- 签约人证件号码
    ,o.mob_no_de -- 签约人预留手机号
    ,o.sgn_acct_lvl -- 签约人银行账户等级
    ,o.sms_seq_no -- 验证序列号
    ,o.sms_index -- 验证码索引
    ,o.cust_no -- 客户号
    ,o.biz_sts_cd -- 业务返回码
    ,o.biz_sts_desc -- 业务返回说明
    ,o.sys_rtn_cd -- 系统返回码
    ,o.sys_rtn_desc -- 系统返回说明
    ,o.sys_rtn_tm -- 系统返回时间
    ,o.insert_time -- 创建时间
    ,o.update_time -- 最后更新时间
    ,o.remark -- 备注信息
    ,o.global_no -- 全局流水号
    ,o.mcht_no -- 渠道编号
    ,o.lgn_id -- 受理机构登录账号
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
from ${iol_schema}.ppps_e_txn_sign_bk o
    left join ${iol_schema}.ppps_e_txn_sign_op n
        on
            o.trx_id = n.trx_id
            and o.trx_ctgy = n.trx_ctgy
            and o.instg_id = n.instg_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_e_txn_sign_cl d
        on
            o.trx_id = d.trx_id
            and o.trx_ctgy = d.trx_ctgy
            and o.instg_id = d.instg_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_e_txn_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_e_txn_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_e_txn_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_e_txn_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_e_txn_sign exchange partition p_${batch_date} with table ${iol_schema}.ppps_e_txn_sign_cl;
alter table ${iol_schema}.ppps_e_txn_sign exchange partition p_20991231 with table ${iol_schema}.ppps_e_txn_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_e_txn_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_txn_sign_op purge;
drop table ${iol_schema}.ppps_e_txn_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_e_txn_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_e_txn_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
