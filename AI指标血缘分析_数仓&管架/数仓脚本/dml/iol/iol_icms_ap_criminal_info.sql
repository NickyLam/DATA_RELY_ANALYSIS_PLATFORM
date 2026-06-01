/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_criminal_info
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
create table ${iol_schema}.icms_ap_criminal_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_criminal_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_criminal_info_op purge;
drop table ${iol_schema}.icms_ap_criminal_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_criminal_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_criminal_info where 0=1;

create table ${iol_schema}.icms_ap_criminal_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_criminal_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_criminal_info_cl(
            criminalno -- 案件编号
            ,prosecutionorgans -- 起诉机关
            ,committalcharge -- 起诉罪名
            ,updatedate -- 更新日期
            ,objectno -- 关联案件编号
            ,acceptancecourt -- 受理法院
            ,tmsp -- 时间戳
            ,defendant -- 被告
            ,updateorgid -- 更新机构
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,litigationoutcome -- 诉讼结果简述
            ,fileno -- 判决书影像
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,defendantid -- 被告人编号
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_criminal_info_op(
            criminalno -- 案件编号
            ,prosecutionorgans -- 起诉机关
            ,committalcharge -- 起诉罪名
            ,updatedate -- 更新日期
            ,objectno -- 关联案件编号
            ,acceptancecourt -- 受理法院
            ,tmsp -- 时间戳
            ,defendant -- 被告
            ,updateorgid -- 更新机构
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,litigationoutcome -- 诉讼结果简述
            ,fileno -- 判决书影像
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,defendantid -- 被告人编号
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.criminalno, o.criminalno) as criminalno -- 案件编号
    ,nvl(n.prosecutionorgans, o.prosecutionorgans) as prosecutionorgans -- 起诉机关
    ,nvl(n.committalcharge, o.committalcharge) as committalcharge -- 起诉罪名
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.objectno, o.objectno) as objectno -- 关联案件编号
    ,nvl(n.acceptancecourt, o.acceptancecourt) as acceptancecourt -- 受理法院
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.defendant, o.defendant) as defendant -- 被告
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.litigationoutcome, o.litigationoutcome) as litigationoutcome -- 诉讼结果简述
    ,nvl(n.fileno, o.fileno) as fileno -- 判决书影像
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.defendantid, o.defendantid) as defendantid -- 被告人编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,case when
            n.criminalno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.criminalno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.criminalno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_criminal_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_criminal_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.criminalno = n.criminalno
where (
        o.criminalno is null
    )
    or (
        n.criminalno is null
    )
    or (
        o.prosecutionorgans <> n.prosecutionorgans
        or o.committalcharge <> n.committalcharge
        or o.updatedate <> n.updatedate
        or o.objectno <> n.objectno
        or o.acceptancecourt <> n.acceptancecourt
        or o.tmsp <> n.tmsp
        or o.defendant <> n.defendant
        or o.updateorgid <> n.updateorgid
        or o.caseprogramstage <> n.caseprogramstage
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.litigationoutcome <> n.litigationoutcome
        or o.fileno <> n.fileno
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.defendantid <> n.defendantid
        or o.updateuserid <> n.updateuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_criminal_info_cl(
            criminalno -- 案件编号
            ,prosecutionorgans -- 起诉机关
            ,committalcharge -- 起诉罪名
            ,updatedate -- 更新日期
            ,objectno -- 关联案件编号
            ,acceptancecourt -- 受理法院
            ,tmsp -- 时间戳
            ,defendant -- 被告
            ,updateorgid -- 更新机构
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,litigationoutcome -- 诉讼结果简述
            ,fileno -- 判决书影像
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,defendantid -- 被告人编号
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_criminal_info_op(
            criminalno -- 案件编号
            ,prosecutionorgans -- 起诉机关
            ,committalcharge -- 起诉罪名
            ,updatedate -- 更新日期
            ,objectno -- 关联案件编号
            ,acceptancecourt -- 受理法院
            ,tmsp -- 时间戳
            ,defendant -- 被告
            ,updateorgid -- 更新机构
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,litigationoutcome -- 诉讼结果简述
            ,fileno -- 判决书影像
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,defendantid -- 被告人编号
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.criminalno -- 案件编号
    ,o.prosecutionorgans -- 起诉机关
    ,o.committalcharge -- 起诉罪名
    ,o.updatedate -- 更新日期
    ,o.objectno -- 关联案件编号
    ,o.acceptancecourt -- 受理法院
    ,o.tmsp -- 时间戳
    ,o.defendant -- 被告
    ,o.updateorgid -- 更新机构
    ,o.caseprogramstage -- 程序阶段
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.litigationoutcome -- 诉讼结果简述
    ,o.fileno -- 判决书影像
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.defendantid -- 被告人编号
    ,o.updateuserid -- 更新人
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
from ${iol_schema}.icms_ap_criminal_info_bk o
    left join ${iol_schema}.icms_ap_criminal_info_op n
        on
            o.criminalno = n.criminalno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_criminal_info_cl d
        on
            o.criminalno = d.criminalno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_criminal_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_criminal_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_criminal_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_criminal_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_criminal_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_criminal_info_cl;
alter table ${iol_schema}.icms_ap_criminal_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_criminal_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_criminal_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_criminal_info_op purge;
drop table ${iol_schema}.icms_ap_criminal_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_criminal_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_criminal_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
