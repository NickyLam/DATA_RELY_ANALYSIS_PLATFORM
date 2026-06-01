/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08plkhzhcx
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
create table ${iol_schema}.mpcs_a08plkhzhcx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08plkhzhcx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08plkhzhcx_op purge;
drop table ${iol_schema}.mpcs_a08plkhzhcx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08plkhzhcx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08plkhzhcx where 0=1;

create table ${iol_schema}.mpcs_a08plkhzhcx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08plkhzhcx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08plkhzhcx_cl(
            ptkype -- 
            ,transseq -- 报文标识号
            ,transdt -- 中台交易日期
            ,transtm -- 中台交易时间
            ,transmitdt -- 报文发送时间
            ,sndupbrn -- 发起直接参与机构
            ,sndbrn -- 发起参与机构
            ,rcvupbrn -- 接收直接参与机构
            ,rcvbrn -- 接收参与机构
            ,syscd -- 系统编号
            ,note -- 备注
            ,qryacctcnt -- 查询账户数目
            ,no -- 序号
            ,acctno -- 账户账号(卡号)
            ,acctname -- 账户名称
            ,acctopenbrn -- 开户银行行号
            ,id -- 身份证号
            ,tel -- 电话/电挂
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,accountstatus -- 账户状态
            ,accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
            ,contactcertificatetypeid -- 证件类型
            ,infostring -- 证件号
            ,mobilephone -- 预留手机号
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行日期
            ,prccd -- 业务处理码
            ,globalseqno -- 
            ,channlid -- 
            ,refmsgno -- 
            ,openbrn -- 开户机构
            ,checkdept -- 核查部门
            ,srcsysid -- 源渠道码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08plkhzhcx_op(
            ptkype -- 
            ,transseq -- 报文标识号
            ,transdt -- 中台交易日期
            ,transtm -- 中台交易时间
            ,transmitdt -- 报文发送时间
            ,sndupbrn -- 发起直接参与机构
            ,sndbrn -- 发起参与机构
            ,rcvupbrn -- 接收直接参与机构
            ,rcvbrn -- 接收参与机构
            ,syscd -- 系统编号
            ,note -- 备注
            ,qryacctcnt -- 查询账户数目
            ,no -- 序号
            ,acctno -- 账户账号(卡号)
            ,acctname -- 账户名称
            ,acctopenbrn -- 开户银行行号
            ,id -- 身份证号
            ,tel -- 电话/电挂
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,accountstatus -- 账户状态
            ,accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
            ,contactcertificatetypeid -- 证件类型
            ,infostring -- 证件号
            ,mobilephone -- 预留手机号
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行日期
            ,prccd -- 业务处理码
            ,globalseqno -- 
            ,channlid -- 
            ,refmsgno -- 
            ,openbrn -- 开户机构
            ,checkdept -- 核查部门
            ,srcsysid -- 源渠道码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ptkype, o.ptkype) as ptkype -- 
    ,nvl(n.transseq, o.transseq) as transseq -- 报文标识号
    ,nvl(n.transdt, o.transdt) as transdt -- 中台交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 中台交易时间
    ,nvl(n.transmitdt, o.transmitdt) as transmitdt -- 报文发送时间
    ,nvl(n.sndupbrn, o.sndupbrn) as sndupbrn -- 发起直接参与机构
    ,nvl(n.sndbrn, o.sndbrn) as sndbrn -- 发起参与机构
    ,nvl(n.rcvupbrn, o.rcvupbrn) as rcvupbrn -- 接收直接参与机构
    ,nvl(n.rcvbrn, o.rcvbrn) as rcvbrn -- 接收参与机构
    ,nvl(n.syscd, o.syscd) as syscd -- 系统编号
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.qryacctcnt, o.qryacctcnt) as qryacctcnt -- 查询账户数目
    ,nvl(n.no, o.no) as no -- 序号
    ,nvl(n.acctno, o.acctno) as acctno -- 账户账号(卡号)
    ,nvl(n.acctname, o.acctname) as acctname -- 账户名称
    ,nvl(n.acctopenbrn, o.acctopenbrn) as acctopenbrn -- 开户银行行号
    ,nvl(n.id, o.id) as id -- 身份证号
    ,nvl(n.tel, o.tel) as tel -- 电话/电挂
    ,nvl(n.transt, o.transt) as transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,nvl(n.accountstatus, o.accountstatus) as accountstatus -- 账户状态
    ,nvl(n.accountlevel, o.accountlevel) as accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
    ,nvl(n.contactcertificatetypeid, o.contactcertificatetypeid) as contactcertificatetypeid -- 证件类型
    ,nvl(n.infostring, o.infostring) as infostring -- 证件号
    ,nvl(n.mobilephone, o.mobilephone) as mobilephone -- 预留手机号
    ,nvl(n.iotype, o.iotype) as iotype -- 往来标识 0-往帐 1-来帐
    ,nvl(n.processcode, o.processcode) as processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
    ,nvl(n.advest, o.advest) as advest -- 业务拒绝码
    ,nvl(n.rjctinf, o.rjctinf) as rjctinf -- 业务拒绝信息
    ,nvl(n.obaldt, o.obaldt) as obaldt -- 人行日期
    ,nvl(n.prccd, o.prccd) as prccd -- 业务处理码
    ,nvl(n.globalseqno, o.globalseqno) as globalseqno -- 
    ,nvl(n.channlid, o.channlid) as channlid -- 
    ,nvl(n.refmsgno, o.refmsgno) as refmsgno -- 
    ,nvl(n.openbrn, o.openbrn) as openbrn -- 开户机构
    ,nvl(n.checkdept, o.checkdept) as checkdept -- 核查部门
    ,nvl(n.srcsysid, o.srcsysid) as srcsysid -- 源渠道码
    ,case when
            n.transseq is null
            and n.acctno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.transseq is null
            and n.acctno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.transseq is null
            and n.acctno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08plkhzhcx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08plkhzhcx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.transseq = n.transseq
            and o.acctno = n.acctno
where (
        o.transseq is null
        and o.acctno is null
    )
    or (
        n.transseq is null
        and n.acctno is null
    )
    or (
        o.ptkype <> n.ptkype
        or o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.transmitdt <> n.transmitdt
        or o.sndupbrn <> n.sndupbrn
        or o.sndbrn <> n.sndbrn
        or o.rcvupbrn <> n.rcvupbrn
        or o.rcvbrn <> n.rcvbrn
        or o.syscd <> n.syscd
        or o.note <> n.note
        or o.qryacctcnt <> n.qryacctcnt
        or o.no <> n.no
        or o.acctname <> n.acctname
        or o.acctopenbrn <> n.acctopenbrn
        or o.id <> n.id
        or o.tel <> n.tel
        or o.transt <> n.transt
        or o.accountstatus <> n.accountstatus
        or o.accountlevel <> n.accountlevel
        or o.contactcertificatetypeid <> n.contactcertificatetypeid
        or o.infostring <> n.infostring
        or o.mobilephone <> n.mobilephone
        or o.iotype <> n.iotype
        or o.processcode <> n.processcode
        or o.advest <> n.advest
        or o.rjctinf <> n.rjctinf
        or o.obaldt <> n.obaldt
        or o.prccd <> n.prccd
        or o.globalseqno <> n.globalseqno
        or o.channlid <> n.channlid
        or o.refmsgno <> n.refmsgno
        or o.openbrn <> n.openbrn
        or o.checkdept <> n.checkdept
        or o.srcsysid <> n.srcsysid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08plkhzhcx_cl(
            ptkype -- 
            ,transseq -- 报文标识号
            ,transdt -- 中台交易日期
            ,transtm -- 中台交易时间
            ,transmitdt -- 报文发送时间
            ,sndupbrn -- 发起直接参与机构
            ,sndbrn -- 发起参与机构
            ,rcvupbrn -- 接收直接参与机构
            ,rcvbrn -- 接收参与机构
            ,syscd -- 系统编号
            ,note -- 备注
            ,qryacctcnt -- 查询账户数目
            ,no -- 序号
            ,acctno -- 账户账号(卡号)
            ,acctname -- 账户名称
            ,acctopenbrn -- 开户银行行号
            ,id -- 身份证号
            ,tel -- 电话/电挂
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,accountstatus -- 账户状态
            ,accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
            ,contactcertificatetypeid -- 证件类型
            ,infostring -- 证件号
            ,mobilephone -- 预留手机号
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行日期
            ,prccd -- 业务处理码
            ,globalseqno -- 
            ,channlid -- 
            ,refmsgno -- 
            ,openbrn -- 开户机构
            ,checkdept -- 核查部门
            ,srcsysid -- 源渠道码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08plkhzhcx_op(
            ptkype -- 
            ,transseq -- 报文标识号
            ,transdt -- 中台交易日期
            ,transtm -- 中台交易时间
            ,transmitdt -- 报文发送时间
            ,sndupbrn -- 发起直接参与机构
            ,sndbrn -- 发起参与机构
            ,rcvupbrn -- 接收直接参与机构
            ,rcvbrn -- 接收参与机构
            ,syscd -- 系统编号
            ,note -- 备注
            ,qryacctcnt -- 查询账户数目
            ,no -- 序号
            ,acctno -- 账户账号(卡号)
            ,acctname -- 账户名称
            ,acctopenbrn -- 开户银行行号
            ,id -- 身份证号
            ,tel -- 电话/电挂
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,accountstatus -- 账户状态
            ,accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
            ,contactcertificatetypeid -- 证件类型
            ,infostring -- 证件号
            ,mobilephone -- 预留手机号
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行日期
            ,prccd -- 业务处理码
            ,globalseqno -- 
            ,channlid -- 
            ,refmsgno -- 
            ,openbrn -- 开户机构
            ,checkdept -- 核查部门
            ,srcsysid -- 源渠道码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ptkype -- 
    ,o.transseq -- 报文标识号
    ,o.transdt -- 中台交易日期
    ,o.transtm -- 中台交易时间
    ,o.transmitdt -- 报文发送时间
    ,o.sndupbrn -- 发起直接参与机构
    ,o.sndbrn -- 发起参与机构
    ,o.rcvupbrn -- 接收直接参与机构
    ,o.rcvbrn -- 接收参与机构
    ,o.syscd -- 系统编号
    ,o.note -- 备注
    ,o.qryacctcnt -- 查询账户数目
    ,o.no -- 序号
    ,o.acctno -- 账户账号(卡号)
    ,o.acctname -- 账户名称
    ,o.acctopenbrn -- 开户银行行号
    ,o.id -- 身份证号
    ,o.tel -- 电话/电挂
    ,o.transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,o.accountstatus -- 账户状态
    ,o.accountlevel -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
    ,o.contactcertificatetypeid -- 证件类型
    ,o.infostring -- 证件号
    ,o.mobilephone -- 预留手机号
    ,o.iotype -- 往来标识 0-往帐 1-来帐
    ,o.processcode -- 人行处理结果 pr00-处理成功 pr09-已拒绝
    ,o.advest -- 业务拒绝码
    ,o.rjctinf -- 业务拒绝信息
    ,o.obaldt -- 人行日期
    ,o.prccd -- 业务处理码
    ,o.globalseqno -- 
    ,o.channlid -- 
    ,o.refmsgno -- 
    ,o.openbrn -- 开户机构
    ,o.checkdept -- 核查部门
    ,o.srcsysid -- 源渠道码
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
from ${iol_schema}.mpcs_a08plkhzhcx_bk o
    left join ${iol_schema}.mpcs_a08plkhzhcx_op n
        on
            o.transseq = n.transseq
            and o.acctno = n.acctno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08plkhzhcx_cl d
        on
            o.transseq = d.transseq
            and o.acctno = d.acctno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a08plkhzhcx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a08plkhzhcx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a08plkhzhcx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a08plkhzhcx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a08plkhzhcx exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a08plkhzhcx_cl;
alter table ${iol_schema}.mpcs_a08plkhzhcx exchange partition p_20991231 with table ${iol_schema}.mpcs_a08plkhzhcx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08plkhzhcx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08plkhzhcx_op purge;
drop table ${iol_schema}.mpcs_a08plkhzhcx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08plkhzhcx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08plkhzhcx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
