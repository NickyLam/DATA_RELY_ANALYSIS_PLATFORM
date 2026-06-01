/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a86mpanmapinfo
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
create table ${iol_schema}.mpcs_a86mpanmapinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a86mpanmapinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a86mpanmapinfo_op purge;
drop table ${iol_schema}.mpcs_a86mpanmapinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a86mpanmapinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a86mpanmapinfo where 0=1;

create table ${iol_schema}.mpcs_a86mpanmapinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a86mpanmapinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a86mpanmapinfo_cl(
            transtime -- 操作时间
            ,custno -- 客户号
            ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
            ,seid -- 用户移动设备中安全芯片所对应的标识符
            ,span -- 用户用于移动设备加申请的标准卡主账号
            ,spanid -- 用户标准卡主账号对应的标识符
            ,mpan -- 用户成功加载的移动设备卡主账号
            ,mpanid -- 用户移动设备卡主账号对应的标识符
            ,mstpan -- 用户成功加载的移动mst设备卡主账号
            ,mstpanid -- 用户移动mst设备卡主账号对应的标识符
            ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
            ,mpanpersoresult -- mpan应用个人化执行结果
            ,custname -- 持卡人姓名
            ,phone -- 预留手机号码
            ,opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
            ,quota -- 初始免密限额
            ,setype -- 前4位 1011 apple产品  0011全手机模式
            ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
            ,termconditionid -- 协议和条款对应的id
            ,termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
            ,cardartid -- 卡面配置方案id
            ,invaluedate -- 有效期
            ,storeidentifier -- 银行返回的bank app应用商店标识符
            ,applicationid -- 该卡对应的application id列表
            ,otpresolutionid -- otp方法所对应的标识号
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,remark7 -- 
            ,remark8 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a86mpanmapinfo_op(
            transtime -- 操作时间
            ,custno -- 客户号
            ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
            ,seid -- 用户移动设备中安全芯片所对应的标识符
            ,span -- 用户用于移动设备加申请的标准卡主账号
            ,spanid -- 用户标准卡主账号对应的标识符
            ,mpan -- 用户成功加载的移动设备卡主账号
            ,mpanid -- 用户移动设备卡主账号对应的标识符
            ,mstpan -- 用户成功加载的移动mst设备卡主账号
            ,mstpanid -- 用户移动mst设备卡主账号对应的标识符
            ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
            ,mpanpersoresult -- mpan应用个人化执行结果
            ,custname -- 持卡人姓名
            ,phone -- 预留手机号码
            ,opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
            ,quota -- 初始免密限额
            ,setype -- 前4位 1011 apple产品  0011全手机模式
            ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
            ,termconditionid -- 协议和条款对应的id
            ,termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
            ,cardartid -- 卡面配置方案id
            ,invaluedate -- 有效期
            ,storeidentifier -- 银行返回的bank app应用商店标识符
            ,applicationid -- 该卡对应的application id列表
            ,otpresolutionid -- otp方法所对应的标识号
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,remark7 -- 
            ,remark8 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transtime, o.transtime) as transtime -- 操作时间
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.paysys, o.paysys) as paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,nvl(n.seid, o.seid) as seid -- 用户移动设备中安全芯片所对应的标识符
    ,nvl(n.span, o.span) as span -- 用户用于移动设备加申请的标准卡主账号
    ,nvl(n.spanid, o.spanid) as spanid -- 用户标准卡主账号对应的标识符
    ,nvl(n.mpan, o.mpan) as mpan -- 用户成功加载的移动设备卡主账号
    ,nvl(n.mpanid, o.mpanid) as mpanid -- 用户移动设备卡主账号对应的标识符
    ,nvl(n.mstpan, o.mstpan) as mstpan -- 用户成功加载的移动mst设备卡主账号
    ,nvl(n.mstpanid, o.mstpanid) as mstpanid -- 用户移动mst设备卡主账号对应的标识符
    ,nvl(n.mappingstatus, o.mappingstatus) as mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,nvl(n.mpanpersoresult, o.mpanpersoresult) as mpanpersoresult -- mpan应用个人化执行结果
    ,nvl(n.custname, o.custname) as custname -- 持卡人姓名
    ,nvl(n.phone, o.phone) as phone -- 预留手机号码
    ,nvl(n.opechannelid, o.opechannelid) as opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
    ,nvl(n.quota, o.quota) as quota -- 初始免密限额
    ,nvl(n.setype, o.setype) as setype -- 前4位 1011 apple产品  0011全手机模式
    ,nvl(n.seissuer, o.seissuer) as seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,nvl(n.termconditionid, o.termconditionid) as termconditionid -- 协议和条款对应的id
    ,nvl(n.termconditionaccepteddate, o.termconditionaccepteddate) as termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
    ,nvl(n.cardartid, o.cardartid) as cardartid -- 卡面配置方案id
    ,nvl(n.invaluedate, o.invaluedate) as invaluedate -- 有效期
    ,nvl(n.storeidentifier, o.storeidentifier) as storeidentifier -- 银行返回的bank app应用商店标识符
    ,nvl(n.applicationid, o.applicationid) as applicationid -- 该卡对应的application id列表
    ,nvl(n.otpresolutionid, o.otpresolutionid) as otpresolutionid -- otp方法所对应的标识号
    ,nvl(n.remark1, o.remark1) as remark1 -- 
    ,nvl(n.remark2, o.remark2) as remark2 -- 
    ,nvl(n.remark3, o.remark3) as remark3 -- 
    ,nvl(n.remark4, o.remark4) as remark4 -- 
    ,nvl(n.remark5, o.remark5) as remark5 -- 
    ,nvl(n.remark6, o.remark6) as remark6 -- 
    ,nvl(n.remark7, o.remark7) as remark7 -- 
    ,nvl(n.remark8, o.remark8) as remark8 -- 
    ,case when
            n.paysys is null
            and n.seid is null
            and n.span is null
            and n.spanid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.paysys is null
            and n.seid is null
            and n.span is null
            and n.spanid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.paysys is null
            and n.seid is null
            and n.span is null
            and n.spanid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a86mpanmapinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a86mpanmapinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.paysys = n.paysys
            and o.seid = n.seid
            and o.span = n.span
            and o.spanid = n.spanid
where (
        o.paysys is null
        and o.seid is null
        and o.span is null
        and o.spanid is null
    )
    or (
        n.paysys is null
        and n.seid is null
        and n.span is null
        and n.spanid is null
    )
    or (
        o.transtime <> n.transtime
        or o.custno <> n.custno
        or o.mpan <> n.mpan
        or o.mpanid <> n.mpanid
        or o.mstpan <> n.mstpan
        or o.mstpanid <> n.mstpanid
        or o.mappingstatus <> n.mappingstatus
        or o.mpanpersoresult <> n.mpanpersoresult
        or o.custname <> n.custname
        or o.phone <> n.phone
        or o.opechannelid <> n.opechannelid
        or o.quota <> n.quota
        or o.setype <> n.setype
        or o.seissuer <> n.seissuer
        or o.termconditionid <> n.termconditionid
        or o.termconditionaccepteddate <> n.termconditionaccepteddate
        or o.cardartid <> n.cardartid
        or o.invaluedate <> n.invaluedate
        or o.storeidentifier <> n.storeidentifier
        or o.applicationid <> n.applicationid
        or o.otpresolutionid <> n.otpresolutionid
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
        or o.remark5 <> n.remark5
        or o.remark6 <> n.remark6
        or o.remark7 <> n.remark7
        or o.remark8 <> n.remark8
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a86mpanmapinfo_cl(
            transtime -- 操作时间
            ,custno -- 客户号
            ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
            ,seid -- 用户移动设备中安全芯片所对应的标识符
            ,span -- 用户用于移动设备加申请的标准卡主账号
            ,spanid -- 用户标准卡主账号对应的标识符
            ,mpan -- 用户成功加载的移动设备卡主账号
            ,mpanid -- 用户移动设备卡主账号对应的标识符
            ,mstpan -- 用户成功加载的移动mst设备卡主账号
            ,mstpanid -- 用户移动mst设备卡主账号对应的标识符
            ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
            ,mpanpersoresult -- mpan应用个人化执行结果
            ,custname -- 持卡人姓名
            ,phone -- 预留手机号码
            ,opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
            ,quota -- 初始免密限额
            ,setype -- 前4位 1011 apple产品  0011全手机模式
            ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
            ,termconditionid -- 协议和条款对应的id
            ,termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
            ,cardartid -- 卡面配置方案id
            ,invaluedate -- 有效期
            ,storeidentifier -- 银行返回的bank app应用商店标识符
            ,applicationid -- 该卡对应的application id列表
            ,otpresolutionid -- otp方法所对应的标识号
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,remark7 -- 
            ,remark8 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a86mpanmapinfo_op(
            transtime -- 操作时间
            ,custno -- 客户号
            ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
            ,seid -- 用户移动设备中安全芯片所对应的标识符
            ,span -- 用户用于移动设备加申请的标准卡主账号
            ,spanid -- 用户标准卡主账号对应的标识符
            ,mpan -- 用户成功加载的移动设备卡主账号
            ,mpanid -- 用户移动设备卡主账号对应的标识符
            ,mstpan -- 用户成功加载的移动mst设备卡主账号
            ,mstpanid -- 用户移动mst设备卡主账号对应的标识符
            ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
            ,mpanpersoresult -- mpan应用个人化执行结果
            ,custname -- 持卡人姓名
            ,phone -- 预留手机号码
            ,opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
            ,quota -- 初始免密限额
            ,setype -- 前4位 1011 apple产品  0011全手机模式
            ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
            ,termconditionid -- 协议和条款对应的id
            ,termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
            ,cardartid -- 卡面配置方案id
            ,invaluedate -- 有效期
            ,storeidentifier -- 银行返回的bank app应用商店标识符
            ,applicationid -- 该卡对应的application id列表
            ,otpresolutionid -- otp方法所对应的标识号
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,remark7 -- 
            ,remark8 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transtime -- 操作时间
    ,o.custno -- 客户号
    ,o.paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,o.seid -- 用户移动设备中安全芯片所对应的标识符
    ,o.span -- 用户用于移动设备加申请的标准卡主账号
    ,o.spanid -- 用户标准卡主账号对应的标识符
    ,o.mpan -- 用户成功加载的移动设备卡主账号
    ,o.mpanid -- 用户移动设备卡主账号对应的标识符
    ,o.mstpan -- 用户成功加载的移动mst设备卡主账号
    ,o.mstpanid -- 用户移动mst设备卡主账号对应的标识符
    ,o.mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,o.mpanpersoresult -- mpan应用个人化执行结果
    ,o.custname -- 持卡人姓名
    ,o.phone -- 预留手机号码
    ,o.opechannelid -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
    ,o.quota -- 初始免密限额
    ,o.setype -- 前4位 1011 apple产品  0011全手机模式
    ,o.seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,o.termconditionid -- 协议和条款对应的id
    ,o.termconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
    ,o.cardartid -- 卡面配置方案id
    ,o.invaluedate -- 有效期
    ,o.storeidentifier -- 银行返回的bank app应用商店标识符
    ,o.applicationid -- 该卡对应的application id列表
    ,o.otpresolutionid -- otp方法所对应的标识号
    ,o.remark1 -- 
    ,o.remark2 -- 
    ,o.remark3 -- 
    ,o.remark4 -- 
    ,o.remark5 -- 
    ,o.remark6 -- 
    ,o.remark7 -- 
    ,o.remark8 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a86mpanmapinfo_bk o
    left join ${iol_schema}.mpcs_a86mpanmapinfo_op n
        on
            o.paysys = n.paysys
            and o.seid = n.seid
            and o.span = n.span
            and o.spanid = n.spanid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a86mpanmapinfo_cl d
        on
            o.paysys = d.paysys
            and o.seid = d.seid
            and o.span = d.span
            and o.spanid = d.spanid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a86mpanmapinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a86mpanmapinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a86mpanmapinfo_cl;
alter table ${iol_schema}.mpcs_a86mpanmapinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a86mpanmapinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a86mpanmapinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a86mpanmapinfo_op purge;
drop table ${iol_schema}.mpcs_a86mpanmapinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a86mpanmapinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a86mpanmapinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
