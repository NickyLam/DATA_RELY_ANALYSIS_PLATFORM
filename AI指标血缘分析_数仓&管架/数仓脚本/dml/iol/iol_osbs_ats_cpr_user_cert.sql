/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ats_cpr_user_cert
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
create table ${iol_schema}.osbs_ats_cpr_user_cert_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_ats_cpr_user_cert;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_cpr_user_cert_op purge;
drop table ${iol_schema}.osbs_ats_cpr_user_cert_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_cpr_user_cert_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_cpr_user_cert where 0=1;

create table ${iol_schema}.osbs_ats_cpr_user_cert_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_cpr_user_cert where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_cpr_user_cert_cl(
            cuc_certdn -- 证书DN
            ,cuc_ecifno -- 企业顺序号
            ,cuc_userno -- 企业用户顺序号
            ,cuc_serialno -- 证书序列号
            ,cuc_certrefno -- 证书参考号
            ,cuc_certauthcode -- 证书授权号
            ,cuc_issuerdn -- 证书发行商DN
            ,cuc_applydate -- 证书申请日期
            ,cuc_usbkeysn -- USBKEY序号
            ,cuc_usbkeyflag -- 是否使用USBKEY
            ,cuc_certstate -- 证书状态
            ,cuc_closedate -- 证书销户日期
            ,cuc_toolopendate -- 工具开通日期
            ,cuc_toolclosedate -- 工具关闭日期
            ,cuc_vendorid -- 厂商号(0飞天)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_cpr_user_cert_op(
            cuc_certdn -- 证书DN
            ,cuc_ecifno -- 企业顺序号
            ,cuc_userno -- 企业用户顺序号
            ,cuc_serialno -- 证书序列号
            ,cuc_certrefno -- 证书参考号
            ,cuc_certauthcode -- 证书授权号
            ,cuc_issuerdn -- 证书发行商DN
            ,cuc_applydate -- 证书申请日期
            ,cuc_usbkeysn -- USBKEY序号
            ,cuc_usbkeyflag -- 是否使用USBKEY
            ,cuc_certstate -- 证书状态
            ,cuc_closedate -- 证书销户日期
            ,cuc_toolopendate -- 工具开通日期
            ,cuc_toolclosedate -- 工具关闭日期
            ,cuc_vendorid -- 厂商号(0飞天)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cuc_certdn, o.cuc_certdn) as cuc_certdn -- 证书DN
    ,nvl(n.cuc_ecifno, o.cuc_ecifno) as cuc_ecifno -- 企业顺序号
    ,nvl(n.cuc_userno, o.cuc_userno) as cuc_userno -- 企业用户顺序号
    ,nvl(n.cuc_serialno, o.cuc_serialno) as cuc_serialno -- 证书序列号
    ,nvl(n.cuc_certrefno, o.cuc_certrefno) as cuc_certrefno -- 证书参考号
    ,nvl(n.cuc_certauthcode, o.cuc_certauthcode) as cuc_certauthcode -- 证书授权号
    ,nvl(n.cuc_issuerdn, o.cuc_issuerdn) as cuc_issuerdn -- 证书发行商DN
    ,nvl(n.cuc_applydate, o.cuc_applydate) as cuc_applydate -- 证书申请日期
    ,nvl(n.cuc_usbkeysn, o.cuc_usbkeysn) as cuc_usbkeysn -- USBKEY序号
    ,nvl(n.cuc_usbkeyflag, o.cuc_usbkeyflag) as cuc_usbkeyflag -- 是否使用USBKEY
    ,nvl(n.cuc_certstate, o.cuc_certstate) as cuc_certstate -- 证书状态
    ,nvl(n.cuc_closedate, o.cuc_closedate) as cuc_closedate -- 证书销户日期
    ,nvl(n.cuc_toolopendate, o.cuc_toolopendate) as cuc_toolopendate -- 工具开通日期
    ,nvl(n.cuc_toolclosedate, o.cuc_toolclosedate) as cuc_toolclosedate -- 工具关闭日期
    ,nvl(n.cuc_vendorid, o.cuc_vendorid) as cuc_vendorid -- 厂商号(0飞天)
    ,case when
            n.cuc_certdn is null
            and n.cuc_ecifno is null
            and n.cuc_userno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cuc_certdn is null
            and n.cuc_ecifno is null
            and n.cuc_userno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cuc_certdn is null
            and n.cuc_ecifno is null
            and n.cuc_userno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_ats_cpr_user_cert_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_ats_cpr_user_cert where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cuc_certdn = n.cuc_certdn
            and o.cuc_ecifno = n.cuc_ecifno
            and o.cuc_userno = n.cuc_userno
where (
        o.cuc_certdn is null
        and o.cuc_ecifno is null
        and o.cuc_userno is null
    )
    or (
        n.cuc_certdn is null
        and n.cuc_ecifno is null
        and n.cuc_userno is null
    )
    or (
        o.cuc_serialno <> n.cuc_serialno
        or o.cuc_certrefno <> n.cuc_certrefno
        or o.cuc_certauthcode <> n.cuc_certauthcode
        or o.cuc_issuerdn <> n.cuc_issuerdn
        or o.cuc_applydate <> n.cuc_applydate
        or o.cuc_usbkeysn <> n.cuc_usbkeysn
        or o.cuc_usbkeyflag <> n.cuc_usbkeyflag
        or o.cuc_certstate <> n.cuc_certstate
        or o.cuc_closedate <> n.cuc_closedate
        or o.cuc_toolopendate <> n.cuc_toolopendate
        or o.cuc_toolclosedate <> n.cuc_toolclosedate
        or o.cuc_vendorid <> n.cuc_vendorid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_cpr_user_cert_cl(
            cuc_certdn -- 证书DN
            ,cuc_ecifno -- 企业顺序号
            ,cuc_userno -- 企业用户顺序号
            ,cuc_serialno -- 证书序列号
            ,cuc_certrefno -- 证书参考号
            ,cuc_certauthcode -- 证书授权号
            ,cuc_issuerdn -- 证书发行商DN
            ,cuc_applydate -- 证书申请日期
            ,cuc_usbkeysn -- USBKEY序号
            ,cuc_usbkeyflag -- 是否使用USBKEY
            ,cuc_certstate -- 证书状态
            ,cuc_closedate -- 证书销户日期
            ,cuc_toolopendate -- 工具开通日期
            ,cuc_toolclosedate -- 工具关闭日期
            ,cuc_vendorid -- 厂商号(0飞天)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_cpr_user_cert_op(
            cuc_certdn -- 证书DN
            ,cuc_ecifno -- 企业顺序号
            ,cuc_userno -- 企业用户顺序号
            ,cuc_serialno -- 证书序列号
            ,cuc_certrefno -- 证书参考号
            ,cuc_certauthcode -- 证书授权号
            ,cuc_issuerdn -- 证书发行商DN
            ,cuc_applydate -- 证书申请日期
            ,cuc_usbkeysn -- USBKEY序号
            ,cuc_usbkeyflag -- 是否使用USBKEY
            ,cuc_certstate -- 证书状态
            ,cuc_closedate -- 证书销户日期
            ,cuc_toolopendate -- 工具开通日期
            ,cuc_toolclosedate -- 工具关闭日期
            ,cuc_vendorid -- 厂商号(0飞天)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cuc_certdn -- 证书DN
    ,o.cuc_ecifno -- 企业顺序号
    ,o.cuc_userno -- 企业用户顺序号
    ,o.cuc_serialno -- 证书序列号
    ,o.cuc_certrefno -- 证书参考号
    ,o.cuc_certauthcode -- 证书授权号
    ,o.cuc_issuerdn -- 证书发行商DN
    ,o.cuc_applydate -- 证书申请日期
    ,o.cuc_usbkeysn -- USBKEY序号
    ,o.cuc_usbkeyflag -- 是否使用USBKEY
    ,o.cuc_certstate -- 证书状态
    ,o.cuc_closedate -- 证书销户日期
    ,o.cuc_toolopendate -- 工具开通日期
    ,o.cuc_toolclosedate -- 工具关闭日期
    ,o.cuc_vendorid -- 厂商号(0飞天)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_ats_cpr_user_cert_bk o
    left join ${iol_schema}.osbs_ats_cpr_user_cert_op n
        on
            o.cuc_certdn = n.cuc_certdn
            and o.cuc_ecifno = n.cuc_ecifno
            and o.cuc_userno = n.cuc_userno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_ats_cpr_user_cert_cl d
        on
            o.cuc_certdn = d.cuc_certdn
            and o.cuc_ecifno = d.cuc_ecifno
            and o.cuc_userno = d.cuc_userno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_ats_cpr_user_cert;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_ats_cpr_user_cert exchange partition p_19000101 with table ${iol_schema}.osbs_ats_cpr_user_cert_cl;
alter table ${iol_schema}.osbs_ats_cpr_user_cert exchange partition p_20991231 with table ${iol_schema}.osbs_ats_cpr_user_cert_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ats_cpr_user_cert to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_cpr_user_cert_op purge;
drop table ${iol_schema}.osbs_ats_cpr_user_cert_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_ats_cpr_user_cert_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ats_cpr_user_cert',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
