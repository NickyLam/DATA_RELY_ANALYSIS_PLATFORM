/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08plkhzhyd
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
create table ${iol_schema}.mpcs_a08plkhzhyd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08plkhzhyd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08plkhzhyd_op purge;
drop table ${iol_schema}.mpcs_a08plkhzhyd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08plkhzhyd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08plkhzhyd where 0=1;

create table ${iol_schema}.mpcs_a08plkhzhyd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08plkhzhyd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08plkhzhyd_cl(
            ptkype -- 发送报文类型
            ,transseq -- 报文标识号
            ,orgtransseq -- 原报文标识号
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
            ,acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
            ,idrslt -- 身份号码校验结果
            ,telrslt -- 电话/电挂校验结果
            ,acctopenbrn -- 开户银行行号
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行处理日期
            ,prccd -- 业务处理码
            ,processcode1 -- 业务状态
            ,rejectcode -- 业务拒绝处理码
            ,rejectinfo -- 业务拒绝信息
            ,osbtranseqno -- osb交易流水
            ,osbretcd -- osb返回码
            ,osbretmsg -- osb返回信息
            ,osbretst -- osb返回状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08plkhzhyd_op(
            ptkype -- 发送报文类型
            ,transseq -- 报文标识号
            ,orgtransseq -- 原报文标识号
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
            ,acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
            ,idrslt -- 身份号码校验结果
            ,telrslt -- 电话/电挂校验结果
            ,acctopenbrn -- 开户银行行号
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行处理日期
            ,prccd -- 业务处理码
            ,processcode1 -- 业务状态
            ,rejectcode -- 业务拒绝处理码
            ,rejectinfo -- 业务拒绝信息
            ,osbtranseqno -- osb交易流水
            ,osbretcd -- osb返回码
            ,osbretmsg -- osb返回信息
            ,osbretst -- osb返回状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ptkype, o.ptkype) as ptkype -- 发送报文类型
    ,nvl(n.transseq, o.transseq) as transseq -- 报文标识号
    ,nvl(n.orgtransseq, o.orgtransseq) as orgtransseq -- 原报文标识号
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
    ,nvl(n.acctstatus, o.acctstatus) as acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
    ,nvl(n.idrslt, o.idrslt) as idrslt -- 身份号码校验结果
    ,nvl(n.telrslt, o.telrslt) as telrslt -- 电话/电挂校验结果
    ,nvl(n.acctopenbrn, o.acctopenbrn) as acctopenbrn -- 开户银行行号
    ,nvl(n.transt, o.transt) as transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,nvl(n.processcode, o.processcode) as processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
    ,nvl(n.iotype, o.iotype) as iotype -- 往来标识 0-往帐 1-来帐
    ,nvl(n.advest, o.advest) as advest -- 业务拒绝码
    ,nvl(n.rjctinf, o.rjctinf) as rjctinf -- 业务拒绝信息
    ,nvl(n.obaldt, o.obaldt) as obaldt -- 人行处理日期
    ,nvl(n.prccd, o.prccd) as prccd -- 业务处理码
    ,nvl(n.processcode1, o.processcode1) as processcode1 -- 业务状态
    ,nvl(n.rejectcode, o.rejectcode) as rejectcode -- 业务拒绝处理码
    ,nvl(n.rejectinfo, o.rejectinfo) as rejectinfo -- 业务拒绝信息
    ,nvl(n.osbtranseqno, o.osbtranseqno) as osbtranseqno -- osb交易流水
    ,nvl(n.osbretcd, o.osbretcd) as osbretcd -- osb返回码
    ,nvl(n.osbretmsg, o.osbretmsg) as osbretmsg -- osb返回信息
    ,nvl(n.osbretst, o.osbretst) as osbretst -- osb返回状态
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
from (select * from ${iol_schema}.mpcs_a08plkhzhyd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08plkhzhyd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.orgtransseq <> n.orgtransseq
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
        or o.acctstatus <> n.acctstatus
        or o.idrslt <> n.idrslt
        or o.telrslt <> n.telrslt
        or o.acctopenbrn <> n.acctopenbrn
        or o.transt <> n.transt
        or o.processcode <> n.processcode
        or o.iotype <> n.iotype
        or o.advest <> n.advest
        or o.rjctinf <> n.rjctinf
        or o.obaldt <> n.obaldt
        or o.prccd <> n.prccd
        or o.processcode1 <> n.processcode1
        or o.rejectcode <> n.rejectcode
        or o.rejectinfo <> n.rejectinfo
        or o.osbtranseqno <> n.osbtranseqno
        or o.osbretcd <> n.osbretcd
        or o.osbretmsg <> n.osbretmsg
        or o.osbretst <> n.osbretst
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08plkhzhyd_cl(
            ptkype -- 发送报文类型
            ,transseq -- 报文标识号
            ,orgtransseq -- 原报文标识号
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
            ,acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
            ,idrslt -- 身份号码校验结果
            ,telrslt -- 电话/电挂校验结果
            ,acctopenbrn -- 开户银行行号
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行处理日期
            ,prccd -- 业务处理码
            ,processcode1 -- 业务状态
            ,rejectcode -- 业务拒绝处理码
            ,rejectinfo -- 业务拒绝信息
            ,osbtranseqno -- osb交易流水
            ,osbretcd -- osb返回码
            ,osbretmsg -- osb返回信息
            ,osbretst -- osb返回状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08plkhzhyd_op(
            ptkype -- 发送报文类型
            ,transseq -- 报文标识号
            ,orgtransseq -- 原报文标识号
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
            ,acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
            ,idrslt -- 身份号码校验结果
            ,telrslt -- 电话/电挂校验结果
            ,acctopenbrn -- 开户银行行号
            ,transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
            ,processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
            ,iotype -- 往来标识 0-往帐 1-来帐
            ,advest -- 业务拒绝码
            ,rjctinf -- 业务拒绝信息
            ,obaldt -- 人行处理日期
            ,prccd -- 业务处理码
            ,processcode1 -- 业务状态
            ,rejectcode -- 业务拒绝处理码
            ,rejectinfo -- 业务拒绝信息
            ,osbtranseqno -- osb交易流水
            ,osbretcd -- osb返回码
            ,osbretmsg -- osb返回信息
            ,osbretst -- osb返回状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ptkype -- 发送报文类型
    ,o.transseq -- 报文标识号
    ,o.orgtransseq -- 原报文标识号
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
    ,o.acctstatus -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
    ,o.idrslt -- 身份号码校验结果
    ,o.telrslt -- 电话/电挂校验结果
    ,o.acctopenbrn -- 开户银行行号
    ,o.transt -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,o.processcode -- 人行处理结果 pr00-已转发,pr09-已拒绝
    ,o.iotype -- 往来标识 0-往帐 1-来帐
    ,o.advest -- 业务拒绝码
    ,o.rjctinf -- 业务拒绝信息
    ,o.obaldt -- 人行处理日期
    ,o.prccd -- 业务处理码
    ,o.processcode1 -- 业务状态
    ,o.rejectcode -- 业务拒绝处理码
    ,o.rejectinfo -- 业务拒绝信息
    ,o.osbtranseqno -- osb交易流水
    ,o.osbretcd -- osb返回码
    ,o.osbretmsg -- osb返回信息
    ,o.osbretst -- osb返回状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a08plkhzhyd_bk o
    left join ${iol_schema}.mpcs_a08plkhzhyd_op n
        on
            o.transseq = n.transseq
            and o.acctno = n.acctno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08plkhzhyd_cl d
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
-- truncate table ${iol_schema}.mpcs_a08plkhzhyd;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a08plkhzhyd exchange partition p_19000101 with table ${iol_schema}.mpcs_a08plkhzhyd_cl;
alter table ${iol_schema}.mpcs_a08plkhzhyd exchange partition p_20991231 with table ${iol_schema}.mpcs_a08plkhzhyd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08plkhzhyd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08plkhzhyd_op purge;
drop table ${iol_schema}.mpcs_a08plkhzhyd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08plkhzhyd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08plkhzhyd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
