/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_acct_info
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
create table ${iol_schema}.fzss_mod_fzs_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_acct_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_acct_info_cl(
            corp_id -- 平台商户号
            ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
            ,cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
            ,corp_work_date -- 平台日期
            ,order_no -- 订单号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
            ,sub_acct_nm -- 子账户名称
            ,member_name -- 会员名称
            ,acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
            ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
            ,balance -- 总余额 [枚举: 总余额]
            ,cash_amt -- 可提余额 [枚举: 清算后的余额]
            ,freeze_amt -- 冻结余额
            ,outstanding_amt -- 待清算余额
            ,open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
            ,acct_open_dt -- 开户日期
            ,acct_open_tm -- 开户时间
            ,acct_close_dt -- 销户日期
            ,acct_close_tm -- 销户时间
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_acct_info_op(
            corp_id -- 平台商户号
            ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
            ,cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
            ,corp_work_date -- 平台日期
            ,order_no -- 订单号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
            ,sub_acct_nm -- 子账户名称
            ,member_name -- 会员名称
            ,acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
            ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
            ,balance -- 总余额 [枚举: 总余额]
            ,cash_amt -- 可提余额 [枚举: 清算后的余额]
            ,freeze_amt -- 冻结余额
            ,outstanding_amt -- 待清算余额
            ,open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
            ,acct_open_dt -- 开户日期
            ,acct_open_tm -- 开户时间
            ,acct_close_dt -- 销户日期
            ,acct_close_tm -- 销户时间
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 平台商户号
    ,nvl(n.sub_acct_no, o.sub_acct_no) as sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
    ,nvl(n.corp_work_date, o.corp_work_date) as corp_work_date -- 平台日期
    ,nvl(n.order_no, o.order_no) as order_no -- 订单号
    ,nvl(n.mybank, o.mybank) as mybank -- 法人标识代码
    ,nvl(n.zone_no, o.zone_no) as zone_no -- 分行号
    ,nvl(n.cmd_type, o.cmd_type) as cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
    ,nvl(n.sub_acct_nm, o.sub_acct_nm) as sub_acct_nm -- 子账户名称
    ,nvl(n.member_name, o.member_name) as member_name -- 会员名称
    ,nvl(n.acct_cls, o.acct_cls) as acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,nvl(n.balance, o.balance) as balance -- 总余额 [枚举: 总余额]
    ,nvl(n.cash_amt, o.cash_amt) as cash_amt -- 可提余额 [枚举: 清算后的余额]
    ,nvl(n.freeze_amt, o.freeze_amt) as freeze_amt -- 冻结余额
    ,nvl(n.outstanding_amt, o.outstanding_amt) as outstanding_amt -- 待清算余额
    ,nvl(n.open_brno, o.open_brno) as open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
    ,nvl(n.acct_open_dt, o.acct_open_dt) as acct_open_dt -- 开户日期
    ,nvl(n.acct_open_tm, o.acct_open_tm) as acct_open_tm -- 开户时间
    ,nvl(n.acct_close_dt, o.acct_close_dt) as acct_close_dt -- 销户日期
    ,nvl(n.acct_close_tm, o.acct_close_tm) as acct_close_tm -- 销户时间
    ,nvl(n.tran_net_member_code, o.tran_net_member_code) as tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,nvl(n.cust_role, o.cust_role) as cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型 [枚举: 1-对私,2-对公]
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.sub_acct_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sub_acct_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sub_acct_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fzss_mod_fzs_acct_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fzss_mod_fzs_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sub_acct_no = n.sub_acct_no
where (
        o.sub_acct_no is null
    )
    or (
        n.sub_acct_no is null
    )
    or (
        o.corp_id <> n.corp_id
        or o.cust_id <> n.cust_id
        or o.corp_work_date <> n.corp_work_date
        or o.order_no <> n.order_no
        or o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.cmd_type <> n.cmd_type
        or o.sub_acct_nm <> n.sub_acct_nm
        or o.member_name <> n.member_name
        or o.acct_cls <> n.acct_cls
        or o.acct_status <> n.acct_status
        or o.balance <> n.balance
        or o.cash_amt <> n.cash_amt
        or o.freeze_amt <> n.freeze_amt
        or o.outstanding_amt <> n.outstanding_amt
        or o.open_brno <> n.open_brno
        or o.acct_open_dt <> n.acct_open_dt
        or o.acct_open_tm <> n.acct_open_tm
        or o.acct_close_dt <> n.acct_close_dt
        or o.acct_close_tm <> n.acct_close_tm
        or o.tran_net_member_code <> n.tran_net_member_code
        or o.cust_role <> n.cust_role
        or o.cust_type <> n.cust_type
        or o.remark <> n.remark
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_acct_info_cl(
            corp_id -- 平台商户号
            ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
            ,cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
            ,corp_work_date -- 平台日期
            ,order_no -- 订单号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
            ,sub_acct_nm -- 子账户名称
            ,member_name -- 会员名称
            ,acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
            ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
            ,balance -- 总余额 [枚举: 总余额]
            ,cash_amt -- 可提余额 [枚举: 清算后的余额]
            ,freeze_amt -- 冻结余额
            ,outstanding_amt -- 待清算余额
            ,open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
            ,acct_open_dt -- 开户日期
            ,acct_open_tm -- 开户时间
            ,acct_close_dt -- 销户日期
            ,acct_close_tm -- 销户时间
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_acct_info_op(
            corp_id -- 平台商户号
            ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
            ,cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
            ,corp_work_date -- 平台日期
            ,order_no -- 订单号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
            ,sub_acct_nm -- 子账户名称
            ,member_name -- 会员名称
            ,acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
            ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
            ,balance -- 总余额 [枚举: 总余额]
            ,cash_amt -- 可提余额 [枚举: 清算后的余额]
            ,freeze_amt -- 冻结余额
            ,outstanding_amt -- 待清算余额
            ,open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
            ,acct_open_dt -- 开户日期
            ,acct_open_tm -- 开户时间
            ,acct_close_dt -- 销户日期
            ,acct_close_tm -- 销户时间
            ,tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
            ,cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
            ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
            ,remark -- 备注
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 平台商户号
    ,o.sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
    ,o.cust_id -- 客户ID （2+1+8位序号） （2+2+8位序号）
    ,o.corp_work_date -- 平台日期
    ,o.order_no -- 订单号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.cmd_type -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
    ,o.sub_acct_nm -- 子账户名称
    ,o.member_name -- 会员名称
    ,o.acct_cls -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
    ,o.acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,o.balance -- 总余额 [枚举: 总余额]
    ,o.cash_amt -- 可提余额 [枚举: 清算后的余额]
    ,o.freeze_amt -- 冻结余额
    ,o.outstanding_amt -- 待清算余额
    ,o.open_brno -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
    ,o.acct_open_dt -- 开户日期
    ,o.acct_open_tm -- 开户时间
    ,o.acct_close_dt -- 销户日期
    ,o.acct_close_tm -- 销户时间
    ,o.tran_net_member_code -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,o.cust_role -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,o.cust_type -- 客户类型 [枚举: 1-对私,2-对公]
    ,o.remark -- 备注
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.fzss_mod_fzs_acct_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_acct_info_op n
        on
            o.sub_acct_no = n.sub_acct_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fzss_mod_fzs_acct_info_cl d
        on
            o.sub_acct_no = d.sub_acct_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_acct_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_acct_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_acct_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
