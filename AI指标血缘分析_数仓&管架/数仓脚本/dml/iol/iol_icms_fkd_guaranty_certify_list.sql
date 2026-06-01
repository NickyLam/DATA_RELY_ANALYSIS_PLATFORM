/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_guaranty_certify_list
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
create table ${iol_schema}.icms_fkd_guaranty_certify_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_guaranty_certify_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list_op purge;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_guaranty_certify_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_guaranty_certify_list where 0=1;

create table ${iol_schema}.icms_fkd_guaranty_certify_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_guaranty_certify_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_guaranty_certify_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,warrantsduedt -- 到期日
            ,guarantyimmovables -- 权属人不动产共有情况
            ,guarantyperiodint -- 使用年限
            ,guarantyrightid -- 房权证号
            ,guarantyamount -- 土地面积
            ,projectid -- 楼盘编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyownshare -- 权属人共有份额
            ,guarantydate -- 土地使用权起始日期
            ,pledgepkno -- 质押物信息表主键
            ,guarantycertify -- 权属证明
            ,guarantypurpers -- 土地用途
            ,warrantstyp -- 权证类型
            ,guarantyname -- 权属人名称
            ,guarantyidno -- 权属人身份证号
            ,guarantylocation -- 土地位置
            ,guarantyid -- 权属人编号
            ,guarantytype -- 权利人类型
            ,guarantycerttype -- 权利人证件类型
            ,guarantyrelative -- 权利人与借款人关系
            ,guarantytelno -- 权利人手机号码
            ,guarantycertmaturity -- 证件号码到期日
            ,guarantytradematurity -- 抵押企业营业期限到期日
            ,guarantymarriage -- 权利人婚姻状况
            ,guarantysex -- 权利人性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_guaranty_certify_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,warrantsduedt -- 到期日
            ,guarantyimmovables -- 权属人不动产共有情况
            ,guarantyperiodint -- 使用年限
            ,guarantyrightid -- 房权证号
            ,guarantyamount -- 土地面积
            ,projectid -- 楼盘编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyownshare -- 权属人共有份额
            ,guarantydate -- 土地使用权起始日期
            ,pledgepkno -- 质押物信息表主键
            ,guarantycertify -- 权属证明
            ,guarantypurpers -- 土地用途
            ,warrantstyp -- 权证类型
            ,guarantyname -- 权属人名称
            ,guarantyidno -- 权属人身份证号
            ,guarantylocation -- 土地位置
            ,guarantyid -- 权属人编号
            ,guarantytype -- 权利人类型
            ,guarantycerttype -- 权利人证件类型
            ,guarantyrelative -- 权利人与借款人关系
            ,guarantytelno -- 权利人手机号码
            ,guarantycertmaturity -- 证件号码到期日
            ,guarantytradematurity -- 抵押企业营业期限到期日
            ,guarantymarriage -- 权利人婚姻状况
            ,guarantysex -- 权利人性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 业务流水号
    ,nvl(n.warrantsduedt, o.warrantsduedt) as warrantsduedt -- 到期日
    ,nvl(n.guarantyimmovables, o.guarantyimmovables) as guarantyimmovables -- 权属人不动产共有情况
    ,nvl(n.guarantyperiodint, o.guarantyperiodint) as guarantyperiodint -- 使用年限
    ,nvl(n.guarantyrightid, o.guarantyrightid) as guarantyrightid -- 房权证号
    ,nvl(n.guarantyamount, o.guarantyamount) as guarantyamount -- 土地面积
    ,nvl(n.projectid, o.projectid) as projectid -- 楼盘编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.guarantyownshare, o.guarantyownshare) as guarantyownshare -- 权属人共有份额
    ,nvl(n.guarantydate, o.guarantydate) as guarantydate -- 土地使用权起始日期
    ,nvl(n.pledgepkno, o.pledgepkno) as pledgepkno -- 质押物信息表主键
    ,nvl(n.guarantycertify, o.guarantycertify) as guarantycertify -- 权属证明
    ,nvl(n.guarantypurpers, o.guarantypurpers) as guarantypurpers -- 土地用途
    ,nvl(n.warrantstyp, o.warrantstyp) as warrantstyp -- 权证类型
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- 权属人名称
    ,nvl(n.guarantyidno, o.guarantyidno) as guarantyidno -- 权属人身份证号
    ,nvl(n.guarantylocation, o.guarantylocation) as guarantylocation -- 土地位置
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 权属人编号
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 权利人类型
    ,nvl(n.guarantycerttype, o.guarantycerttype) as guarantycerttype -- 权利人证件类型
    ,nvl(n.guarantyrelative, o.guarantyrelative) as guarantyrelative -- 权利人与借款人关系
    ,nvl(n.guarantytelno, o.guarantytelno) as guarantytelno -- 权利人手机号码
    ,nvl(n.guarantycertmaturity, o.guarantycertmaturity) as guarantycertmaturity -- 证件号码到期日
    ,nvl(n.guarantytradematurity, o.guarantytradematurity) as guarantytradematurity -- 抵押企业营业期限到期日
    ,nvl(n.guarantymarriage, o.guarantymarriage) as guarantymarriage -- 权利人婚姻状况
    ,nvl(n.guarantysex, o.guarantysex) as guarantysex -- 权利人性别
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fkd_guaranty_certify_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_guaranty_certify_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeserialno <> n.relativeserialno
        or o.warrantsduedt <> n.warrantsduedt
        or o.guarantyimmovables <> n.guarantyimmovables
        or o.guarantyperiodint <> n.guarantyperiodint
        or o.guarantyrightid <> n.guarantyrightid
        or o.guarantyamount <> n.guarantyamount
        or o.projectid <> n.projectid
        or o.migtflag <> n.migtflag
        or o.guarantyownshare <> n.guarantyownshare
        or o.guarantydate <> n.guarantydate
        or o.pledgepkno <> n.pledgepkno
        or o.guarantycertify <> n.guarantycertify
        or o.guarantypurpers <> n.guarantypurpers
        or o.warrantstyp <> n.warrantstyp
        or o.guarantyname <> n.guarantyname
        or o.guarantyidno <> n.guarantyidno
        or o.guarantylocation <> n.guarantylocation
        or o.guarantyid <> n.guarantyid
        or o.guarantytype <> n.guarantytype
        or o.guarantycerttype <> n.guarantycerttype
        or o.guarantyrelative <> n.guarantyrelative
        or o.guarantytelno <> n.guarantytelno
        or o.guarantycertmaturity <> n.guarantycertmaturity
        or o.guarantytradematurity <> n.guarantytradematurity
        or o.guarantymarriage <> n.guarantymarriage
        or o.guarantysex <> n.guarantysex
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_guaranty_certify_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,warrantsduedt -- 到期日
            ,guarantyimmovables -- 权属人不动产共有情况
            ,guarantyperiodint -- 使用年限
            ,guarantyrightid -- 房权证号
            ,guarantyamount -- 土地面积
            ,projectid -- 楼盘编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyownshare -- 权属人共有份额
            ,guarantydate -- 土地使用权起始日期
            ,pledgepkno -- 质押物信息表主键
            ,guarantycertify -- 权属证明
            ,guarantypurpers -- 土地用途
            ,warrantstyp -- 权证类型
            ,guarantyname -- 权属人名称
            ,guarantyidno -- 权属人身份证号
            ,guarantylocation -- 土地位置
            ,guarantyid -- 权属人编号
            ,guarantytype -- 权利人类型
            ,guarantycerttype -- 权利人证件类型
            ,guarantyrelative -- 权利人与借款人关系
            ,guarantytelno -- 权利人手机号码
            ,guarantycertmaturity -- 证件号码到期日
            ,guarantytradematurity -- 抵押企业营业期限到期日
            ,guarantymarriage -- 权利人婚姻状况
            ,guarantysex -- 权利人性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_guaranty_certify_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,warrantsduedt -- 到期日
            ,guarantyimmovables -- 权属人不动产共有情况
            ,guarantyperiodint -- 使用年限
            ,guarantyrightid -- 房权证号
            ,guarantyamount -- 土地面积
            ,projectid -- 楼盘编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyownshare -- 权属人共有份额
            ,guarantydate -- 土地使用权起始日期
            ,pledgepkno -- 质押物信息表主键
            ,guarantycertify -- 权属证明
            ,guarantypurpers -- 土地用途
            ,warrantstyp -- 权证类型
            ,guarantyname -- 权属人名称
            ,guarantyidno -- 权属人身份证号
            ,guarantylocation -- 土地位置
            ,guarantyid -- 权属人编号
            ,guarantytype -- 权利人类型
            ,guarantycerttype -- 权利人证件类型
            ,guarantyrelative -- 权利人与借款人关系
            ,guarantytelno -- 权利人手机号码
            ,guarantycertmaturity -- 证件号码到期日
            ,guarantytradematurity -- 抵押企业营业期限到期日
            ,guarantymarriage -- 权利人婚姻状况
            ,guarantysex -- 权利人性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.relativeserialno -- 业务流水号
    ,o.warrantsduedt -- 到期日
    ,o.guarantyimmovables -- 权属人不动产共有情况
    ,o.guarantyperiodint -- 使用年限
    ,o.guarantyrightid -- 房权证号
    ,o.guarantyamount -- 土地面积
    ,o.projectid -- 楼盘编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.guarantyownshare -- 权属人共有份额
    ,o.guarantydate -- 土地使用权起始日期
    ,o.pledgepkno -- 质押物信息表主键
    ,o.guarantycertify -- 权属证明
    ,o.guarantypurpers -- 土地用途
    ,o.warrantstyp -- 权证类型
    ,o.guarantyname -- 权属人名称
    ,o.guarantyidno -- 权属人身份证号
    ,o.guarantylocation -- 土地位置
    ,o.guarantyid -- 权属人编号
    ,o.guarantytype -- 权利人类型
    ,o.guarantycerttype -- 权利人证件类型
    ,o.guarantyrelative -- 权利人与借款人关系
    ,o.guarantytelno -- 权利人手机号码
    ,o.guarantycertmaturity -- 证件号码到期日
    ,o.guarantytradematurity -- 抵押企业营业期限到期日
    ,o.guarantymarriage -- 权利人婚姻状况
    ,o.guarantysex -- 权利人性别
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
from ${iol_schema}.icms_fkd_guaranty_certify_list_bk o
    left join ${iol_schema}.icms_fkd_guaranty_certify_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_guaranty_certify_list_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fkd_guaranty_certify_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_guaranty_certify_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_guaranty_certify_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_guaranty_certify_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_guaranty_certify_list exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_guaranty_certify_list_cl;
alter table ${iol_schema}.icms_fkd_guaranty_certify_list exchange partition p_20991231 with table ${iol_schema}.icms_fkd_guaranty_certify_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_guaranty_certify_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list_op purge;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_guaranty_certify_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_guaranty_certify_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
