/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1utjgptsignacct
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
create table ${iol_schema}.mpcs_a1utjgptsignacct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1utjgptsignacct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1utjgptsignacct_op purge;
drop table ${iol_schema}.mpcs_a1utjgptsignacct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1utjgptsignacct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1utjgptsignacct where 0=1;

create table ${iol_schema}.mpcs_a1utjgptsignacct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1utjgptsignacct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1utjgptsignacct_cl(
            syscd -- 系统编号
            ,account -- 监管账号
            ,accountname -- 监管账号户名
            ,status -- 签约状态：0-未签约 1-签约 2-解约
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,offdate -- 解约日期
            ,offtime -- 解约时间
            ,oprbrn -- 交易机构
            ,oprtlr -- 交易柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,companyname -- 单位名称
            ,projectname -- 项目名称
            ,contactnum -- 联系人
            ,telphome -- 联系人电话
            ,opbankname -- 开户行
            ,opbankcode -- 开户行编码
            ,remarks -- 备注
            ,accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
            ,errmsg -- 错误信息
            ,sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
            ,returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
            ,reason -- 返回信息
            ,openbrn -- 开户机构
            ,historicalflag -- 历史数据标志：0_不用 1_需要
            ,opendate -- 开户日期
            ,xzqhbm -- 行政区划编码
            ,updt -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1utjgptsignacct_op(
            syscd -- 系统编号
            ,account -- 监管账号
            ,accountname -- 监管账号户名
            ,status -- 签约状态：0-未签约 1-签约 2-解约
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,offdate -- 解约日期
            ,offtime -- 解约时间
            ,oprbrn -- 交易机构
            ,oprtlr -- 交易柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,companyname -- 单位名称
            ,projectname -- 项目名称
            ,contactnum -- 联系人
            ,telphome -- 联系人电话
            ,opbankname -- 开户行
            ,opbankcode -- 开户行编码
            ,remarks -- 备注
            ,accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
            ,errmsg -- 错误信息
            ,sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
            ,returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
            ,reason -- 返回信息
            ,openbrn -- 开户机构
            ,historicalflag -- 历史数据标志：0_不用 1_需要
            ,opendate -- 开户日期
            ,xzqhbm -- 行政区划编码
            ,updt -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.syscd, o.syscd) as syscd -- 系统编号
    ,nvl(n.account, o.account) as account -- 监管账号
    ,nvl(n.accountname, o.accountname) as accountname -- 监管账号户名
    ,nvl(n.status, o.status) as status -- 签约状态：0-未签约 1-签约 2-解约
    ,nvl(n.signdate, o.signdate) as signdate -- 签约日期
    ,nvl(n.signtime, o.signtime) as signtime -- 签约时间
    ,nvl(n.offdate, o.offdate) as offdate -- 解约日期
    ,nvl(n.offtime, o.offtime) as offtime -- 解约时间
    ,nvl(n.oprbrn, o.oprbrn) as oprbrn -- 交易机构
    ,nvl(n.oprtlr, o.oprtlr) as oprtlr -- 交易柜员
    ,nvl(n.chkbrn, o.chkbrn) as chkbrn -- 复核机构
    ,nvl(n.chktlr, o.chktlr) as chktlr -- 复核柜员
    ,nvl(n.autbrn, o.autbrn) as autbrn -- 授权机构
    ,nvl(n.auttlr, o.auttlr) as auttlr -- 授权柜员
    ,nvl(n.companyname, o.companyname) as companyname -- 单位名称
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.contactnum, o.contactnum) as contactnum -- 联系人
    ,nvl(n.telphome, o.telphome) as telphome -- 联系人电话
    ,nvl(n.opbankname, o.opbankname) as opbankname -- 开户行
    ,nvl(n.opbankcode, o.opbankcode) as opbankcode -- 开户行编码
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.accountstatus, o.accountstatus) as accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 错误信息
    ,nvl(n.sndflag, o.sndflag) as sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
    ,nvl(n.returncode, o.returncode) as returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
    ,nvl(n.reason, o.reason) as reason -- 返回信息
    ,nvl(n.openbrn, o.openbrn) as openbrn -- 开户机构
    ,nvl(n.historicalflag, o.historicalflag) as historicalflag -- 历史数据标志：0_不用 1_需要
    ,nvl(n.opendate, o.opendate) as opendate -- 开户日期
    ,nvl(n.xzqhbm, o.xzqhbm) as xzqhbm -- 行政区划编码
    ,nvl(n.updt, o.updt) as updt -- 最后修改时间
    ,case when
            n.syscd is null
            and n.account is null
            and n.signdate is null
            and n.signtime is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.syscd is null
            and n.account is null
            and n.signdate is null
            and n.signtime is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.syscd is null
            and n.account is null
            and n.signdate is null
            and n.signtime is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1utjgptsignacct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1utjgptsignacct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.syscd = n.syscd
            and o.account = n.account
            and o.signdate = n.signdate
            and o.signtime = n.signtime
where (
        o.syscd is null
        and o.account is null
        and o.signdate is null
        and o.signtime is null
    )
    or (
        n.syscd is null
        and n.account is null
        and n.signdate is null
        and n.signtime is null
    )
    or (
        o.accountname <> n.accountname
        or o.status <> n.status
        or o.offdate <> n.offdate
        or o.offtime <> n.offtime
        or o.oprbrn <> n.oprbrn
        or o.oprtlr <> n.oprtlr
        or o.chkbrn <> n.chkbrn
        or o.chktlr <> n.chktlr
        or o.autbrn <> n.autbrn
        or o.auttlr <> n.auttlr
        or o.companyname <> n.companyname
        or o.projectname <> n.projectname
        or o.contactnum <> n.contactnum
        or o.telphome <> n.telphome
        or o.opbankname <> n.opbankname
        or o.opbankcode <> n.opbankcode
        or o.remarks <> n.remarks
        or o.accountstatus <> n.accountstatus
        or o.errmsg <> n.errmsg
        or o.sndflag <> n.sndflag
        or o.returncode <> n.returncode
        or o.reason <> n.reason
        or o.openbrn <> n.openbrn
        or o.historicalflag <> n.historicalflag
        or o.opendate <> n.opendate
        or o.xzqhbm <> n.xzqhbm
        or o.updt <> n.updt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1utjgptsignacct_cl(
            syscd -- 系统编号
            ,account -- 监管账号
            ,accountname -- 监管账号户名
            ,status -- 签约状态：0-未签约 1-签约 2-解约
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,offdate -- 解约日期
            ,offtime -- 解约时间
            ,oprbrn -- 交易机构
            ,oprtlr -- 交易柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,companyname -- 单位名称
            ,projectname -- 项目名称
            ,contactnum -- 联系人
            ,telphome -- 联系人电话
            ,opbankname -- 开户行
            ,opbankcode -- 开户行编码
            ,remarks -- 备注
            ,accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
            ,errmsg -- 错误信息
            ,sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
            ,returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
            ,reason -- 返回信息
            ,openbrn -- 开户机构
            ,historicalflag -- 历史数据标志：0_不用 1_需要
            ,opendate -- 开户日期
            ,xzqhbm -- 行政区划编码
            ,updt -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1utjgptsignacct_op(
            syscd -- 系统编号
            ,account -- 监管账号
            ,accountname -- 监管账号户名
            ,status -- 签约状态：0-未签约 1-签约 2-解约
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,offdate -- 解约日期
            ,offtime -- 解约时间
            ,oprbrn -- 交易机构
            ,oprtlr -- 交易柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,companyname -- 单位名称
            ,projectname -- 项目名称
            ,contactnum -- 联系人
            ,telphome -- 联系人电话
            ,opbankname -- 开户行
            ,opbankcode -- 开户行编码
            ,remarks -- 备注
            ,accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
            ,errmsg -- 错误信息
            ,sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
            ,returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
            ,reason -- 返回信息
            ,openbrn -- 开户机构
            ,historicalflag -- 历史数据标志：0_不用 1_需要
            ,opendate -- 开户日期
            ,xzqhbm -- 行政区划编码
            ,updt -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.syscd -- 系统编号
    ,o.account -- 监管账号
    ,o.accountname -- 监管账号户名
    ,o.status -- 签约状态：0-未签约 1-签约 2-解约
    ,o.signdate -- 签约日期
    ,o.signtime -- 签约时间
    ,o.offdate -- 解约日期
    ,o.offtime -- 解约时间
    ,o.oprbrn -- 交易机构
    ,o.oprtlr -- 交易柜员
    ,o.chkbrn -- 复核机构
    ,o.chktlr -- 复核柜员
    ,o.autbrn -- 授权机构
    ,o.auttlr -- 授权柜员
    ,o.companyname -- 单位名称
    ,o.projectname -- 项目名称
    ,o.contactnum -- 联系人
    ,o.telphome -- 联系人电话
    ,o.opbankname -- 开户行
    ,o.opbankcode -- 开户行编码
    ,o.remarks -- 备注
    ,o.accountstatus -- 监管状态:0_预监管 1_监管中 2_解除监管
    ,o.errmsg -- 错误信息
    ,o.sndflag -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
    ,o.returncode -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
    ,o.reason -- 返回信息
    ,o.openbrn -- 开户机构
    ,o.historicalflag -- 历史数据标志：0_不用 1_需要
    ,o.opendate -- 开户日期
    ,o.xzqhbm -- 行政区划编码
    ,o.updt -- 最后修改时间
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
from ${iol_schema}.mpcs_a1utjgptsignacct_bk o
    left join ${iol_schema}.mpcs_a1utjgptsignacct_op n
        on
            o.syscd = n.syscd
            and o.account = n.account
            and o.signdate = n.signdate
            and o.signtime = n.signtime
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1utjgptsignacct_cl d
        on
            o.syscd = d.syscd
            and o.account = d.account
            and o.signdate = d.signdate
            and o.signtime = d.signtime
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1utjgptsignacct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1utjgptsignacct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1utjgptsignacct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1utjgptsignacct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1utjgptsignacct exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1utjgptsignacct_cl;
alter table ${iol_schema}.mpcs_a1utjgptsignacct exchange partition p_20991231 with table ${iol_schema}.mpcs_a1utjgptsignacct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1utjgptsignacct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1utjgptsignacct_op purge;
drop table ${iol_schema}.mpcs_a1utjgptsignacct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1utjgptsignacct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1utjgptsignacct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
