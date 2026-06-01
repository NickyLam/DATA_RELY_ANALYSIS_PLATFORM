/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_counterparty
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
create table ${iol_schema}.ctms_fbs_v_counterparty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_counterparty;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_counterparty_op purge;
drop table ${iol_schema}.ctms_fbs_v_counterparty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_counterparty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_counterparty where 0=1;

create table ${iol_schema}.ctms_fbs_v_counterparty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_counterparty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_counterparty_cl(
            counterparty_seq -- 交易对手编号
            ,cus_number -- 机构编号
            ,label -- 其他系统编号
            ,counterparty_cname -- 中文名称
            ,counterparty_ename -- 英文名称
            ,contact_name -- 联系人
            ,telephone -- 电话
            ,fax -- 传真
            ,update_user -- 更新用户
            ,update_time -- 更新时间
            ,is_issuer -- 是否为发行者
            ,is_bank -- 是否为银行
            ,is_guarantee -- 是否为保证人
            ,is_custody -- 是否为托管机构
            ,customer_type -- 行业类别
            ,parent -- 母公司
            ,rating_level -- 內部信用評級
            ,ex_code -- 联行号
            ,ex_account -- 人行大额支付系统号
            ,swift_code -- Swift 电文代号
            ,ref_issuer_id -- Issuer, or guarantee 会有该字段
            ,cfets_member_id -- 外汇编号或者第三方交易对手编号
            ,counterparty_short_cname -- 交易对手方中文简称
            ,counterparty_short_ename -- 交易对手方英文简称
            ,cfets_fx_member_id -- 外汇编号
            ,cfets_member_attr -- 外汇会员类型
            ,counterparty_fx_short_ename -- 外汇交易对手方英文简称
            ,interbanktype -- 交易对手同业类型
            ,overseas -- 境内境外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_counterparty_op(
            counterparty_seq -- 交易对手编号
            ,cus_number -- 机构编号
            ,label -- 其他系统编号
            ,counterparty_cname -- 中文名称
            ,counterparty_ename -- 英文名称
            ,contact_name -- 联系人
            ,telephone -- 电话
            ,fax -- 传真
            ,update_user -- 更新用户
            ,update_time -- 更新时间
            ,is_issuer -- 是否为发行者
            ,is_bank -- 是否为银行
            ,is_guarantee -- 是否为保证人
            ,is_custody -- 是否为托管机构
            ,customer_type -- 行业类别
            ,parent -- 母公司
            ,rating_level -- 內部信用評級
            ,ex_code -- 联行号
            ,ex_account -- 人行大额支付系统号
            ,swift_code -- Swift 电文代号
            ,ref_issuer_id -- Issuer, or guarantee 会有该字段
            ,cfets_member_id -- 外汇编号或者第三方交易对手编号
            ,counterparty_short_cname -- 交易对手方中文简称
            ,counterparty_short_ename -- 交易对手方英文简称
            ,cfets_fx_member_id -- 外汇编号
            ,cfets_member_attr -- 外汇会员类型
            ,counterparty_fx_short_ename -- 外汇交易对手方英文简称
            ,interbanktype -- 交易对手同业类型
            ,overseas -- 境内境外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- 交易对手编号
    ,nvl(n.cus_number, o.cus_number) as cus_number -- 机构编号
    ,nvl(n.label, o.label) as label -- 其他系统编号
    ,nvl(n.counterparty_cname, o.counterparty_cname) as counterparty_cname -- 中文名称
    ,nvl(n.counterparty_ename, o.counterparty_ename) as counterparty_ename -- 英文名称
    ,nvl(n.contact_name, o.contact_name) as contact_name -- 联系人
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.update_user, o.update_user) as update_user -- 更新用户
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.is_issuer, o.is_issuer) as is_issuer -- 是否为发行者
    ,nvl(n.is_bank, o.is_bank) as is_bank -- 是否为银行
    ,nvl(n.is_guarantee, o.is_guarantee) as is_guarantee -- 是否为保证人
    ,nvl(n.is_custody, o.is_custody) as is_custody -- 是否为托管机构
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 行业类别
    ,nvl(n.parent, o.parent) as parent -- 母公司
    ,nvl(n.rating_level, o.rating_level) as rating_level -- 內部信用評級
    ,nvl(n.ex_code, o.ex_code) as ex_code -- 联行号
    ,nvl(n.ex_account, o.ex_account) as ex_account -- 人行大额支付系统号
    ,nvl(n.swift_code, o.swift_code) as swift_code -- Swift 电文代号
    ,nvl(n.ref_issuer_id, o.ref_issuer_id) as ref_issuer_id -- Issuer, or guarantee 会有该字段
    ,nvl(n.cfets_member_id, o.cfets_member_id) as cfets_member_id -- 外汇编号或者第三方交易对手编号
    ,nvl(n.counterparty_short_cname, o.counterparty_short_cname) as counterparty_short_cname -- 交易对手方中文简称
    ,nvl(n.counterparty_short_ename, o.counterparty_short_ename) as counterparty_short_ename -- 交易对手方英文简称
    ,nvl(n.cfets_fx_member_id, o.cfets_fx_member_id) as cfets_fx_member_id -- 外汇编号
    ,nvl(n.cfets_member_attr, o.cfets_member_attr) as cfets_member_attr -- 外汇会员类型
    ,nvl(n.counterparty_fx_short_ename, o.counterparty_fx_short_ename) as counterparty_fx_short_ename -- 外汇交易对手方英文简称
    ,nvl(n.interbanktype, o.interbanktype) as interbanktype -- 交易对手同业类型
    ,nvl(n.overseas, o.overseas) as overseas -- 境内境外
    ,case when
            n.counterparty_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.counterparty_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.counterparty_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_counterparty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_counterparty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.counterparty_seq = n.counterparty_seq
where (
        o.counterparty_seq is null
    )
    or (
        n.counterparty_seq is null
    )
    or (
        o.cus_number <> n.cus_number
        or o.label <> n.label
        or o.counterparty_cname <> n.counterparty_cname
        or o.counterparty_ename <> n.counterparty_ename
        or o.contact_name <> n.contact_name
        or o.telephone <> n.telephone
        or o.fax <> n.fax
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.is_issuer <> n.is_issuer
        or o.is_bank <> n.is_bank
        or o.is_guarantee <> n.is_guarantee
        or o.is_custody <> n.is_custody
        or o.customer_type <> n.customer_type
        or o.parent <> n.parent
        or o.rating_level <> n.rating_level
        or o.ex_code <> n.ex_code
        or o.ex_account <> n.ex_account
        or o.swift_code <> n.swift_code
        or o.ref_issuer_id <> n.ref_issuer_id
        or o.cfets_member_id <> n.cfets_member_id
        or o.counterparty_short_cname <> n.counterparty_short_cname
        or o.counterparty_short_ename <> n.counterparty_short_ename
        or o.cfets_fx_member_id <> n.cfets_fx_member_id
        or o.cfets_member_attr <> n.cfets_member_attr
        or o.counterparty_fx_short_ename <> n.counterparty_fx_short_ename
        or o.interbanktype <> n.interbanktype
        or o.overseas <> n.overseas
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_counterparty_cl(
            counterparty_seq -- 交易对手编号
            ,cus_number -- 机构编号
            ,label -- 其他系统编号
            ,counterparty_cname -- 中文名称
            ,counterparty_ename -- 英文名称
            ,contact_name -- 联系人
            ,telephone -- 电话
            ,fax -- 传真
            ,update_user -- 更新用户
            ,update_time -- 更新时间
            ,is_issuer -- 是否为发行者
            ,is_bank -- 是否为银行
            ,is_guarantee -- 是否为保证人
            ,is_custody -- 是否为托管机构
            ,customer_type -- 行业类别
            ,parent -- 母公司
            ,rating_level -- 內部信用評級
            ,ex_code -- 联行号
            ,ex_account -- 人行大额支付系统号
            ,swift_code -- Swift 电文代号
            ,ref_issuer_id -- Issuer, or guarantee 会有该字段
            ,cfets_member_id -- 外汇编号或者第三方交易对手编号
            ,counterparty_short_cname -- 交易对手方中文简称
            ,counterparty_short_ename -- 交易对手方英文简称
            ,cfets_fx_member_id -- 外汇编号
            ,cfets_member_attr -- 外汇会员类型
            ,counterparty_fx_short_ename -- 外汇交易对手方英文简称
            ,interbanktype -- 交易对手同业类型
            ,overseas -- 境内境外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_counterparty_op(
            counterparty_seq -- 交易对手编号
            ,cus_number -- 机构编号
            ,label -- 其他系统编号
            ,counterparty_cname -- 中文名称
            ,counterparty_ename -- 英文名称
            ,contact_name -- 联系人
            ,telephone -- 电话
            ,fax -- 传真
            ,update_user -- 更新用户
            ,update_time -- 更新时间
            ,is_issuer -- 是否为发行者
            ,is_bank -- 是否为银行
            ,is_guarantee -- 是否为保证人
            ,is_custody -- 是否为托管机构
            ,customer_type -- 行业类别
            ,parent -- 母公司
            ,rating_level -- 內部信用評級
            ,ex_code -- 联行号
            ,ex_account -- 人行大额支付系统号
            ,swift_code -- Swift 电文代号
            ,ref_issuer_id -- Issuer, or guarantee 会有该字段
            ,cfets_member_id -- 外汇编号或者第三方交易对手编号
            ,counterparty_short_cname -- 交易对手方中文简称
            ,counterparty_short_ename -- 交易对手方英文简称
            ,cfets_fx_member_id -- 外汇编号
            ,cfets_member_attr -- 外汇会员类型
            ,counterparty_fx_short_ename -- 外汇交易对手方英文简称
            ,interbanktype -- 交易对手同业类型
            ,overseas -- 境内境外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.counterparty_seq -- 交易对手编号
    ,o.cus_number -- 机构编号
    ,o.label -- 其他系统编号
    ,o.counterparty_cname -- 中文名称
    ,o.counterparty_ename -- 英文名称
    ,o.contact_name -- 联系人
    ,o.telephone -- 电话
    ,o.fax -- 传真
    ,o.update_user -- 更新用户
    ,o.update_time -- 更新时间
    ,o.is_issuer -- 是否为发行者
    ,o.is_bank -- 是否为银行
    ,o.is_guarantee -- 是否为保证人
    ,o.is_custody -- 是否为托管机构
    ,o.customer_type -- 行业类别
    ,o.parent -- 母公司
    ,o.rating_level -- 內部信用評級
    ,o.ex_code -- 联行号
    ,o.ex_account -- 人行大额支付系统号
    ,o.swift_code -- Swift 电文代号
    ,o.ref_issuer_id -- Issuer, or guarantee 会有该字段
    ,o.cfets_member_id -- 外汇编号或者第三方交易对手编号
    ,o.counterparty_short_cname -- 交易对手方中文简称
    ,o.counterparty_short_ename -- 交易对手方英文简称
    ,o.cfets_fx_member_id -- 外汇编号
    ,o.cfets_member_attr -- 外汇会员类型
    ,o.counterparty_fx_short_ename -- 外汇交易对手方英文简称
    ,o.interbanktype -- 交易对手同业类型
    ,o.overseas -- 境内境外
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_counterparty_bk o
    left join ${iol_schema}.ctms_fbs_v_counterparty_op n
        on
            o.counterparty_seq = n.counterparty_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_counterparty_cl d
        on
            o.counterparty_seq = d.counterparty_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_v_counterparty;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_counterparty exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_counterparty_cl;
alter table ${iol_schema}.ctms_fbs_v_counterparty exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_counterparty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_counterparty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_counterparty_op purge;
drop table ${iol_schema}.ctms_fbs_v_counterparty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_counterparty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_counterparty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
