/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_doc_library
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
create table ${iol_schema}.icms_doc_library_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_doc_library
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_doc_library_op purge;
drop table ${iol_schema}.icms_doc_library_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_doc_library_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_doc_library where 0=1;

create table ${iol_schema}.icms_doc_library_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_doc_library where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_doc_library_cl(
            docno -- 文档编号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,doctitle -- 文档名称
            ,doctype -- 文档类型
            ,doclength -- 文档长度
            ,docimportance -- 文档重要性
            ,docsecret -- 文档密级
            ,docstage -- 所属阶段
            ,docsource -- 文档来源
            ,docunit -- 编制单位
            ,docdate -- 编制日期
            ,docorganizer -- 编制人
            ,dockeyword -- 文档主体词
            ,docabstract -- 文档摘要
            ,doclocation -- 文档保存位置
            ,docattribute -- 文档性质
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,olddocno -- 迁移前文档编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_doc_library_op(
            docno -- 文档编号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,doctitle -- 文档名称
            ,doctype -- 文档类型
            ,doclength -- 文档长度
            ,docimportance -- 文档重要性
            ,docsecret -- 文档密级
            ,docstage -- 所属阶段
            ,docsource -- 文档来源
            ,docunit -- 编制单位
            ,docdate -- 编制日期
            ,docorganizer -- 编制人
            ,dockeyword -- 文档主体词
            ,docabstract -- 文档摘要
            ,doclocation -- 文档保存位置
            ,docattribute -- 文档性质
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,olddocno -- 迁移前文档编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.docno, o.docno) as docno -- 文档编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.doctitle, o.doctitle) as doctitle -- 文档名称
    ,nvl(n.doctype, o.doctype) as doctype -- 文档类型
    ,nvl(n.doclength, o.doclength) as doclength -- 文档长度
    ,nvl(n.docimportance, o.docimportance) as docimportance -- 文档重要性
    ,nvl(n.docsecret, o.docsecret) as docsecret -- 文档密级
    ,nvl(n.docstage, o.docstage) as docstage -- 所属阶段
    ,nvl(n.docsource, o.docsource) as docsource -- 文档来源
    ,nvl(n.docunit, o.docunit) as docunit -- 编制单位
    ,nvl(n.docdate, o.docdate) as docdate -- 编制日期
    ,nvl(n.docorganizer, o.docorganizer) as docorganizer -- 编制人
    ,nvl(n.dockeyword, o.dockeyword) as dockeyword -- 文档主体词
    ,nvl(n.docabstract, o.docabstract) as docabstract -- 文档摘要
    ,nvl(n.doclocation, o.doclocation) as doclocation -- 文档保存位置
    ,nvl(n.docattribute, o.docattribute) as docattribute -- 文档性质
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.olddocno, o.olddocno) as olddocno -- 迁移前文档编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,case when
            n.docno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.docno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.docno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_doc_library_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_doc_library where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.docno = n.docno
where (
        o.docno is null
    )
    or (
        n.docno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.doctitle <> n.doctitle
        or o.doctype <> n.doctype
        or o.doclength <> n.doclength
        or o.docimportance <> n.docimportance
        or o.docsecret <> n.docsecret
        or o.docstage <> n.docstage
        or o.docsource <> n.docsource
        or o.docunit <> n.docunit
        or o.docdate <> n.docdate
        or o.docorganizer <> n.docorganizer
        or o.dockeyword <> n.dockeyword
        or o.docabstract <> n.docabstract
        or o.doclocation <> n.doclocation
        or o.docattribute <> n.docattribute
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.olddocno <> n.olddocno
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_doc_library_cl(
            docno -- 文档编号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,doctitle -- 文档名称
            ,doctype -- 文档类型
            ,doclength -- 文档长度
            ,docimportance -- 文档重要性
            ,docsecret -- 文档密级
            ,docstage -- 所属阶段
            ,docsource -- 文档来源
            ,docunit -- 编制单位
            ,docdate -- 编制日期
            ,docorganizer -- 编制人
            ,dockeyword -- 文档主体词
            ,docabstract -- 文档摘要
            ,doclocation -- 文档保存位置
            ,docattribute -- 文档性质
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,olddocno -- 迁移前文档编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_doc_library_op(
            docno -- 文档编号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,doctitle -- 文档名称
            ,doctype -- 文档类型
            ,doclength -- 文档长度
            ,docimportance -- 文档重要性
            ,docsecret -- 文档密级
            ,docstage -- 所属阶段
            ,docsource -- 文档来源
            ,docunit -- 编制单位
            ,docdate -- 编制日期
            ,docorganizer -- 编制人
            ,dockeyword -- 文档主体词
            ,docabstract -- 文档摘要
            ,doclocation -- 文档保存位置
            ,docattribute -- 文档性质
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,olddocno -- 迁移前文档编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.docno -- 文档编号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.doctitle -- 文档名称
    ,o.doctype -- 文档类型
    ,o.doclength -- 文档长度
    ,o.docimportance -- 文档重要性
    ,o.docsecret -- 文档密级
    ,o.docstage -- 所属阶段
    ,o.docsource -- 文档来源
    ,o.docunit -- 编制单位
    ,o.docdate -- 编制日期
    ,o.docorganizer -- 编制人
    ,o.dockeyword -- 文档主体词
    ,o.docabstract -- 文档摘要
    ,o.doclocation -- 文档保存位置
    ,o.docattribute -- 文档性质
    ,o.remark -- 备注
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.olddocno -- 迁移前文档编号
    ,o.migtflag -- 
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
from ${iol_schema}.icms_doc_library_bk o
    left join ${iol_schema}.icms_doc_library_op n
        on
            o.docno = n.docno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_doc_library_cl d
        on
            o.docno = d.docno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_doc_library;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_doc_library') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_doc_library drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_doc_library add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_doc_library exchange partition p_${batch_date} with table ${iol_schema}.icms_doc_library_cl;
alter table ${iol_schema}.icms_doc_library exchange partition p_20991231 with table ${iol_schema}.icms_doc_library_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_doc_library to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_doc_library_op purge;
drop table ${iol_schema}.icms_doc_library_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_doc_library_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_doc_library',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
