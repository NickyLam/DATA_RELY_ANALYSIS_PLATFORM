/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60projdf_sign
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
create table ${iol_schema}.mpcs_a60projdf_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a60projdf_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60projdf_sign_op purge;
drop table ${iol_schema}.mpcs_a60projdf_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60projdf_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60projdf_sign where 0=1;

create table ${iol_schema}.mpcs_a60projdf_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60projdf_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60projdf_sign_cl(
            projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60projdf_sign_op(
            projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.projno, o.projno) as projno -- 项目号
    ,nvl(n.projtp, o.projtp) as projtp -- 项目名称: 00.代扣 05.代发  09.开卡
    ,nvl(n.acctno, o.acctno) as acctno -- 委托单位账号
    ,nvl(n.acctna, o.acctna) as acctna -- 委托单位名称
    ,nvl(n.offitl, o.offitl) as offitl -- 单位电话
    ,nvl(n.mailad, o.mailad) as mailad -- 地址
    ,nvl(n.glacno, o.glacno) as glacno -- 内部账户
    ,nvl(n.glacna, o.glacna) as glacna -- 内部账户名称
    ,nvl(n.bstype, o.bstype) as bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
    ,nvl(n.wdtype, o.wdtype) as wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
    ,nvl(n.isnbnk, o.isnbnk) as isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
    ,nvl(n.compco, o.compco) as compco -- 组织机构代码
    ,nvl(n.feeamo, o.feeamo) as feeamo -- 网银代发手续费
    ,nvl(n.dracno, o.dracno) as dracno -- 扣收手续费账号
    ,nvl(n.dracna, o.dracna) as dracna -- 手续费账户名称
    ,nvl(n.coyhbl, o.coyhbl) as coyhbl -- 客户优惠率
    ,nvl(n.yhendt, o.yhendt) as yhendt -- 优惠截止日期
    ,nvl(n.signdt, o.signdt) as signdt -- 签约日期
    ,nvl(n.cntrbr, o.cntrbr) as cntrbr -- 签约机构
    ,nvl(n.crtrus, o.crtrus) as crtrus -- 受理柜员
    ,nvl(n.modidt, o.modidt) as modidt -- 修改日期
    ,nvl(n.mdtrbr, o.mdtrbr) as mdtrbr -- 修改机构
    ,nvl(n.mdtrus, o.mdtrus) as mdtrus -- 修改柜员
    ,nvl(n.cntrst, o.cntrst) as cntrst -- 协议状态  1-正常0-关闭
    ,nvl(n.closdt, o.closdt) as closdt -- 解约日期
    ,nvl(n.closus, o.closus) as closus -- 解约柜员
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.otherflag, o.otherflag) as otherflag -- 他行标识 0-本行 1-他行
    ,nvl(n.otheracctno, o.otheracctno) as otheracctno -- 他行账号
    ,nvl(n.otheracctna, o.otheracctna) as otheracctna -- 他行户名
    ,nvl(n.otherbankno, o.otherbankno) as otherbankno -- 他行行号
    ,nvl(n.otherbankna, o.otherbankna) as otherbankna -- 他行行名
    ,nvl(n.inneracno, o.inneracno) as inneracno -- 过渡内部户账号
    ,nvl(n.inneracna, o.inneracna) as inneracna -- 过渡内部户户名
    ,nvl(n.tkflag, o.tkflag) as tkflag -- 退款标志
    ,nvl(n.lmtamtflg, o.lmtamtflg) as lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
    ,nvl(n.monthlmtamt, o.monthlmtamt) as monthlmtamt -- 月累计限额
    ,case when
            n.projno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.projno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.projno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a60projdf_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a60projdf_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.projno = n.projno
where (
        o.projno is null
    )
    or (
        n.projno is null
    )
    or (
        o.projtp <> n.projtp
        or o.acctno <> n.acctno
        or o.acctna <> n.acctna
        or o.offitl <> n.offitl
        or o.mailad <> n.mailad
        or o.glacno <> n.glacno
        or o.glacna <> n.glacna
        or o.bstype <> n.bstype
        or o.wdtype <> n.wdtype
        or o.isnbnk <> n.isnbnk
        or o.compco <> n.compco
        or o.feeamo <> n.feeamo
        or o.dracno <> n.dracno
        or o.dracna <> n.dracna
        or o.coyhbl <> n.coyhbl
        or o.yhendt <> n.yhendt
        or o.signdt <> n.signdt
        or o.cntrbr <> n.cntrbr
        or o.crtrus <> n.crtrus
        or o.modidt <> n.modidt
        or o.mdtrbr <> n.mdtrbr
        or o.mdtrus <> n.mdtrus
        or o.cntrst <> n.cntrst
        or o.closdt <> n.closdt
        or o.closus <> n.closus
        or o.custno <> n.custno
        or o.otherflag <> n.otherflag
        or o.otheracctno <> n.otheracctno
        or o.otheracctna <> n.otheracctna
        or o.otherbankno <> n.otherbankno
        or o.otherbankna <> n.otherbankna
        or o.inneracno <> n.inneracno
        or o.inneracna <> n.inneracna
        or o.tkflag <> n.tkflag
        or o.lmtamtflg <> n.lmtamtflg
        or o.monthlmtamt <> n.monthlmtamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60projdf_sign_cl(
            projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60projdf_sign_op(
            projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.projno -- 项目号
    ,o.projtp -- 项目名称: 00.代扣 05.代发  09.开卡
    ,o.acctno -- 委托单位账号
    ,o.acctna -- 委托单位名称
    ,o.offitl -- 单位电话
    ,o.mailad -- 地址
    ,o.glacno -- 内部账户
    ,o.glacna -- 内部账户名称
    ,o.bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
    ,o.wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
    ,o.isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
    ,o.compco -- 组织机构代码
    ,o.feeamo -- 网银代发手续费
    ,o.dracno -- 扣收手续费账号
    ,o.dracna -- 手续费账户名称
    ,o.coyhbl -- 客户优惠率
    ,o.yhendt -- 优惠截止日期
    ,o.signdt -- 签约日期
    ,o.cntrbr -- 签约机构
    ,o.crtrus -- 受理柜员
    ,o.modidt -- 修改日期
    ,o.mdtrbr -- 修改机构
    ,o.mdtrus -- 修改柜员
    ,o.cntrst -- 协议状态  1-正常0-关闭
    ,o.closdt -- 解约日期
    ,o.closus -- 解约柜员
    ,o.custno -- 客户号
    ,o.otherflag -- 他行标识 0-本行 1-他行
    ,o.otheracctno -- 他行账号
    ,o.otheracctna -- 他行户名
    ,o.otherbankno -- 他行行号
    ,o.otherbankna -- 他行行名
    ,o.inneracno -- 过渡内部户账号
    ,o.inneracna -- 过渡内部户户名
    ,o.tkflag -- 退款标志
    ,o.lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
    ,o.monthlmtamt -- 月累计限额
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
from ${iol_schema}.mpcs_a60projdf_sign_bk o
    left join ${iol_schema}.mpcs_a60projdf_sign_op n
        on
            o.projno = n.projno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a60projdf_sign_cl d
        on
            o.projno = d.projno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a60projdf_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a60projdf_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a60projdf_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a60projdf_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a60projdf_sign exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60projdf_sign_cl;
alter table ${iol_schema}.mpcs_a60projdf_sign exchange partition p_20991231 with table ${iol_schema}.mpcs_a60projdf_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60projdf_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60projdf_sign_op purge;
drop table ${iol_schema}.mpcs_a60projdf_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a60projdf_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60projdf_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
