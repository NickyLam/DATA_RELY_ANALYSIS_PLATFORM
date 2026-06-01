/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_printvoucher_log
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
create table ${iol_schema}.nibs_ib_log_printvoucher_log_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_log_printvoucher_log
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log_op purge;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_printvoucher_log_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_printvoucher_log where 0=1;

create table ${iol_schema}.nibs_ib_log_printvoucher_log_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_printvoucher_log where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_log_printvoucher_log_cl(
            pr_sn -- 机构名
            ,chan_num -- 用户编号
            ,tx_seq_num -- 用户名称
            ,channeltrancode -- 柜员号
            ,channeltranname -- 设备型号
            ,nodecode -- 设备编号
            ,tx_dt -- 交易码
            ,backrspdate -- 交易名称
            ,vouchertype -- 交易日期
            ,vouchername -- 交易时间
            ,iselecseal -- 服务流水
            ,elecsealnum -- 受理流水
            ,isprtcontrol -- 包流水
            ,prtcontrolnum -- 核心日期
            ,prtseqno -- 核心时间
            ,prtnum -- 通讯流水
            ,prtdate -- ip
            ,prtbranch -- oid
            ,prtreason -- 后台流水
            ,prtmsg -- 交易状态
            ,print_telr_no -- 返回码
            ,prompt -- 返回描述
            ,rprint_telr_no -- 交易路径
            ,rprint_dt -- 交易数据
            ,rprint_tms -- 任务id
            ,rprint_auth_telr_no -- 影像id
            ,rprint_typ_cd -- 客户类型
            ,rprint_rsn -- 客户号
            ,note1 -- 证件类型
            ,note2 -- 证件号
            ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
            ,blendingtype -- 勾兑方式 0-手动，1-自动
            ,blip_id -- 影像编号
            ,prttype -- 打印类型|
            ,app_num -- 
            ,blendingdesc -- 
            ,blip_seq -- 
            ,cheanflag -- 
            ,sealtype -- 印章类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_log_printvoucher_log_op(
            pr_sn -- 机构名
            ,chan_num -- 用户编号
            ,tx_seq_num -- 用户名称
            ,channeltrancode -- 柜员号
            ,channeltranname -- 设备型号
            ,nodecode -- 设备编号
            ,tx_dt -- 交易码
            ,backrspdate -- 交易名称
            ,vouchertype -- 交易日期
            ,vouchername -- 交易时间
            ,iselecseal -- 服务流水
            ,elecsealnum -- 受理流水
            ,isprtcontrol -- 包流水
            ,prtcontrolnum -- 核心日期
            ,prtseqno -- 核心时间
            ,prtnum -- 通讯流水
            ,prtdate -- ip
            ,prtbranch -- oid
            ,prtreason -- 后台流水
            ,prtmsg -- 交易状态
            ,print_telr_no -- 返回码
            ,prompt -- 返回描述
            ,rprint_telr_no -- 交易路径
            ,rprint_dt -- 交易数据
            ,rprint_tms -- 任务id
            ,rprint_auth_telr_no -- 影像id
            ,rprint_typ_cd -- 客户类型
            ,rprint_rsn -- 客户号
            ,note1 -- 证件类型
            ,note2 -- 证件号
            ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
            ,blendingtype -- 勾兑方式 0-手动，1-自动
            ,blip_id -- 影像编号
            ,prttype -- 打印类型|
            ,app_num -- 
            ,blendingdesc -- 
            ,blip_seq -- 
            ,cheanflag -- 
            ,sealtype -- 印章类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pr_sn, o.pr_sn) as pr_sn -- 机构名
    ,nvl(n.chan_num, o.chan_num) as chan_num -- 用户编号
    ,nvl(n.tx_seq_num, o.tx_seq_num) as tx_seq_num -- 用户名称
    ,nvl(n.channeltrancode, o.channeltrancode) as channeltrancode -- 柜员号
    ,nvl(n.channeltranname, o.channeltranname) as channeltranname -- 设备型号
    ,nvl(n.nodecode, o.nodecode) as nodecode -- 设备编号
    ,nvl(n.tx_dt, o.tx_dt) as tx_dt -- 交易码
    ,nvl(n.backrspdate, o.backrspdate) as backrspdate -- 交易名称
    ,nvl(n.vouchertype, o.vouchertype) as vouchertype -- 交易日期
    ,nvl(n.vouchername, o.vouchername) as vouchername -- 交易时间
    ,nvl(n.iselecseal, o.iselecseal) as iselecseal -- 服务流水
    ,nvl(n.elecsealnum, o.elecsealnum) as elecsealnum -- 受理流水
    ,nvl(n.isprtcontrol, o.isprtcontrol) as isprtcontrol -- 包流水
    ,nvl(n.prtcontrolnum, o.prtcontrolnum) as prtcontrolnum -- 核心日期
    ,nvl(n.prtseqno, o.prtseqno) as prtseqno -- 核心时间
    ,nvl(n.prtnum, o.prtnum) as prtnum -- 通讯流水
    ,nvl(n.prtdate, o.prtdate) as prtdate -- ip
    ,nvl(n.prtbranch, o.prtbranch) as prtbranch -- oid
    ,nvl(n.prtreason, o.prtreason) as prtreason -- 后台流水
    ,nvl(n.prtmsg, o.prtmsg) as prtmsg -- 交易状态
    ,nvl(n.print_telr_no, o.print_telr_no) as print_telr_no -- 返回码
    ,nvl(n.prompt, o.prompt) as prompt -- 返回描述
    ,nvl(n.rprint_telr_no, o.rprint_telr_no) as rprint_telr_no -- 交易路径
    ,nvl(n.rprint_dt, o.rprint_dt) as rprint_dt -- 交易数据
    ,nvl(n.rprint_tms, o.rprint_tms) as rprint_tms -- 任务id
    ,nvl(n.rprint_auth_telr_no, o.rprint_auth_telr_no) as rprint_auth_telr_no -- 影像id
    ,nvl(n.rprint_typ_cd, o.rprint_typ_cd) as rprint_typ_cd -- 客户类型
    ,nvl(n.rprint_rsn, o.rprint_rsn) as rprint_rsn -- 客户号
    ,nvl(n.note1, o.note1) as note1 -- 证件类型
    ,nvl(n.note2, o.note2) as note2 -- 证件号
    ,nvl(n.blendingstatu, o.blendingstatu) as blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
    ,nvl(n.blendingtype, o.blendingtype) as blendingtype -- 勾兑方式 0-手动，1-自动
    ,nvl(n.blip_id, o.blip_id) as blip_id -- 影像编号
    ,nvl(n.prttype, o.prttype) as prttype -- 打印类型|
    ,nvl(n.app_num, o.app_num) as app_num -- 
    ,nvl(n.blendingdesc, o.blendingdesc) as blendingdesc -- 
    ,nvl(n.blip_seq, o.blip_seq) as blip_seq -- 
    ,nvl(n.cheanflag, o.cheanflag) as cheanflag -- 
    ,nvl(n.sealtype, o.sealtype) as sealtype -- 印章类型
    ,case when
            n.pr_sn is null
            and n.tx_seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pr_sn is null
            and n.tx_seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pr_sn is null
            and n.tx_seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_log_printvoucher_log_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_log_printvoucher_log where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pr_sn = n.pr_sn
            and o.tx_seq_num = n.tx_seq_num
where (
        o.pr_sn is null
        and o.tx_seq_num is null
    )
    or (
        n.pr_sn is null
        and n.tx_seq_num is null
    )
    or (
        o.chan_num <> n.chan_num
        or o.channeltrancode <> n.channeltrancode
        or o.channeltranname <> n.channeltranname
        or o.nodecode <> n.nodecode
        or o.tx_dt <> n.tx_dt
        or o.backrspdate <> n.backrspdate
        or o.vouchertype <> n.vouchertype
        or o.vouchername <> n.vouchername
        or o.iselecseal <> n.iselecseal
        or o.elecsealnum <> n.elecsealnum
        or o.isprtcontrol <> n.isprtcontrol
        or o.prtcontrolnum <> n.prtcontrolnum
        or o.prtseqno <> n.prtseqno
        or o.prtnum <> n.prtnum
        or o.prtdate <> n.prtdate
        or o.prtbranch <> n.prtbranch
        or o.prtreason <> n.prtreason
        or o.prtmsg <> n.prtmsg
        or o.print_telr_no <> n.print_telr_no
        or o.prompt <> n.prompt
        or o.rprint_telr_no <> n.rprint_telr_no
        or o.rprint_dt <> n.rprint_dt
        or o.rprint_tms <> n.rprint_tms
        or o.rprint_auth_telr_no <> n.rprint_auth_telr_no
        or o.rprint_typ_cd <> n.rprint_typ_cd
        or o.rprint_rsn <> n.rprint_rsn
        or o.note1 <> n.note1
        or o.note2 <> n.note2
        or o.blendingstatu <> n.blendingstatu
        or o.blendingtype <> n.blendingtype
        or o.blip_id <> n.blip_id
        or o.prttype <> n.prttype
        or o.app_num <> n.app_num
        or o.blendingdesc <> n.blendingdesc
        or o.blip_seq <> n.blip_seq
        or o.cheanflag <> n.cheanflag
        or o.sealtype <> n.sealtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_log_printvoucher_log_cl(
            pr_sn -- 机构名
            ,chan_num -- 用户编号
            ,tx_seq_num -- 用户名称
            ,channeltrancode -- 柜员号
            ,channeltranname -- 设备型号
            ,nodecode -- 设备编号
            ,tx_dt -- 交易码
            ,backrspdate -- 交易名称
            ,vouchertype -- 交易日期
            ,vouchername -- 交易时间
            ,iselecseal -- 服务流水
            ,elecsealnum -- 受理流水
            ,isprtcontrol -- 包流水
            ,prtcontrolnum -- 核心日期
            ,prtseqno -- 核心时间
            ,prtnum -- 通讯流水
            ,prtdate -- ip
            ,prtbranch -- oid
            ,prtreason -- 后台流水
            ,prtmsg -- 交易状态
            ,print_telr_no -- 返回码
            ,prompt -- 返回描述
            ,rprint_telr_no -- 交易路径
            ,rprint_dt -- 交易数据
            ,rprint_tms -- 任务id
            ,rprint_auth_telr_no -- 影像id
            ,rprint_typ_cd -- 客户类型
            ,rprint_rsn -- 客户号
            ,note1 -- 证件类型
            ,note2 -- 证件号
            ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
            ,blendingtype -- 勾兑方式 0-手动，1-自动
            ,blip_id -- 影像编号
            ,prttype -- 打印类型|
            ,app_num -- 
            ,blendingdesc -- 
            ,blip_seq -- 
            ,cheanflag -- 
            ,sealtype -- 印章类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_log_printvoucher_log_op(
            pr_sn -- 机构名
            ,chan_num -- 用户编号
            ,tx_seq_num -- 用户名称
            ,channeltrancode -- 柜员号
            ,channeltranname -- 设备型号
            ,nodecode -- 设备编号
            ,tx_dt -- 交易码
            ,backrspdate -- 交易名称
            ,vouchertype -- 交易日期
            ,vouchername -- 交易时间
            ,iselecseal -- 服务流水
            ,elecsealnum -- 受理流水
            ,isprtcontrol -- 包流水
            ,prtcontrolnum -- 核心日期
            ,prtseqno -- 核心时间
            ,prtnum -- 通讯流水
            ,prtdate -- ip
            ,prtbranch -- oid
            ,prtreason -- 后台流水
            ,prtmsg -- 交易状态
            ,print_telr_no -- 返回码
            ,prompt -- 返回描述
            ,rprint_telr_no -- 交易路径
            ,rprint_dt -- 交易数据
            ,rprint_tms -- 任务id
            ,rprint_auth_telr_no -- 影像id
            ,rprint_typ_cd -- 客户类型
            ,rprint_rsn -- 客户号
            ,note1 -- 证件类型
            ,note2 -- 证件号
            ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
            ,blendingtype -- 勾兑方式 0-手动，1-自动
            ,blip_id -- 影像编号
            ,prttype -- 打印类型|
            ,app_num -- 
            ,blendingdesc -- 
            ,blip_seq -- 
            ,cheanflag -- 
            ,sealtype -- 印章类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pr_sn -- 机构名
    ,o.chan_num -- 用户编号
    ,o.tx_seq_num -- 用户名称
    ,o.channeltrancode -- 柜员号
    ,o.channeltranname -- 设备型号
    ,o.nodecode -- 设备编号
    ,o.tx_dt -- 交易码
    ,o.backrspdate -- 交易名称
    ,o.vouchertype -- 交易日期
    ,o.vouchername -- 交易时间
    ,o.iselecseal -- 服务流水
    ,o.elecsealnum -- 受理流水
    ,o.isprtcontrol -- 包流水
    ,o.prtcontrolnum -- 核心日期
    ,o.prtseqno -- 核心时间
    ,o.prtnum -- 通讯流水
    ,o.prtdate -- ip
    ,o.prtbranch -- oid
    ,o.prtreason -- 后台流水
    ,o.prtmsg -- 交易状态
    ,o.print_telr_no -- 返回码
    ,o.prompt -- 返回描述
    ,o.rprint_telr_no -- 交易路径
    ,o.rprint_dt -- 交易数据
    ,o.rprint_tms -- 任务id
    ,o.rprint_auth_telr_no -- 影像id
    ,o.rprint_typ_cd -- 客户类型
    ,o.rprint_rsn -- 客户号
    ,o.note1 -- 证件类型
    ,o.note2 -- 证件号
    ,o.blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
    ,o.blendingtype -- 勾兑方式 0-手动，1-自动
    ,o.blip_id -- 影像编号
    ,o.prttype -- 打印类型|
    ,o.app_num -- 
    ,o.blendingdesc -- 
    ,o.blip_seq -- 
    ,o.cheanflag -- 
    ,o.sealtype -- 印章类型
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
from ${iol_schema}.nibs_ib_log_printvoucher_log_bk o
    left join ${iol_schema}.nibs_ib_log_printvoucher_log_op n
        on
            o.pr_sn = n.pr_sn
            and o.tx_seq_num = n.tx_seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_log_printvoucher_log_cl d
        on
            o.pr_sn = d.pr_sn
            and o.tx_seq_num = d.tx_seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_log_printvoucher_log;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_log_printvoucher_log') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_log_printvoucher_log drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_log_printvoucher_log add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_log_printvoucher_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_printvoucher_log_cl;
alter table ${iol_schema}.nibs_ib_log_printvoucher_log exchange partition p_20991231 with table ${iol_schema}.nibs_ib_log_printvoucher_log_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_printvoucher_log to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log_op purge;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_printvoucher_log',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
