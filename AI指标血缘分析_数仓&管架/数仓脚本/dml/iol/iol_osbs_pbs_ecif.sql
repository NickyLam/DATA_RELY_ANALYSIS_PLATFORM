/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_ecif
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
create table ${iol_schema}.osbs_pbs_ecif_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_ecif
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_ecif_op purge;
drop table ${iol_schema}.osbs_pbs_ecif_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_ecif_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_ecif where 0=1;

create table ${iol_schema}.osbs_pbs_ecif_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_ecif where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_ecif_cl(
            pei_ecifno -- 全行统一客户号
            ,pei_userno -- 用户顺序号
            ,pei_state -- 状态
            ,pei_opendate -- 开户日期
            ,pei_cllosedate -- 注销日期
            ,pei_staffflag -- 是否行内员工
            ,pei_namecn -- 客户姓名
            ,pei_nameen -- 客户英文名
            ,pei_ctftype -- 证件类型
            ,pei_ctfno -- 证件号
            ,pei_address -- 联系地址
            ,pei_phone -- 联系电话
            ,pei_zipcode -- 邮政编码
            ,pei_email -- 邮箱
            ,pei_mobile -- 手机号码
            ,pei_sex -- 性别
            ,pei_tel -- 办公电话
            ,pei_bankid -- 银行编码
            ,pei_bankname -- 银行名称
            ,pei_branchid -- 分行号
            ,pei_branchname -- 分行名称
            ,pei_deptid -- 机构号
            ,pei_deptname -- 机构名称
            ,pei_nationality -- 国家
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_ecif_op(
            pei_ecifno -- 全行统一客户号
            ,pei_userno -- 用户顺序号
            ,pei_state -- 状态
            ,pei_opendate -- 开户日期
            ,pei_cllosedate -- 注销日期
            ,pei_staffflag -- 是否行内员工
            ,pei_namecn -- 客户姓名
            ,pei_nameen -- 客户英文名
            ,pei_ctftype -- 证件类型
            ,pei_ctfno -- 证件号
            ,pei_address -- 联系地址
            ,pei_phone -- 联系电话
            ,pei_zipcode -- 邮政编码
            ,pei_email -- 邮箱
            ,pei_mobile -- 手机号码
            ,pei_sex -- 性别
            ,pei_tel -- 办公电话
            ,pei_bankid -- 银行编码
            ,pei_bankname -- 银行名称
            ,pei_branchid -- 分行号
            ,pei_branchname -- 分行名称
            ,pei_deptid -- 机构号
            ,pei_deptname -- 机构名称
            ,pei_nationality -- 国家
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pei_ecifno, o.pei_ecifno) as pei_ecifno -- 全行统一客户号
    ,nvl(n.pei_userno, o.pei_userno) as pei_userno -- 用户顺序号
    ,nvl(n.pei_state, o.pei_state) as pei_state -- 状态
    ,nvl(n.pei_opendate, o.pei_opendate) as pei_opendate -- 开户日期
    ,nvl(n.pei_cllosedate, o.pei_cllosedate) as pei_cllosedate -- 注销日期
    ,nvl(n.pei_staffflag, o.pei_staffflag) as pei_staffflag -- 是否行内员工
    ,nvl(n.pei_namecn, o.pei_namecn) as pei_namecn -- 客户姓名
    ,nvl(n.pei_nameen, o.pei_nameen) as pei_nameen -- 客户英文名
    ,nvl(n.pei_ctftype, o.pei_ctftype) as pei_ctftype -- 证件类型
    ,nvl(n.pei_ctfno, o.pei_ctfno) as pei_ctfno -- 证件号
    ,nvl(n.pei_address, o.pei_address) as pei_address -- 联系地址
    ,nvl(n.pei_phone, o.pei_phone) as pei_phone -- 联系电话
    ,nvl(n.pei_zipcode, o.pei_zipcode) as pei_zipcode -- 邮政编码
    ,nvl(n.pei_email, o.pei_email) as pei_email -- 邮箱
    ,nvl(n.pei_mobile, o.pei_mobile) as pei_mobile -- 手机号码
    ,nvl(n.pei_sex, o.pei_sex) as pei_sex -- 性别
    ,nvl(n.pei_tel, o.pei_tel) as pei_tel -- 办公电话
    ,nvl(n.pei_bankid, o.pei_bankid) as pei_bankid -- 银行编码
    ,nvl(n.pei_bankname, o.pei_bankname) as pei_bankname -- 银行名称
    ,nvl(n.pei_branchid, o.pei_branchid) as pei_branchid -- 分行号
    ,nvl(n.pei_branchname, o.pei_branchname) as pei_branchname -- 分行名称
    ,nvl(n.pei_deptid, o.pei_deptid) as pei_deptid -- 机构号
    ,nvl(n.pei_deptname, o.pei_deptname) as pei_deptname -- 机构名称
    ,nvl(n.pei_nationality, o.pei_nationality) as pei_nationality -- 国家
    ,case when
            n.pei_ecifno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pei_ecifno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pei_ecifno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_ecif_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_ecif where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pei_ecifno = n.pei_ecifno
where (
        o.pei_ecifno is null
    )
    or (
        n.pei_ecifno is null
    )
    or (
        o.pei_userno <> n.pei_userno
        or o.pei_state <> n.pei_state
        or o.pei_opendate <> n.pei_opendate
        or o.pei_cllosedate <> n.pei_cllosedate
        or o.pei_staffflag <> n.pei_staffflag
        or o.pei_namecn <> n.pei_namecn
        or o.pei_nameen <> n.pei_nameen
        or o.pei_ctftype <> n.pei_ctftype
        or o.pei_ctfno <> n.pei_ctfno
        or o.pei_address <> n.pei_address
        or o.pei_phone <> n.pei_phone
        or o.pei_zipcode <> n.pei_zipcode
        or o.pei_email <> n.pei_email
        or o.pei_mobile <> n.pei_mobile
        or o.pei_sex <> n.pei_sex
        or o.pei_tel <> n.pei_tel
        or o.pei_bankid <> n.pei_bankid
        or o.pei_bankname <> n.pei_bankname
        or o.pei_branchid <> n.pei_branchid
        or o.pei_branchname <> n.pei_branchname
        or o.pei_deptid <> n.pei_deptid
        or o.pei_deptname <> n.pei_deptname
        or o.pei_nationality <> n.pei_nationality
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_ecif_cl(
            pei_ecifno -- 全行统一客户号
            ,pei_userno -- 用户顺序号
            ,pei_state -- 状态
            ,pei_opendate -- 开户日期
            ,pei_cllosedate -- 注销日期
            ,pei_staffflag -- 是否行内员工
            ,pei_namecn -- 客户姓名
            ,pei_nameen -- 客户英文名
            ,pei_ctftype -- 证件类型
            ,pei_ctfno -- 证件号
            ,pei_address -- 联系地址
            ,pei_phone -- 联系电话
            ,pei_zipcode -- 邮政编码
            ,pei_email -- 邮箱
            ,pei_mobile -- 手机号码
            ,pei_sex -- 性别
            ,pei_tel -- 办公电话
            ,pei_bankid -- 银行编码
            ,pei_bankname -- 银行名称
            ,pei_branchid -- 分行号
            ,pei_branchname -- 分行名称
            ,pei_deptid -- 机构号
            ,pei_deptname -- 机构名称
            ,pei_nationality -- 国家
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_ecif_op(
            pei_ecifno -- 全行统一客户号
            ,pei_userno -- 用户顺序号
            ,pei_state -- 状态
            ,pei_opendate -- 开户日期
            ,pei_cllosedate -- 注销日期
            ,pei_staffflag -- 是否行内员工
            ,pei_namecn -- 客户姓名
            ,pei_nameen -- 客户英文名
            ,pei_ctftype -- 证件类型
            ,pei_ctfno -- 证件号
            ,pei_address -- 联系地址
            ,pei_phone -- 联系电话
            ,pei_zipcode -- 邮政编码
            ,pei_email -- 邮箱
            ,pei_mobile -- 手机号码
            ,pei_sex -- 性别
            ,pei_tel -- 办公电话
            ,pei_bankid -- 银行编码
            ,pei_bankname -- 银行名称
            ,pei_branchid -- 分行号
            ,pei_branchname -- 分行名称
            ,pei_deptid -- 机构号
            ,pei_deptname -- 机构名称
            ,pei_nationality -- 国家
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pei_ecifno -- 全行统一客户号
    ,o.pei_userno -- 用户顺序号
    ,o.pei_state -- 状态
    ,o.pei_opendate -- 开户日期
    ,o.pei_cllosedate -- 注销日期
    ,o.pei_staffflag -- 是否行内员工
    ,o.pei_namecn -- 客户姓名
    ,o.pei_nameen -- 客户英文名
    ,o.pei_ctftype -- 证件类型
    ,o.pei_ctfno -- 证件号
    ,o.pei_address -- 联系地址
    ,o.pei_phone -- 联系电话
    ,o.pei_zipcode -- 邮政编码
    ,o.pei_email -- 邮箱
    ,o.pei_mobile -- 手机号码
    ,o.pei_sex -- 性别
    ,o.pei_tel -- 办公电话
    ,o.pei_bankid -- 银行编码
    ,o.pei_bankname -- 银行名称
    ,o.pei_branchid -- 分行号
    ,o.pei_branchname -- 分行名称
    ,o.pei_deptid -- 机构号
    ,o.pei_deptname -- 机构名称
    ,o.pei_nationality -- 国家
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
from ${iol_schema}.osbs_pbs_ecif_bk o
    left join ${iol_schema}.osbs_pbs_ecif_op n
        on
            o.pei_ecifno = n.pei_ecifno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_ecif_cl d
        on
            o.pei_ecifno = d.pei_ecifno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_pbs_ecif;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_pbs_ecif') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_pbs_ecif drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_pbs_ecif add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_pbs_ecif exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_ecif_cl;
alter table ${iol_schema}.osbs_pbs_ecif exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_ecif_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_ecif to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_ecif_op purge;
drop table ${iol_schema}.osbs_pbs_ecif_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_ecif_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_ecif',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
